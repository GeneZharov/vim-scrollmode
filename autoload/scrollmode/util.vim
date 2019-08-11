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
