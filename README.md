# Scroll Mode for Vim

“Scroll mode” is a new mode for Vim that allows to scroll a text buffer with
classical `h`/`j`/`k`/`l` bindings and some others, that are all designed for
one-hand usage. Forget about `<C-f>`, `<C-d>`, and `G`. You don't need to keep
holding modifier keys anymore — everything can be done with single-key
mappings!

New key mappings available in the Scroll mode:

- `j` / `k` — scroll 5 lines down / up
- `l` / `h` — scroll page down / up
- `b` — scroll to the ending of the buffer (bottom)
- `u` — scroll to the beginning of the buffer (up)
- `;` — quit the Scroll mode
- `-` — quit the Scroll mode and delete the buffer

With these mappings, you can quickly look around, walk through several screens
of text, and when you are in the right place return back to normal mode for
more accurate text manipulations.

![Demo](https://github.com/GeneZharov/vim-scrollmode/blob/master/demo.gif?raw=true)

For example, compare this scenario of a scrolling session in normal mode and in
Scroll mode.

|     | Normal Mode                     | Scroll Mode              |
| --- | ------------------------------- | ------------------------ |
| 1.  | `shift` `g`                     | `b`                      |
| 2.  | `ctrl` `b`                      | `h`                      |
| 3.  | `ctrl` `b`                      | `h`                      |
| 4.  | `k` `k` `k` `k` `k` `k` `k` `k` | `j` `j`                  |
|     | 13 keys (including 3 modifiers) | 5 keys, all for one hand |

Since Scroll mode is in fact just a wrapper around normal mode, all keys, that
are not remapped by Scroll mode continue to be available: searching (`/`, `?`,
`n`, `N`), window managing (`<C-w>`), etc.

If you enter another mode (Command mode, Insert mode, etc.) while Scroll mode
is active, then it will be implicitly automatically finished, all Normal mode
mappings will be restored, and you will be able to proceed in the mode of your
choice.

## Installation

| Plugin Manager                                         | Command                                                                                          |
| ------------------------------------------------------ | ------------------------------------------------------------------------------------------------ |
| [vim-plug](https://github.com/junegunn/vim-plug)       | `Plug 'GeneZharov/vim-scrollmode'`                                                               |
| [vundle](https://github.com/VundleVim/Vundle.vim)      | `Plugin 'GeneZharov/vim-scrollmode'`                                                             |
| [pathogen.vim](https://github.com/tpope/vim-pathogen/) | `git clone 'git@github.com:GeneZharov/vim-scrollmode.git' ~/.vim/bundle/vim-scrollmode`          |
| native pack<br />(`:h packages`)                       | `git clone 'git@github.com:GeneZharov/vim-scrollmode.git' ~/.vim/pack/dist/start/vim-scrollmode` |

Set a preferred shortcut to enter the Scroll mode:

```vim
nmap <Leader>; <Plug>ScrollMode
```

I prefer to use Scroll mode with a `<Space>` as my `<Leader>` key:

```vim
" Place it before all the <Leader> mappings
map <SPACE> <Nop>
let mapleader = "\<Space>"
```

## Configuration

### Scrolling Settings

- **`g:scrollmode_actions`**

  This option allows to configure default Scroll mode key mappings. These
  key mappings are internally set with the following dictionary.

  ```vim
  \ {
  \ "up": ["k", "<Up>"],
  \ "down": ["j", "<Down>"],
  \ "pagedown": ["l"],
  \ "pageup": ["h"],
  \ "bottom": ["b"],
  \ "top": ["u"],
  \ "exit": [";"],
  \ "bdelete": ["-"]
  \ }
  ```

  You can specify any subset of this dictionary as a value for this option in
  order to override default mappings.

  For example, to add `<Esc>` key to the keys that exit the Scroll mode:

  ```vim
  let g:scrollmode_actions = {
    \ "exit": [";", "<Esc>"],
    \ }
  ```

  _I didn't make `<Esc>` to quit the Scroll mode as default behavior, because
  in the terminal Vim (but not Neovim) it can break some complex keys like
  `<Up>` and `<Down>` while the Scroll mode is active. If you are not going
  to use these keys in the Scroll mode or if you use a different Vim version
  (GVim, Neovim), then you are welcome to use the config from the example
  above._

- **`g:scrollmode_mappings`**

  With this option, you can specify new mappings available in the Scroll
  mode. This option has precedence over `g:scrollmode_actions`, so you can
  rebind a default action with any custom command.

  For example, let's add a custom command for buffer deletion:

  ```vim
  let g:scrollmode_mappings = {
    \ ":Bdelete<CR>": ["-", "c"]
    \ }
  ```

  When the Scroll mode is activated, this code will internally result to:

  ```vim
  nnoremap <silent> <buffer> - :Bdelete<CR>
  nnoremap <silent> <buffer> c :Bdelete<CR>
  ```

- **`g:scrollmode_distance`**

  Number of lines to scroll at once by `j` / `k` (`"up"` and `"down"`
  actions).

  _Default:_ `5`

### Scrolling Indicators

- **`g:scrollmode_cmdline_indicator`**

  Enables or disables the Scroll mode indicator in the command line. The
  indicator looks similar to other indicators for built-in modes and looks
  like this:

  ```
  -- SCROLL --
  ```

  _Default:_ `v:true`

- **`g:scrollmode_statusline_highlight`**

  Enables or disables StatusLine highlighting, when the Scroll mode is
  activated. Has no effect with plugins that replace the status line
  ([Airline](https://github.com/vim-airline/vim-airline),
  [Powerline](https://github.com/powerline/powerline),
  [Lightline](https://github.com/itchyny/lightline.vim)).

  _I am not fully satisfied with how this feature works, so it is disabled by
  default. But if you need Scroll mode to be more noticeable and colorful,
  then you can enable this option. See the options below for color
  customization._

  _Default:_ `v:false`

### Highlight Groups

Options for status line color customization. Only have effect if
`g:scrollmode_statusline_highlight` is enabled.

- **`g:scrollmode_statusline_group`**

  Highlight group that is used for `StatusLine` when the Scroll mode
  is active.

  _Default:_ `"DiffAdd"`

- **`g:scrollmode_statusline_group_edge`**

  Highlight group that is used for `StatusLine` when the Scroll mode is
  active and the top/bottom edge of the buffer is reached. The color helps to
  notice that you can't scroll in that direction anymore. Specify `v:null` if
  you don't need this behavior.

  _Default:_ `"DiffChange"`

### Hooks

- **`g:ScrollmodeOnQuit`**

  Funcref that is called after you exit the Scroll mode.

  ```vim
  function! s:fn() abort
    " ... your code
  endfunction

  let g:ScrollmodeOnQuit = function("s:fn")
  ```

## License

MIT license
