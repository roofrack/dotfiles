" Here is a good example vimrc file: http://dougblack.io/words/a-good-vimrc.html

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible




" ================ General Config===============================================

"turn on syntax highlighting
syntax on
set encoding=utf-8 " Need this for vim-airline to work.
set t_Co=256
set modelines=1                "Check for commands on last line
set number                      "Line numbers are good
set backspace=indent,eol,start  "Allow backspace in insert mode
set history=1000                "Store lots of :cmdline history
set showcmd                     "Show incomplete cmds down the bottom
set showmode                    "Show current mode down the bottom
set gcr=a:blinkon0              "Disable cursor blink
set visualbell                  "No sounds
set autoread                    "Reload files changed outside vim
set cursorline                  "Turn on line highlighting
"The line below turns off the white highlighting line
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
au BufWritePost .vimrc so ~/.vimrc       "source .vimrc file on save


" =============== Vundle Initialization========================================

" This loads all the plugins specified in ~/.vim/vundle.vim
" Use Vundle plugin to manage all other plugins
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()


" Plugins go here...
Bundle 'gmarik/vundle'
"Bundle 'klen/python-mode'
"Bundle 'pydiction'
Bundle 'vim-airline'
"Bundle 'Lokaltog/vim-powerline'
"Bundle 'Lokaltog/powerline-fonts'
Bundle 'vim-colorscheme-switcher'
Bundle 'flazz/vim-colorschemes'
Bundle 'vim-misc'
Bundle 'scrooloose/nerdtree'
"Bundle 'python_editing'
"Bundle 'mattn/emmet-vim'
Bundle 'tpope/vim-surround'
"Bundle 'rstacruz/sparkup'
Bundle 'christoomey/vim-tmux-navigator'
"Bundle 'edkolev/tmuxline.vim'
"Bundle 'tpope/vim-dispatch'
"Bundle 'vim-scripts/upAndDown'
"Bundle 'ivanov/vim-ipython'
Bundle 'dbext.vim'
Bundle 'tpope/vim-commentary'
Plugin 'fugitive.vim'

"Need this line after listing all the plugins
filetype plugin indent on

"-------------------Some plugin settings--------------

" flazz/vim-colorschemes
colorscheme wombat256

" vim-airline ...
let g:airline_theme='badwolf'
set laststatus=2
let g:airline#extensions#tabline#enabled = 1
"set guifont=Liberation\ Mono\ for\ Powerline\ 10 
"set guifont=Meslo\ Regular\ for\ Powerline.otf
let g:airline_powerline_fonts = 1
"let g:Powerline_symbols = 'fancy'



"let g:airline#extensions#branch#enabled=1
"let g:airline#extensions#branch#empty_message='no repo'
"let g:airline#extensions#hunks#enabled=0
"let g:airline#extensions#whitespace#enabled=1
"let g:airline#extensions#whitespace#mixed_indent_algo=1 "Tabs before spaces




" NERDTree ...
" This fixes weird font in NERDtree...
let g:NERDTreeDirArrows=0  
let NERDTreeWinSize = 16

 
" dbext ...
let g:dbext_default_buffer_lines = 10
"let g:dbext_default_use_sep_result_buffer = 1

"Database profile connections for the dbtext plugin...
let g:dbext_default_profile_SQLITE_for_tysql='type=SQLITE:SQLITE_bin=/usr/bin/sqlite3:dbname=~/database/tysql.sqlite'

let g:dbext_default_profile_SQLITE_for_disposabletysql='type=SQLITE::dbname=~/database/disposable_tysql.sqlite'



" Pymode ...
let g:pymode_lint_on_write=0


"===============Mapping Stuff=================================================== 

" Note: When mapping, do not comment out on the same line "----- misc mappings --------------------------------- 

:nnoremap <leader>sv :source $MYVIMRC<cr>
" Quick way to edit your vimrc
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
" clear search highlights
noremap <silent><Leader>/ :nohls<CR>
" Save and run a file using <F5>
inoremap <F5> <Esc>:w<CR>:!python2 %<CR>
nnoremap <F5> <Esc>:w<CR>:!python2 %<CR>


"---- movement mappings ------------------------------

" Close a split window
nnoremap <c-i> :close <cr>
" Easier way to move around splits (open windows)
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l
map <c-h> <c-w>h
" Open last/new buffer
noremap <Leader><Leader> <C-^>

" while in insert mode, move down a line
inoremap <c-o> <Esc>o

" Use jk to return to normal mode.
inoremap jk <Esc>
inoremap JK <Esc>
inoremap KJ <Esc>
inoremap kj <Esc>
vnoremap jk <Esc> 
vnoremap JK <Esc> 
cnoremap jk <Esc> 

" Enter command mode easier ...
nnoremap ; :


"---- editing mappings --------------------------------

" Change a word to uppercase
"<Leader> U 

"inserting a space or a character in normal mode
:nmap <Space> i_<Esc>r


" Add double quotes to a word 
":nnoremap <leader>, viw<esc>a"<esc>hbi"<esc>lel

" Add double quotes to a sentence !!!! Havnt got this working yet
":nnoremap <leader>- vis<esc>^"<esc>g_"<esc>

" select all
noremap <Leader>a ggVG

" When indenting keep selection highlighted
vnoremap > >gv
vnoremap < <gv

" Insert blank lines in normal mode
noremap <leader>t o<ESC>k
noremap <leader>T O<ESC>j



"---- plugin mappings ---------------------------------

" Auto correct python code to PEP8 standars
nnoremap <leader>f :PymodeLintAuto<CR>
" Hit <f5> to run Python code
"noremap <f5> :w <CR>!clear <CR>:!python % <CR>

" Toggle on/off NERDTree
noremap <C-n> :NERDTreeToggle<CR>
" Show current file in NERDtree
noremap <silent> <C-s> :NERDTree<CR><C-w>p:NERDTreeFind<CR>



"==============================================================================


" ================ Turn Off Swap Files ========================================

set noswapfile
set nobackup
"set nowb





" ================ Persistent Undo ============================================

" Keep undo history across sessions, by storing in file.
" Only works all the time.
"if has('persistent_undo')
"  silent !mkdir ~/.vim/backups > /dev/null 2>&1
"  set undodir=~/.vim/backups
"  set undofile
"endif



" ================ Indentation ================================================

set smartindent
set textwidth=79  " lines longer than 79 columns will be broken
set shiftwidth=4  " operation >> indents 4 columns; << unindents 4 columns
set tabstop=4     " an hard TAB displays as 4 columns
set expandtab     " insert spaces when hitting TABs
set softtabstop=4 " insert/delete 4 spaces when hitting a TAB/BACKSPACE
set shiftround    " round indent to multiple of 'shiftwidth'
set autoindent    " align the new line indent with the previous line





"filetype plugin on
"filetype indent on

" Display tabs and trailing spaces visually
" set list listchars=tab:\ \ ,trail:·

"set nowrap       "Don't wrap lines
"set linebreak    "Wrap lines at convenient points





" ================ Folding  ===================================================

set foldmethod=indent   "fold based on indent
set foldnestmax=3       "deepest fold is 3 levels
set nofoldenable        "dont fold by default



" ================ Completion =================================================





" ================ Scrolling ==================================================

"set scrolloff=8         "Start scrolling when we're 8 lines away from margins
"set sidescrolloff=15
"set sidescroll=1


" ================ Custom Settings ============================================
" These are turned on with the 'set modelines=1' 
" vim:foldmethod=marker:foldlevel=0      
