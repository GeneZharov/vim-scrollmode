let s:space = g:airline_symbols.space " recommended to avoid rendering issues

function! airline#extensions#scrollmode#get_marker() abort
  return get(w:, "scroll_mode_enabled", v:false)
    \ ? "(SCROLL)" . s:space
    \ : ""
endfunction

function! airline#extensions#scrollmode#apply(...) abort
  let w:airline_section_z = get(w:, "airline_section_z", g:airline_section_z)
  let w:airline_section_z =
    \ "%{airline#extensions#scrollmode#get_marker()}" .
    \ w:airline_section_z
endfunction

function! airline#extensions#scrollmode#init(ext) abort
  " Allow users to place this extension in arbitrary locations
  call airline#parts#define_raw(
    \ "scrollmode",
    \ "%{airline#extensions#scrollmode#get_marker()}"
    \ )

  call a:ext.add_statusline_func("airline#extensions#scrollmode#apply")
endfunction
