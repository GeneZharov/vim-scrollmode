if (exists("g:loaded_scroll_mode") && g:loaded_scroll_mode)
  finish
endif
let g:loaded_scroll_mode = v:true

if has("nvim")
  nnoremap <Plug>ScrollMode <Cmd>call scrollmode#toggle#toggle()<CR>
else
  nnoremap <Plug>ScrollMode :<C-u>call scrollmode#toggle#toggle()<CR>
endif
