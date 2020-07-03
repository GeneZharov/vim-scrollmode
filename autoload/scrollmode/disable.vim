function! scrollmode#disable#disable() abort
  for lhs in w:scrollmode_mapped_keys
    exe "nunmap <buffer> <script>" lhs
  endfor

  call scrollmode#tools#restore_mappings(w:scrollmode_dumped_keys)

  " Restore status line highlighting
  if g:scrollmode_statusline_highlight
    call scrollmode#tools#restore_highlight(w:scrollmode_groups)
    unlet w:scrollmode_groups
  endif

  " Clear the command line
  if (g:scrollmode_cmdline_indicator)
    echohl None
    echo ""
  endif

  " Restore options
  exe "set scrolloff=" . w:scrollmode_scrolloff
  if w:scrollmode_cursorcolumn | setlocal cursorcolumn | endif

  " Restore cursor position if possible
  if type(w:scrollmode_cursor_pos) == v:t_list
    call setpos(".", w:scrollmode_cursor_pos)
  endif

  unlet w:scrollmode_state
  unlet w:scrollmode_enabled
  unlet w:scrollmode_cursor_pos
  unlet w:scrollmode_mapped_keys
  unlet w:scrollmode_dumped_keys
  unlet w:scrollmode_scrolloff
  unlet w:scrollmode_cursorcolumn

  au! scrollmode CursorMoved,InsertEnter,WinLeave,BufWinLeave

  if exists("g:ScrollmodeOnQuit")
    call g:ScrollmodeOnQuit()
  endif
endfunction
