function s:cmd(str) abort
  return (has("nvim") ? "<Cmd>" : ":<C-u>") . a:str
endfunction

" Can't map <Esc> to "exit" because it conflicts with mappings like <Up> or
" <Down> in Vim (though in Neovim works).
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

function! s:has_statusline_plugin() abort
  return
    \ get(g:, "loaded_airline", v:false) ||
    \ get(g:, "powerline_loaded", v:false) ||
    \ get(g:, "loaded_lightline", v:false)
endfunction

function! s:echo_mode() abort
  echo "-- SCROLL --"
endfunction

function! s:highlight() abort
  if line("w0") == 1 || line("w$") == line("$")
    highlight! link StatusLine DiffChange
  else
    highlight! link StatusLine DiffAdd
  endif
  redraw!
endfunction

function! s:on_motion() abort
  if g:scrollmode_hi_statusline
    call s:highlight()
  endif
  if g:scrollmode_cmd_indicator
    call s:echo_mode()
  endif
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

function! s:valid_map(map) abort
  return
    \ type(a:map) == v:t_dict &&
    \ scrollmode#util#all(
    \   values(a:map),
    \   {_, x -> type(x) == v:t_list}
    \ ) &&
    \ scrollmode#util#all(
    \   scrollmode#util#unnest(values(a:map)),
    \   {_, x -> type(x) == v:t_string}
    \ )
endfunction

function! s:valid_conf() abort
  if (!s:valid_map(g:scrollmode_actions))
    echoerr "g:scrollmode_actions has wrong type"
    return v:false
  endif
  if (!s:valid_map(g:scrollmode_mappings))
    echoerr "g:scrollmode_mappings has wrong type"
    return v:false
  endif
  if (type(g:scrollmode_step) != v:t_number)
    echoerr "g:scrollmode_step must be a number"
    return v:false
  endif
  return v:true
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
  if (!s:valid_conf())
    return
  endif

  if (line("$") == 1)
    " No scrolling for new buffers because WinLeave is not triggered for them
    echo "ScrollMode: Nothing to scroll"
    return
  endif

  let filename = expand("%:p")
  let actions = extend(copy(s:default_actions), g:scrollmode_actions)
  let mappings = g:scrollmode_mappings
  let step = g:scrollmode_step

  " Window variables
  let w:scrollmode_cursor_pos = getpos(".")
  let w:scrollmode_enabled = v:true
  let w:scrollmode_scrolloff = &scrolloff
  let w:scrollmode_cuc = &cuc
  let w:scrollmode_mapped_keys = s:affected_keys([actions, mappings])
  let w:scrollmode_dumped_keys = scrollmode#util#dump_mappings(
    \ w:scrollmode_mapped_keys,
    \ "n",
    \ v:false
    \ )

  normal! M

  if (g:scrollmode_cmd_indicator)
    echohl ModeMsg
  endif

  call s:on_motion()

  " Options
  set scrolloff=999
  setlocal nocuc

  " Mappings
  call s:map_motion(actions.down, step . "gjg^")
  call s:map_motion(actions.up, step . "gkg^")
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
