function! scrollmode#toggle#toggle() abort
  if (exists("w:scrollmode_enabled"))
    call scrollmode#disable#disable()
  else
    call scrollmode#enable#enable()
  endif
endfunction
