Vim ScrollMode
===============

```vim
let g:scroll_mode_mappings = {
  \ ":Bdelete<CR>": ["-"]
  \ }

nmap ξ{main}; <Plug>ScrollMode
```

TODO

`g:scrollmode_actions`
`g:scrollmode_mappings`
`g:scrollmode_distance`

`g:scrollmode_cmdline_indicator`
`g:scrollmode_airline_indicator`
`g:scrollmode_statusline_highlight`

`g:scrollmode_statusline_group`
`g:scrollmode_statusline_group_edge`

### `g:ScrollmodeOnQuite`
Funcref that is called on quit from the scroll mode.

```vim
function! s:fn() abort
  echo "scroll mode is over..."
endfunction

let g:ScrollmodeOnQuit = function("s:fn")
```
