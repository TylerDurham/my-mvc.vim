# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repo Is

A single-file "minimal viable config" for Vim. The entire config lives in `.vimrc` and is designed to be curl-installable directly to `~/.vimrc`.

## Architecture

Everything is in `.vimrc` — no plugin manager dependency (vim-plug, etc.). Instead, a self-contained `s:ensure(repo)` function handles lazy plugin cloning via `git clone --depth=1` into `~/.vim/plugged/` and adds the directory to `&runtimepath` on each startup.

Plugins used:
- **junegunn/fzf** + **fzf.vim** — fuzzy file/buffer/grep navigation (`<leader>f*` bindings)
- **ghifarit53/tokyonight-vim** / **k4yt3x/ayu-vim-darker** — colorschemes (ayu darker active)
- **itchyny/lightline.vim** — statusline with git branch via `FugitiveHead`

Leader key is `<Space>`. `jj` exits insert mode.

## Install

```bash
curl -L https://snork.sh/mvcvim > ~/.vimrc
```

The canonical install URL serves `.vimrc` directly from this repo.
