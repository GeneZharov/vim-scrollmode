function! s:valid_map(map) abort
  return
    \ type(a:map) == v:t_dict &&
    \ scrollmode#util#all(
    \   values(a:map),
    \   {_, x -> type(x) == v:t_list}
    \ ) &&
    \ scrollmode#util#all(
    \   scrollmode#util#unnest(values(a:map)),
    \   {_, x -> type(x) == v:t_string}
    \ )
endfunction

function! scrollmode#valid#valid_conf() abort
  if !s:valid_map(g:scrollmode_actions)
    echoerr "g:scrollmode_actions has wrong type"
    return v:false
  endif

  if !s:valid_map(g:scrollmode_mappings)
    echoerr "g:scrollmode_mappings has wrong type"
    return v:false
  endif

  if type(g:scrollmode_distance) != v:t_number
    echoerr "g:scrollmode_distance must be a number"
    return v:false
  endif

  if type(g:scrollmode_cmdline_indicator) != 6
    echoerr "g:scrollmode_cmdline_indicator must be a boolean"
    return v:false
  endif

  if type(g:scrollmode_airline_indicator) != 6
    echoerr "g:scrollmode_airline_indicator must be a boolean"
    return v:false
  endif

  if type(g:scrollmode_statusline_highlight) != 6
    echoerr "g:scrollmode_statusline_highlight must be a boolean"
    return v:false
  endif

  if type(g:scrollmode_statusline_group) != v:t_string
    echoerr "g:scrollmode_statusline_group must be a string"
    return v:false
  endif

  if type(g:scrollmode_statusline_group_edge) != v:t_string
    echoerr "g:scrollmode_statusline_group_edge must be a string"
    return v:false
  endif

  if exists("g:ScrollmodeOnQuit") && type(g:ScrollmodeOnQuit) != v:t_func
    echoerr "g:ScrollmodeOnQuit must be a Funcref"
    return v:false
  endif

  return v:true
endfunction
