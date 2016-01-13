"===============================================================================
"                                                                              =
"                             General Config                                   =
"                                                                              =
"===============================================================================

"Set nocompatible to run vim rather than vi
"This must be first, because it changes other options as a side effect.
set nocompatible
syntax on                      "turn on syntax highlighting
set encoding=utf-8             "Need this for vim-airline to work.
set t_Co=256
"set modelines=1                "Check for commands on last line
set number                     "Line numbers are good
set history=1000               "Store lots of :cmdline history
set showcmd                    "Show incomplete cmds down the bottom
set cursorline                 "Turn on line highlighting
set ruler                      "show line number and column
set mouse=a                    "allows proper use of mouse inside vim
"set hidden                     "have buffer with unsaved work open in background
set helpheight=99999           "makes :help open in bigger buffer
set wildmenu                   "tab completion for the vim help
set noswapfile                 "prevents extra file being saved in home directory
set nobackup
set ttimeoutlen=50             "this prevents delay when using esc to exit insert mode 
set nowrap

"This prevents html lines from wrapping when window is shrunk
augroup html_nowrap
    autocmd!
    autocmd BufNewFile,BufRead *.html setlocal nowrap
augroup END



"The line below turns off the white highlighting line
hi CursorLine term=bold cterm=bold guibg=Grey40

let mapleader=","
let maplocalleader="\\"

"------------------------------Indentation--------------------------------------
set smartindent
"set textwidth=79              "lines longer than 79 columns will be broken
set shiftwidth=4               "operation >> indents 4 columns; << unindents 4 columns
set tabstop=4                  "an hard TAB displays as 4 columns
set expandtab                  "insert spaces when hitting TABs
set softtabstop=4              "insert/delete 4 spaces when hitting a TAB/BACKSPACE
set shiftround                 "round indent to multiple of 'shiftwidth'
set autoindent                 "align the new line indent with the previous line

"------------------------------Folding------------------------------------------
set foldmethod=indent          "fold based on indent
set foldnestmax=3              "deepest fold is 3 levels
set nofoldenable               "dont fold by default




"===============================================================================
"                                                                              =
"                             Plugins                                          = 
"                                                                              =
"===============================================================================


"--------------------------Vundle Initialization--------------------------------

" This loads all the plugins specified in ~/.vim/vundle.vim
" Use Vundle plugin to manage all other plugins

filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()


"--------------------------plugins----------------------------------------------

Plugin 'VundleVim/Vundle.vim'
" Plugin 'klen/python-mode'
" Plugin 'pydiction'
Plugin 'fugitive.vim'
Plugin 'vim-airline'
Plugin 'vim-colorscheme-switcher'
Plugin 'flazz/vim-colorschemes'
Plugin 'vim-misc'
Plugin 'scrooloose/nerdtree'
" Plugin 'python_editing'
Plugin 'mattn/emmet-vim'
" Plugin 'tpope/vim-surround'
" Plugin 'rstacruz/sparkup'
Plugin 'christoomey/vim-tmux-navigator'
" Plugin 'edkolev/tmuxline.vim'
" Plugin 'tpope/vim-dispatch'
" Plugin 'vim-scripts/upAndDown'
" Plugin 'ivanov/vim-ipython'
Plugin 'dbext.vim'
Plugin 'tpope/vim-commentary'
Plugin 'jaxbot/browserlink.vim'
Plugin 'scrooloose/syntastic'
Plugin 'rust-lang/rust.vim'


"Need this line after listing all the plugins
call vundle#end()
filetype plugin indent on


"------------------------plugin settings----------------------------------------

"flazz/vim-colorschemes_settings ...
colorscheme wombat256


"vim-airline_settings ...
let g:airline_theme='badwolf'
set laststatus=2
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1

" when i turn this on it will screw airline up (laptop computer works ok)
" When its off the fonts don't look as nice
let g:airline_powerline_fonts = 1

"set guifont=Liberation\ Mono\ for\ Powerline\ 10 

" not sure what this does if anything
" let g:Powerline_symbols = 'fancy'

