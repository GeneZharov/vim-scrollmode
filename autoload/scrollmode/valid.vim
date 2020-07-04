function! s:valid_mappings(mappings) abort
  return
    \ type(a:mappings) == v:t_dict &&
    \ scrollmode#util#all(
    \   values(a:mappings),
    \   {_, x -> type(x) == v:t_list}
    \ ) &&
    \ scrollmode#util#all(
    \   scrollmode#util#unnest(values(a:mappings)),
    \   {_, x -> type(x) == v:t_string}
    \ )
endfunction

function! s:valid_actions(actions) abort
  let diff = scrollmode#util#difference(
    \ keys(a:actions),
    \ keys(g:scrollmode#const#default_actions)
    \ )
  return len(diff) == 0
endfunction

function! scrollmode#valid#valid_globals() abort
  if !s:valid_mappings(g:scrollmode_actions)
    echoerr "g:scrollmode_actions has a wrong type"
    return v:false
  endif

  if !s:valid_actions(g:scrollmode_actions)
    echoerr "g:scrollmode_actions contains an unknown key"
    return v:false
  endif

  if !s:valid_mappings(g:scrollmode_mappings)
    echoerr "g:scrollmode_mappings has a wrong type"
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
