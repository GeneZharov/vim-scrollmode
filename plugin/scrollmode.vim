if (exists("g:loaded_scroll_mode") && g:loaded_scroll_mode)
  finish
endif
let g:loaded_scroll_mode = v:true

command ScrollMode call scrollmode#toggle#toggle()

nnoremap <Plug>ScrollmodeToggle :<C-u>call scrollmode#toggle#toggle()<CR>