"NERDTree_settings ...
let g:NERDTreeDirArrows=0        " this fixes weird font in NERDtree...
let NERDTreeWinSize = 20
let NERDTreeShowBookmarks = 1
"Toggle on/off NERDTree
nnoremap <C-n> :NERDTreeToggle<CR>
"Show current file in NERDtree
"nnoremap <silent> <C-s> :NERDTree<CR><C-w>p:NERDTreeFind<CR>


"dbext_settings ...
let g:dbext_default_buffer_lines = 10
let g:dbext_default_use_sep_result_buffer = 1

"Database profile connections for the dbtext plugin...
"let g:dbext_default_profile_SQLITE_for_tysql='type=SQLITE:SQLITE_bin=/usr/bin/sqlite3:dbname=~/database/tysql.sqlite'

"let g:dbext_default_profile_SQLITE_for_disposabletysql='type=SQLITE::dbname=~/database/disposable_tysql.sqlite'

"let g:dbext_default_profile_SQLITE_for_sheep='type=SQLITE:dbname=~/database/sheep/sheep.sqlite'
"let g:dbext_default_profile_SQLITE_for_sheep_bad='type=SQLITE:dbname=~/database/sheep/sheep_bad.sqlite'
let g:dbext_default_profile_SQLITE_for_sample ='type=SQLITE:dbname=~/pythonstuff/tutorials/flask/flask-intro/sample.db'


"Pymode_settings ...
"let g:pymode_lint_on_write=0
"Auto correct python code to PEP8 standards
"nnoremap <leader>f :PymodeLintAuto<CR>


"emmett_settings ...
"This allows the use of the trigger key in all modes
let g:user_emmet_mode='a'

"Syntastic_settings
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 0
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0
let g:syntastic_loc_list_height=2

"===============================================================================
"                                                                              =
"                             Mapping                                          = 
"                                                                              =
"===============================================================================

" Note: When mapping, do not comment on the same line

"----------------------------misc mappings--------------------------------------

"source vimrc
nnoremap <leader>sv :so %<cr>

"Quick way to edit your vimrc
"prevent vimrc from wrapping
augroup vimrc
    autocmd!
    autocmd BufRead .vimrc setlocal nowrap
augroup END
nnoremap <leader>ev :vsplit $MYVIMRC<cr>

"To run certain lines in bash you would use this...
":line#start,line#endw !bash

"if you just want to run the current line than use...
".w !bash

"This works by instead of writing to disk it 'writes' to the stdin of another
"program which in this case is bash.


"Save and run a python file using <F5>
inoremap <F5> <Esc>:w<CR>:!python2 %<CR>
nnoremap <F5> <Esc>:w<CR>:!python2 %<CR>
inoremap <F6> <Esc>:w<CR>:!python3 %<CR>
nnoremap <F6> <Esc>:w<CR>:!python3 %<CR>

" Enter command mode easier ...
nnoremap ; :

"----------------------------editing mappings-----------------------------------

"Change a word to uppercase
inoremap <C-u> <Esc> gUiwi
nnoremap <C-u> gUiw

"inserting a space or a character in normal mode
nnoremap <Space> i_<Esc>r

"select all
nnoremap <Leader>a ggVG

"hen indenting keep selection highlighted
vnoremap > >gv
vnoremap < <gv

"copy to system clipboard while in visual mode. This allows you to
"copy from vim and paste into another application outside of vim.
vnoremap <C-c> "+y

"Use jk to return to normal mode.
inoremap jk <Esc>
inoremap JK <Esc>
inoremap KJ <Esc>
inoremap kj <Esc>
vnoremap jk <Esc>
vnoremap JK <Esc>
cnoremap jk <Esc>

"--------------------------insert mode mappings--------------------------------






"--------------------------moving around windows--------------------------------

"Close a split window
nnoremap <leader>q :close <cr>

"Easier way to move around splits (open windows)
noremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l
nnoremap <c-h> <c-w>h

"Open previous buffer
nnoremap <Leader><Leader> <C-^>



"===============================================================================
"                                                                              =
"                             Abbreviations                                    = 
"                                                                              =
"===============================================================================

iab pritn print
iab blink <script src='http://127.0.0.1:9001/js/socket.js'></script>








"===============================================================================
"                                                                              =
"                             Modelines                                        = 
"                                                                              =
"===============================================================================

"These are turned on with the 'set modelines=1'

"vim:foldmethod=marker:foldlevel=0
