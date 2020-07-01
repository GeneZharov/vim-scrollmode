function! scrollmode#disable#disable() abort
  for lhs in w:scrollmode_mapped_keys
    exe "nunmap <buffer> <script>" lhs
  endfor

  call scrollmode#util#restore_mappings(w:scrollmode_dumped_keys)

  if (g:scrollmode_cmd_indicator)
    echohl None
    echo ""
  endif

  if g:scrollmode_hi_statusline
    highlight! link StatusLine NONE
  endif

  " Options
  exe "set scrolloff=" . w:scrollmode_scrolloff
  if w:scrollmode_cuc | setlocal cuc | endif

  au! scrollmode CursorMoved,InsertEnter,WinLeave,BufWinLeave

  if type(w:scrollmode_cursor_pos) == v:t_list
    call setpos(".", w:scrollmode_cursor_pos)
  endif

  unlet w:scrollmode_enabled
  unlet w:scrollmode_cursor_pos
  unlet w:scrollmode_mapped_keys
  unlet w:scrollmode_dumped_keys
  unlet w:scrollmode_scrolloff
  unlet w:scrollmode_cuc

  if exists("g:ScrollmodeOnQuit")
    call g:ScrollmodeOnQuit()
  endif
endfunction
