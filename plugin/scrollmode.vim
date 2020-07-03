if (exists("g:scrollmode_loaded") && g:scrollmode_loaded)
  finish
endif
let g:scrollmode_loaded = v:true

let g:scrollmode_actions = get(g:, "scrollmode_actions", {})
let g:scrollmode_mappings = get(g:, "scrollmode_mappings", {})
let g:scrollmode_distance = get(g:, "scrollmode_distance", 5)

let g:scrollmode_cmdline_indicator = get(
  \ g:, "scrollmode_cmdline_indicator", v:true)
let g:scrollmode_airline_indicator = get(
  \ g:, "scrollmode_airline_indicator", v:true)
let g:scrollmode_statusline_highlight = get(
  \ g:, "scrollmode_statusline_highlight", v:true)

let g:scrollmode_statusline_group = get(
  \ g:, "scrollmode_statusline_group", "DiffAdd")
let g:scrollmode_statusline_group_edge = get(
  \ g:, "scrollmode_statusline_group_edge", "DiffChange")

if has("nvim")
  nnoremap <Plug>ScrollMode <Cmd>call scrollmode#toggle#toggle()<CR>
else
  nnoremap <Plug>ScrollMode :<C-u>call scrollmode#toggle#toggle()<CR>
endif
