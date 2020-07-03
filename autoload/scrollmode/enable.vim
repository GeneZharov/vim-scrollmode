let s:STATE_INIT = "STATE_INIT"
let s:STATE_TOP = "STATE_TOP"
let s:STATE_MIDDLE = "STATE_MIDDLE"
let s:STATE_BOTTOM = "STATE_BOTTOM"

function s:cmd(cmd) abort
  return (has("nvim") ? "<Cmd>" : ":<C-u>") . a:cmd
endfunction

let s:default_actions = {
  \ "up": ["k", "<Up>"],
  \ "down": ["j", "<Down>"],
  \ "pagedown": ["l"],
  \ "pageup": ["h"],
  \ "bottom": ["b"],
  \ "top": ["<Space>"],
  \ "exit": [";"],
  \ "bdelete": ["-"]
  \ }
  " Can't map <Esc> to "exit" because it breaks mappings like <Up> and <Down>
  " in Vim (though in Neovim works fine).

function! s:detect_state() abort
  if line("w0") == 1
    return s:STATE_TOP
  elseif line("w$") == line("$")
    return s:STATE_BOTTOM
  else
    return s:STATE_MIDDLE
  endif
endfunction

function! s:echo_mode(new_state) abort
  if !has("nvim") || w:scrollmode_state == s:STATE_INIT
    redraw
    echo "-- SCROLL --"
  endif
endfunction

function! s:highlight(new_state) abort
  if a:new_state != w:scrollmode_state
    if a:new_state == s:STATE_MIDDLE
      exe "highlight! link StatusLine" g:scrollmode_statusline_group
    else
      exe "highlight! link StatusLine" g:scrollmode_statusline_group_edge
    endif
    redraw!
  endif
endfunction

function! s:on_motion() abort
  let new_state = s:detect_state()
  if g:scrollmode_statusline_highlight
    call s:highlight(new_state)
  endif
  if g:scrollmode_cmdline_indicator
    call s:echo_mode(new_state)
  endif
  let w:scrollmode_state = new_state
endfunction

function! <SID>gen_motion(rhs) abort
  let w:scrollmode_cursor_pos = v:null
  return a:rhs
endfunction

function! s:map(keys, rhs) abort
  for lhs in a:keys
    exe "nnoremap <silent> <buffer>" lhs a:rhs
  endfor
endfunction

function! s:map_motion(keys, rhs) abort
  for lhs in a:keys
    exe printf(
      \ "nnoremap <silent> <buffer> <expr> %s <SID>gen_motion(\"%s\")",
      \ lhs,
      \ escape(a:rhs, '"')
      \ )
  endfor
endfunction

function! s:affected_keys(dicts) abort
  let mappings = scrollmode#util#reduce(
    \ a:dicts,
    \ {acc, _, dict -> acc + values(dict)},
    \ []
    \ )
  return uniq(sort(scrollmode#util#unnest(mappings)))
endfunction

function! scrollmode#enable#enable() abort
  if !scrollmode#valid#valid_conf()
    return
  endif

  if line("$") == 1
    " No scrolling for new buffers because WinLeave is not triggered for them.
    echo "ScrollMode: Nothing to scroll"
    return
  endif

  if scrollmode#tools#has_statusline_plugin()
    let g:scrollmode_hi_statusline = v:false
  endif

  let filename = expand("%:p")
  let actions = extend(copy(s:default_actions), g:scrollmode_actions)
  let mappings = g:scrollmode_mappings
  let distance = g:scrollmode_distance

  " Window variables
  let w:scrollmode_enabled = v:true
  let w:scrollmode_state = s:STATE_INIT
  let w:scrollmode_scrolloff = &scrolloff
  let w:scrollmode_cursorcolumn = &cursorcolumn
  let w:scrollmode_cursor_pos = getpos(".")
  let w:scrollmode_mapped_keys = s:affected_keys([actions, mappings])
  let w:scrollmode_dumped_keys = scrollmode#tools#dump_mappings(
    \ w:scrollmode_mapped_keys, "n", v:false)

  if g:scrollmode_statusline_highlight
    let w:scrollmode_groups = scrollmode#tools#backup_highlight(["StatusLine"])
  endif

  if g:scrollmode_cmdline_indicator
    echohl ModeMsg
  endif

  normal! M

  call s:on_motion()

  " Options
  set scrolloff=999
  setlocal nocuc

  " Mappings
  call s:map_motion(actions.down, distance . "gjg^")
  call s:map_motion(actions.up, distance . "gkg^")
  call s:map_motion(actions.pagedown, "<C-f>M")
  call s:map_motion(actions.pageup, "<C-b>M")
  call s:map_motion(actions.bottom, "GM")
  call s:map_motion(actions.top, "ggM")
  call s:map(actions.exit, s:cmd("call scrollmode#disable#disable()<CR>"))
  call s:map(actions.bdelete, s:cmd("call scrollmode#disable#disable() \\| bd<CR>"))

  for mapping in items(mappings)
    call s:map(mapping[1], mapping[0])
  endfor

  augroup scrollmode
    au CursorMoved * call s:on_motion()
    au InsertEnter * call scrollmode#disable#disable()
    exe printf(
      \ "au WinLeave,BufWinLeave %s call scrollmode#disable#disable()",
      \ escape(scrollmode#util#to_unix_path(filename), "^$.~*[ ")
      \ )
  augroup END
endfunction
