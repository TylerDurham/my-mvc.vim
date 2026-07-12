" OPTIONS

filetype plugin indent on
set softtabstop=4
set smartindent
set showmatch
syntax on
" Line numbers
set number
set relativenumber

" Indentation and tabs
set tabstop=4
set shiftwidth=4
set autoindent
set expandtab

" Search
set ignorecase
set smartcase
set incsearch

" Appearance
set background=dark
set signcolumn=yes
set cursorline
set colorcolumn=80

" Backspace behavior
set backspace=indent,eol,start

" Split window behavior
set splitbelow
set splitright

" dw/diw/ciw treat dash-separated words as single word
set iskeyword+=-

" Keep cursor 8 lines from top/bottom
set scrolloff=8

" Cursor responsiveness
set updatetime=50

set laststatus=2

" =============================================================================
" KEYBINDS
" =============================================================================
" Set leader key
let mapleader = " " 

inoremap jj <Esc>

" Files
nnoremap <leader>ff :Files<CR>
nnoremap <leader>fo :History<CR>
nnoremap <leader>fb :Buffers<CR>
nnoremap <leader>fq :CList<CR>    " For quickfix list
nnoremap <leader>fh :Helptags<CR>

" Grep current string
nnoremap <leader>fs :Rg <C-r><C-w><CR>

" Grep input string (fzf prompt)
nnoremap <leader>fg :Rg<Space>

" Grep for current file name (without extension)
nnoremap <leader>fc :execute 'Rg ' . expand('%:t:r')<CR>

" Find files in your Vim config
nnoremap <leader>fi :Files ~/.vim<CR>

" =============================================================================
" PLUGINS
" =============================================================================
" plugins.vim - Dead simple plugin manager
" Just source this file in your vimrc
let s:plugin_dir = expand('~/.vim/plugged')

" TONY B's beautiful minimal plugin manager for Vim.
" https://github.com/tonybanters/vim/blob/master/plugins.vim

" Install a plugin if it doesn't exist
function! s:ensure(repo)
  let name = split(a:repo, '/')[-1]
  let path = s:plugin_dir . '/' . name
  
  if !isdirectory(path)
    if !isdirectory(s:plugin_dir)
      call mkdir(s:plugin_dir, 'p')
    endif
    execute '!git clone --depth=1 https://github.com/' . a:repo . ' ' . shellescape(path)
  endif
  
  execute 'set runtimepath+=' . fnameescape(path)
endfunction

" Download plugins
call s:ensure('junegunn/fzf')
call s:ensure('junegunn/fzf.vim')
call s:ensure('ghifarit53/tokyonight-vim')
call s:ensure('k4yt3x/ayu-vim-darker')
call s:ensure('itchyny/lightline.vim')

" =============================================================================
" THEMES & COLORS
" =============================================================================

set termguicolors

let ayucolor="darker"   " for dark version of theme
colorscheme ayu

" let g:tokyonight_style = 'night' " available: night, storm
" let g:tokyonight_enable_italic = 1

" colorscheme tokyonight

set laststatus=2
let g:lightline = {
      \ 'colorscheme' : 'ayu',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ],
      \   'right': [ [ 'lineinfo' ], [ 'fileformat', 'fileencoding', 'filetype' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead',
      \   'filename': 'LightlineFilename'
      \ }
      \ }

function! LightlineFilename()
  return expand('%:t') !=# '' ? expand('%:t') : '[No Name]'
endfunction


