function! scrollmode#util#all(list, test) abort
  let i = 0
  while i < len(a:list)
    if !a:test(i, a:list[i])
      return v:false
    endif
    let i += 1
  endwhile
  return v:true
endfunction

function! scrollmode#util#unnest(list) abort
  let result = []
  for sublist in a:list
    call extend(result, sublist)
  endfor
  return result
endfunction

function! scrollmode#util#reduce(list, iterator, initial) abort
  let i = 0
  let acc = a:initial
  while i < len(a:list)
    let acc = a:iterator(acc, i, a:list[i])
    let i += 1
  endwhile
  return acc
endfunction

function! scrollmode#util#difference(xs, ys) abort
  let _xs = []
  for x in a:xs
    if index(a:ys, x) == -1
      call add(_xs, x)
    endif
  endfor
  return _xs
endfunction

function scrollmode#util#to_unix_path(path) abort
  return substitute(a:path, "\\", "/", "g")
endfunction
