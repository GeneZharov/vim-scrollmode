if get(g:, "scrollmode_loaded", v:false)
  finish
endif
let g:scrollmode_loaded = v:true

if has("nvim")
  nnoremap <Plug>ScrollMode <Cmd>call scrollmode#toggle#toggle()<CR>
else
  nnoremap <Plug>ScrollMode :<C-u>call scrollmode#toggle#toggle()<CR>
endif
