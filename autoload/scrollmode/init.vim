function! scrollmode#init#init_globals() abort
  if get(g:, "scrollmode_initialized", v:false)
    return
  endif
  let g:scrollmode_initialized = v:true

  let g:scrollmode_actions =
    \ get(g:, "scrollmode_actions", {})
  let g:scrollmode_mappings =
    \ get(g:, "scrollmode_mappings", {})
  let g:scrollmode_distance =
    \ get(g:, "scrollmode_distance", 5)

  let g:scrollmode_cmdline_indicator =
    \ get(g:, "scrollmode_cmdline_indicator", v:true)
  let g:scrollmode_statusline_highlight =
    \ get(g:, "scrollmode_statusline_highlight", v:false)
  let g:scrollmode_airline_indicator =
    \ scrollmode#tools#has_statusline_plugin()
    \   ? v:false
    \   : get(g:, "scrollmode_airline_indicator", v:false)

  let g:scrollmode_statusline_group =
    \ get(g:, "scrollmode_statusline_group", "DiffAdd")
  let g:scrollmode_statusline_group_edge =
    \ get(g:, "scrollmode_statusline_group_edge", "DiffChange")
endfunction
