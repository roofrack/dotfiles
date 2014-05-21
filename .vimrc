" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible




" ================ General Config ====================

"turn on syntax highlighting
syntax on
set t_Co=256
colorscheme wombat256
set number                      "Line numbers are good
set backspace=indent,eol,start  "Allow backspace in insert mode
set history=1000                "Store lots of :cmdline history
set showcmd                     "Show incomplete cmds down the bottom
set showmode                    "Show current mode down the bottom
set gcr=a:blinkon0              "Disable cursor blink
set visualbell                  "No sounds
set autoread                    "Reload files changed outside vim
set cursorline
hi CursorLine term=bold cterm=bold guibg=Grey40
set ruler
set mouse=a


" This makes vim act like all other editors, buffers can
" exist in the background without being in a window.
" http://items.sjbach.com/319/configuring-vim-right
" set hidden



" Change leader to a comma because the backslash is too far away
" That means all \x commands turn into ,x
" The mapleader has to be set before vundle starts loading all 
" the plugins.
let mapleader=","












" =============== Vundle Initialization ===============

" This loads all the plugins specified in ~/.vim/vundle.vim
" Use Vundle plugin to manage all other plugins
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()


" Plugins go here...
Bundle 'gmarik/vundle'
Bundle 'klen/python-mode'
Bundle 'pydiction'
Bundle 'vim-airline'
"Bundle 'Lokaltog/vim-powerline'
Bundle 'Lokaltog/powerline-fonts'
Bundle 'vim-colorscheme-switcher'
"Bundle 'flazz/vim-colorschemes'
Bundle 'vim-misc'
Bundle 'scrooloose/nerdtree'
" This fixes weird font in NERDtree...
let g:NERDTreeDirArrows=0 
"Bundle 'python_editing'




"Need this line after listing all the plugins
filetype plugin indent on


"-------------------Some plugin settings------------

let g:airline_theme='badwolf'
set laststatus=2
"set guifont=Liberation\ Mono\ for\ Powerline\ 10 
set guifont=Meslo\ Regular\ for\ Powerline.otf
"let g:airline_powerline_fonts = 1
"let g:Powerline_symbols = 'fancy'


"===============Mapping Stuff============================ 
" Note: When mapping, do not comment out on the same line
"inserting a space...
:nmap <Space> i_<Esc>r

"This maps the key to return to normal mode.
inoremap jk <Esc>

" Quick way to edit your vimrc
nnoremap <leader>ev :vsplit $MYVIMRC<cr>

" A quick way to source .vimrc so you dont have to restart vim.
:nnoremap <leader>sv :source $MYVIMRC<cr>

" Add double quotes to a word 
:nnoremap <leader>, viw<esc>a"<esc>hbi"<esc>lel

" Add double quotes to a sentence !!!! Havnt got this working yet
":nnoremap <leader>- vis<esc>^"<esc>g_"<esc>

" Enter command mode easier ...
nnoremap ; :

" Close a split window
nnoremap ii :close <cr>

" Easier way to move around splits (open windows)
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l
map <c-h> <c-w>h



" ================ Turn Off Swap Files ==============

set noswapfile
set nobackup
"set nowb






















" ================ Persistent Undo ==================

" Keep undo history across sessions, by storing in file.
" Only works all the time.
"if has('persistent_undo')
"  silent !mkdir ~/.vim/backups > /dev/null 2>&1
"  set undodir=~/.vim/backups
"  set undofile
"endif



" ================ Indentation ======================

"set autoindent
"set smartindent
"set smarttab
"set shiftwidth=2
"set softtabstop=2
"set tabstop=2
"set expandtab

"filetype plugin on
"filetype indent on

" Display tabs and trailing spaces visually
" set list listchars=tab:\ \ ,trail:·

"set nowrap       "Don't wrap lines
"set linebreak    "Wrap lines at convenient points





" ================ Folds ============================

set foldmethod=indent   "fold based on indent
set foldnestmax=3       "deepest fold is 3 levels
set nofoldenable        "dont fold by default





" ================ Completion =======================





" ================ Scrolling ========================

"set scrolloff=8         "Start scrolling when we're 8 lines away from margins
"set sidescrolloff=15
"set sidescroll=1


" ================ Custom Settings ========================
