function! scrollmode#disable#disable() abort
  for lhs in w:scroll_mode_mapped_keys
    exe "nunmap <buffer> <script>" lhs
  endfor

  call scrollmode#util#restore_mappings(w:scroll_mode_dumped_keys)

  echohl None
  echo ""

  highlight! link StatusLine NONE

  " Options
  exe "set scrolloff=" . w:scroll_mode_scrolloff
  if w:scroll_mode_cuc | setlocal cuc | endif

  au! scroll_mode CursorMoved,InsertEnter,WinLeave,BufWinLeave

  if type(w:scroll_mode_cursor_pos) == v:t_list
    call setpos(".", w:scroll_mode_cursor_pos)
  endif

  unlet w:scroll_mode_enabled
  unlet w:scroll_mode_cursor_pos
  unlet w:scroll_mode_mapped_keys
  unlet w:scroll_mode_dumped_keys
  unlet w:scroll_mode_scrolloff
  unlet w:scroll_mode_cuc

  if exists("g:OnScrollModeQuit")
    call g:OnScrollModeQuit()
  endif
endfunction
