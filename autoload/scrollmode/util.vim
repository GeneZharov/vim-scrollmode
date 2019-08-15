function! scrollmode#util#all(list, test)
  let i = 0
  while (i < len(a:list))
    if (!a:test(i, a:list[i]))
      return 0
    endif
    let i += 1
  endwhile
  return 1
endfunction

function! scrollmode#util#unnest(list)
  let result = []
  for sublist in a:list
    call extend(result, sublist)
  endfor
  return result
endfunction

function! scrollmode#util#reduce(list, iterator, initial)
  let i = 0
  let acc = a:initial
  while (i < len(a:list))
    let acc = a:iterator(acc, i, a:list[i])
    let i += 1
  endwhile
  return acc
endfunction

function! scrollmode#util#dump_mappings(keys, mode, global) abort
  " Based on: https://vi.stackexchange.com/questions/7734/how-to-save-and-restore-a-mapping/7735
  let mappings = {}
  if a:global
    for l:key in a:keys
      let buf_local_map = maparg(l:key, a:mode, 0, 1)
      silent! exe a:mode . "unmap <buffer> " . l:key
      let map_info = maparg(l:key, a:mode, 0, 1)
      let mappings[l:key] = !empty(map_info)
        \ ? map_info
        \ : {
          \ "unmapped": 1,
          \ "buffer": 0,
          \ "lhs": l:key,
          \ "mode": a:mode,
          \ }
      call Restore_mappings({ l:key : buf_local_map })
    endfor
  else
    for l:key in a:keys
      let map_info = maparg(l:key, a:mode, 0, 1)
      let mappings[l:key] = !empty(map_info)
        \ ? map_info
        \ : {
          \ "unmapped": 1,
          \ "buffer": 1,
          \ "lhs": l:key,
          \ "mode": a:mode,
          \ }
    endfor
  endif
  return mappings
endfunction

function! scrollmode#util#restore_mappings(mappings) abort
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
