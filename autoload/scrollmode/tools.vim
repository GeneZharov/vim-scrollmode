function! scrollmode#tools#has_statusline_plugin() abort
  return
    \ get(g:, "loaded_airline", v:false) ||
    \ get(g:, "powerline_loaded", v:false) ||
    \ get(g:, "loaded_lightline", v:false)
endfunction

function! scrollmode#tools#dump_mappings(keys, mode, global) abort
  " Based on: https://vi.stackexchange.com/questions/7734/how-to-save-and-restore-a-mapping/7735
  let mappings = {}
  if a:global
    for l:key in a:keys
      let buf_local_map = maparg(l:key, a:mode, v:false, v:true)
      silent! exe a:mode . "unmap <buffer>" l:key
      let map_info = maparg(l:key, a:mode, v:false, v:true)
      let mappings[l:key] = !empty(map_info)
        \ ? map_info
        \ : {
          \ "unmapped": v:true,
          \ "buffer": v:false,
          \ "lhs": l:key,
          \ "mode": a:mode,
          \ }
      call scrollmode#tools#restore_mappings({ l:key : buf_local_map })
    endfor
  else
    for l:key in a:keys
      let map_info = maparg(l:key, a:mode, v:false, v:true)
      let mappings[l:key] = !empty(map_info)
        \ ? map_info
        \ : {
          \ "unmapped": v:true,
          \ "buffer": v:true,
          \ "lhs": l:key,
          \ "mode": a:mode,
          \ }
    endfor
  endif
  return mappings
endfunction

function! scrollmode#tools#restore_mappings(mappings) abort
  " Based on: https://vi.stackexchange.com/questions/7734/how-to-save-and-restore-a-mapping/7735
  for mapping in values(a:mappings)
    if !has_key(mapping, "unmapped") && !empty(mapping)
      exe mapping.mode
        \ . (mapping.noremap ? "noremap   " : "map ")
        \ . (mapping.buffer  ? " <buffer> " : "")
        \ . (mapping.expr    ? " <expr>   " : "")
        \ . (mapping.nowait  ? " <nowait> " : "")
        \ . (mapping.silent  ? " <silent> " : "")
        \ .  mapping.lhs
        \ . " "
        \ . substitute(
          \ escape(mapping.rhs, "|"),
          \ "<SID>",
          \ "<SNR>".mapping.sid."_",
          \ "g"
          \ )
    elseif has_key(mapping, "unmapped")
      silent! exe mapping.mode."unmap "
        \ .(mapping.buffer ? " <buffer> " : "")
        \ . mapping.lhs
    endif
  endfor
endfunction

function! scrollmode#tools#backup_highlight(groups)
  " Based on: https://github.com/oblitum/goyo.vim/blob/master/autoload/goyo.vim
  silent! exe "redir => backup | " .
                \ join(map(copy(a:groups), "'hi ' . v:val"), " | ") .
                \ " | redir END"
  return backup
endfunction

function! scrollmode#tools#restore_highlight(highlighting_backup)
  " Based on: https://github.com/oblitum/goyo.vim/blob/master/autoload/goyo.vim
  let hls = map(split(a:highlighting_backup, '\v\n(\S)@='),
              \ {_, v -> substitute(v, '\v\C(<xxx>|\s|\n)+', " ", "g")})
  for hl in hls
    let chunks = split(hl)
    let grp = chunks[0]
    let tail = join(chunks[1:])
    exe "hi clear" grp
    if tail !=# "cleared"
      let attrs = split(tail, '\v\c(<links\s+to\s+)@=')
      for attr in attrs
        if attr =~? '\v\c^links\s+to\s+'
          exe printf("hi! link %s %s", grp,
                       \ substitute(attr, '\v\c^links\s+to\s+', "", ""))
        else
          exe printf("hi %s %s", grp, attr)
        endif
      endfor
    endif
  endfor
endfunction
