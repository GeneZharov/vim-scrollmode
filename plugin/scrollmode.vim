if (exists("g:loaded_scroll_mode") && g:loaded_scroll_mode)
  finish
endif
let g:loaded_scroll_mode = 1

command ScrollMode call scrollmode#toggle#toggle()
