let g:scrollmode#const#state_init = "STATE_INIT"
let g:scrollmode#const#state_top = "STATE_TOP"
let g:scrollmode#const#state_middle = "STATE_MIDDLE"
let g:scrollmode#const#state_bottom = "STATE_BOTTOM"

let g:scrollmode#const#default_actions = {
  \ "up": ["k", "<Up>"],
  \ "down": ["j", "<Down>"],
  \ "pagedown": ["l"],
  \ "pageup": ["h"],
  \ "bottom": ["b"],
  \ "top": ["u"],
  \ "exit": [";"],
  \ "bdelete": ["-"]
  \ }
  " Can't map <Esc> to "exit" because it breaks mappings like <Up> and <Down>
  " in Vim (though in Neovim works fine).
