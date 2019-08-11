let s:default_step = 5

let s:default_actions = {
  \ "up": ["k", "<Up>"],
  \ "down": ["j", "<Down>"],
  \ "pagedown": ["l"],
  \ "pageup": ["h"],
  \ "bottom": ["b"],
  \ "top": ["<Space>"],
  \ "exit": [";", "<Esc>"],
  \ "bdelete": ["-"]
  \ }

function! s:echo_mode()
  echo '-- SCROLL --'
endfunction

function! <SID>on_motion()
  if (exists("w:scroll_mode_enabled"))
    call s:echo_mode()
  else
    echo ""
  endif
endfunction

function! s:map(keys, rhs)
  for lhs in a:keys
    exe printf("nnoremap <buffer> %s %s:call <SID>on_motion()<CR>", lhs, a:rhs)
  endfor
endfunction

function! s:valid_map(map)
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

function! s:valid_conf()
  if (
    \ exists("g:scroll_mode_actions") &&
    \ !s:valid_map(g:scroll_mode_actions)
    \ )
    echoerr "g:scroll_mode_actions has wrong type"
    return 0
  endif
  if (
    \ exists("g:scroll_mode_mappings") &&
    \ !s:valid_map(g:scroll_mode_mappings)
    \ )
    echoerr "g:scroll_mode_mappings has wrong type"
    return 0
  endif
  if (
    \ exists("g:scroll_mode_step") &&
    \ type(g:scroll_mode_step) != v:t_number
    \ )
    echoerr "g:scroll_mode_step must be a number"
    return 0
  endif
  return 1
endfunction

function! scrollmode#enable#enable()
  if (!s:valid_conf())
    return
  endif

  if (line('$') == 1)
    " No scrolling for new buffers because WinLeave is not triggered for them
    echo "ScrollMode: Nothing to scroll"
    return
  endif

  let filename = expand("%:p")
  let step = exists("g:scroll_mode_step") ? g:scroll_mode_step : s:default_step

  " Window variables
  let w:scroll_mode_enabled = 1
  let w:scroll_mode_scrolloff = &scrolloff
  let w:scroll_mode_cul = &cul
  let w:scroll_mode_cuc = &cuc
  let w:scroll_mode_actions = extend(
    \ copy(s:default_actions),
    \ exists("g:scroll_mode_actions") ? g:scroll_mode_actions : {}
    \ )
  let w:scroll_mode_mappings = exists("g:scroll_mode_mappings")
    \ ? g:scroll_mode_mappings
    \ : []

  normal! M

  echohl ModeMsg
  call s:echo_mode()

  " Options
  set scrolloff=999
  setlocal cul
  setlocal nocuc

  " Mappings
  call s:map(w:scroll_mode_actions.down, step . "jM")
  call s:map(w:scroll_mode_actions.up, step . "kM")
  call s:map(w:scroll_mode_actions.pagedown, "<C-f>M")
  call s:map(w:scroll_mode_actions.pageup, "<C-b>M")
  call s:map(w:scroll_mode_actions.bottom, "GM")
  call s:map(w:scroll_mode_actions.top, "ggM")
  call s:map(w:scroll_mode_actions.exit,
    \ ":call scrollmode#disable#disable()<CR>")
  call s:map(w:scroll_mode_actions.bdelete,
    \ ":call scrollmode#disable#disable()<CR>:bd<CR>")

  for mapping in items(w:scroll_mode_mappings)
    call s:map(mapping[1], mapping[0])
  endfor

  augroup scroll_mode
    au InsertEnter * call scrollmode#disable#disable()
    exe printf(
      \ "au WinLeave,BufWinLeave %s call scrollmode#disable#disable()",
      \ escape(filename, "^$.~*[ ")
      \ )
  augroup END
endfunction
