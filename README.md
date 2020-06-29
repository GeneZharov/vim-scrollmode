vim-scroll-mode
===============

TODO

### g:OnScrollModeQuite
Funcref that is called on quit from the scroll mode.

```
function! s:fn() abort
  echo "scroll mode is over..."
endfunction

let g:OnScrollModeQuit = function("s:fn")
```
