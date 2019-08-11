function! scrollmode#disable#disable()
  let mappings = values(w:scroll_mode_actions) + values(w:scroll_mode_mappings)
  for lhs in uniq(sort(scrollmode#util#unnest(mappings)))
    exe "nunmap <buffer> <script> " . lhs
  endfor

  echohl None
  echo ""

  " Options
  exe "set scrolloff=" . w:scroll_mode_scrolloff
  if !w:scroll_mode_cul | setlocal nocul | endif
  if w:scroll_mode_cuc | setlocal cuc | endif

  au! scroll_mode WinLeave,BufWinLeave,InsertEnter

  unlet w:scroll_mode_enabled
  unlet w:scroll_mode_actions
  unlet w:scroll_mode_mappings
  unlet w:scroll_mode_scrolloff
  unlet w:scroll_mode_cul
  unlet w:scroll_mode_cuc
endfunction
