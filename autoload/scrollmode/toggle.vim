function! scrollmode#toggle#toggle() abort
  if get(w:, "scrollmode_enabled", v:false)
    call scrollmode#disable#disable()
  else
    call scrollmode#enable#enable()
  endif
endfunction
