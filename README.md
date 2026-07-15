# my-mvc.vim

My "minimally viable config" for Vim. Easy to install on a server with one command. Lightweight and fast.

![screenshot](media/screenshot.png)

## Install

Download and install:

```shell
curl -L https://snork.sh/mvcvim > ~/.vimrc
```

## Features

- Fuzzy file/buffer/grep search via fzf (`<Space>ff`, `<Space>fg`, `<Space>fs`, etc.)
- Ayu darker colorscheme
- Lightline statusline with git branch
- No plugin manager required — plugins self-install on first launch via `git clone`

## Keybinds

Leader key is `<Space>`. `jj` exits insert mode.

| Binding | Action |
|---|---|
| `<leader>ff` | Fuzzy find files |
| `<leader>fo` | Recent files |
| `<leader>fb` | Buffers |
| `<leader>fs` | Grep word under cursor |
| `<leader>fg` | Grep prompt |
| `<leader>fc` | Grep current filename |
| `<leader>fi` | Find files in `~/.vim` |
| `<leader>fh` | Help tags |
