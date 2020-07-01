if (exists("g:scrollmode_loaded") && g:scrollmode_loaded)
  finish
endif
let g:scrollmode_loaded = v:true

let g:scrollmode_actions = get(g:, "scrollmode_actions", {})
let g:scrollmode_mappings = get(g:, "scrollmode_mappings", {})
let g:scrollmode_step = get(g:, "scrollmode_step", 5)
let g:scrollmode_cmd_indicator = get(g:, "scrollmode_cmd_indicator", v:true)
let g:scrollmode_hi_statusline = get(g:, "scrollmode_statusline_hi", v:true)
let g:scrollmode_scrollable_group = get(g:, "g:scrollmode_scrollable_group", "DiffAdd")
let g:scrollmode_blocked_group = get(g:, "g:scrollmode_blocked_group", "DiffChange")


if has("nvim")
  nnoremap <Plug>ScrollMode <Cmd>call scrollmode#toggle#toggle()<CR>
else
  nnoremap <Plug>ScrollMode :<C-u>call scrollmode#toggle#toggle()<CR>
endif
