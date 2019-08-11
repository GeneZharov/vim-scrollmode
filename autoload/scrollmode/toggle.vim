function! scrollmode#toggle#toggle()
  if (exists("w:scroll_mode_enabled"))
    call scrollmode#disable#disable()
  else
    call scrollmode#enable#enable()
  endif
endfunction
