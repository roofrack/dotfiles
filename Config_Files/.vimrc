"===============================================================================
"                                                                              =
"                             General Config                                   =
"                                                                              =
"===============================================================================

"Set nocompatible to run vim rather than vi
"This must be first, because it changes other options as a side effect.
set nocompatible
syntax on                       "turn on syntax highlighting
set encoding=utf-8              "Need this for vim-airline to work.
set t_Co=256
set laststatus=2
"set modelines=1                "Check for commands on last line
set number                      "Line numbers are good
" set relativenumber
set history=1000                "Store lots of :cmdline history
"set showcmd                    "Show incomplete cmds down the bottom
" set cursorline                 "Turn on line highlighting
set ruler                       "show line number and column
set mouse=a                     "allows proper use of mouse inside vim
set hidden                     "have buffer with unsaved work open in background
" set helpheight=99999            "makes :help open in bigger buffer
set wildmenu                    "tab completion for the vim help
set noswapfile                 "prevents extra file being saved in home directory
set nobackup
set nowritebackup
" set cmdheight=2
set ttimeoutlen=50              "this prevents delay when using esc to exit insert mode
set nowrap
set noshowmode                  "stops insert message appearinge
set background=dark             "Need this on for tmux to not change the vim color-scheme


" command to clear all registers
" just type :WipeReg
command! WipeReg for i in range(34,122) | silent! call setreg(nr2char(i), []) | endfor


"This prevents html lines from wrapping when window is shrunk
augroup html_nowrap
    autocmd!
    autocmd BufNewFile,BufRead *.html setlocal nowrap
augroup END


"The line below turns off the white highlighting line
" hi CursorLine term=bold cterm=bold guibg=Grey40
" hi CursorLineNr    term=bold cterm=bold ctermfg=012 gui=bold


" let mapleader=","
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

" These next few lines are for an auto installer for vim-plug. Works great. On a new system just
" open vim and it will auto install vim-plug and setup .vim directory for my
" plugins.

let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
    silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

"--------------------------plugins----------------------------------------------
call plug#begin()
Plug 'flazz/vim-colorschemes'
Plug 'scrooloose/nerdtree'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'christoomey/vim-tmux-navigator'
Plug 'christoomey/vim-tmux-runner'
"Plug 'itchyny/lightline.vim'
"Plug 'itchyny/vim-gitbranch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'mattn/emmet-vim'
" Plug 'pangloss/vim-javascript'
Plug 'sheerun/vim-polyglot'
" Plug 'eslint/eslint'
" Plug 'vim-syntastic/syntastic'
" Plug 'briancollins/vim-jst'
" Plug 'nikvdp/ejs-syntax'
" Plug 'leafOfTree/vim-vue'
" Plug 'ap/vim-css-color'
" Plug 'chrisbra/Colorizer'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'ryanoasis/vim-devicons'
call plug#end()

"--------------------------------------------------------------------------------


"Plugin 'klen/python-mode'
"Plugin 'pydiction'
"Plugin 'Valloric/YouCompleteMe'
"Plugin 'fugitive.vim'
"Plugin 'vim-airline'
"Plugin 'vim-colorscheme-switcher'
"Plugin 'flazz/vim-colorschemes'
"Plugin 'vim-misc'
"plugin 'scrooloose/nerdtree'
"plugin 'python_editing'
"Plugin 'mattn/emmet-vim'
"Plugin 'tpope/vim-surround'
"Plugin 'rstacruz/sparkup'
"Plugin 'christoomey/vim-tmux-navigator'
"Plugin 'edkolev/tmuxline.vim'
"Plugin 'tpope/vim-dispatch'
"Plugin 'vim-scripts/upAndDown'
"Plugin 'ivanov/vim-ipython'
"Plugin 'dbext.vim'
"Plugin 'tpope/vim-commentary'
"Plugin 'jaxbot/browserlink.vim'
"Plugin 'scrooloose/syntastic'
"Plugin 'rust-lang/rust.vim'
"Plugin 'ternjs/tern_for_vim'

"Plugin 'SirVer/ultisnips'

" Snippets are separated from the engine. Add this if you want them:
"Plugin 'honza/vim-snippets'

"------------------------plugin settings----------------------------------------

"flazz/vim-colorschemes_settings ...
colorscheme wombat256

" let g:colorizer_auto_color = 1

" this will make vim transparency work if using not the default colorscheme
hi Normal guibg=NONE ctermbg=NONE

"vim-airline_settings ...
" ---------------------------------------------------------
let g:airline_theme='badwolf'
" let g:airline_theme='simple'
" let g:airline_theme='dark'
" let g:airline_theme='light'
" let g:airline_theme='durant'
" let g:airline_theme='hybrid'
" let g:airline_theme='wombat'
" let g:airline#extensions#tabline#enabled = 1
" let g:airline#extensions#tabline#buffer_nr_show = 0
"let g:airline_inactive_collapse=1
let g:airline#extensions#syntastic#enabled = 1

" when i turn this on it will screw airline up (laptop computer works ok)
" When its off the fonts don't look as nice
let g:airline_powerline_fonts = 1

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
" unicode symbols
let g:airline_symbols.colnr = ' ℅:'

"Syntastc settings ...
" ---------------------------------------------------------
" set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
" set statusline+=%*
" let g:syntastic_always_populate_loc_list = 1
" let g:syntastic_auto_loc_list = 1
" let g:syntastic_check_on_open = 1
" let g:syntastic_check_on_wq = 0
" let g:syntastic_javascript_checkers = ['eslint']
" let g:syntastic_javascript_eslint_exe = 'npm run lint --'


"NERDTree_settings ...
" ---------------------------------------------------------
let g:NERDTreeDirArrows=0        " this fixes weird font in NERDtree...
let NERDTreeWinSize = 25
let NERDTreeShowBookmarks = 1
let NERDTreeHighlightCursorline=0
let NERDTreeShowHidden=1
"Toggle on/off NERDTree
nnoremap <C-n> :NERDTreeToggle<CR>
"Show current file in NERDtree
nnoremap <silent> <C-s> :NERDTree<CR><C-w>p:NERDTreeFind<CR>


"vim-tmux-runner settings...
" ---------------------------------------------------------
let g:VtrUseVtrMaps = 1          "use default Vtm mappings
"let g:vtr_filetype_runner_overrides = {
            \ 'python': 'python -i {file}'
            \}
nnoremap f<cr> :VtrSendFile<cr>
nnoremap fl :VtrSendLinesToRunner<cr>

"dbext_settings ...
"let g:dbext_default_buffer_lines = 10
"let g:dbext_default_use_sep_result_buffer = 1

"Database profile connections for the dbtext plugin...
"let g:dbext_default_profile_SQLITE_for_tysql='type=SQLITE:SQLITE_bin=/usr/bin/sqlite3:dbname=~/database/tysql.sqlite'

"let g:dbext_default_profile_SQLITE_for_disposabletysql='type=SQLITE::dbname=~/database/disposable_tysql.sqlite'

"let g:dbext_default_profile_SQLITE_for_sheep='type=SQLITE:dbname=~/database/sheep/sheep.sqlite'
"let g:dbext_default_profile_SQLITE_for_sheep_bad='type=SQLITE:dbname=~/database/sheep/sheep_bad.sqlite'
"let g:dbext_default_profile_SQLITE_for_sample ='type=SQLITE:dbname=~/pythonstuff/tutorials/flask/flask-intro/sample.db'


"Pymode_settings ...
"let g:pymode_lint_on_write=0
"Auto correct python code to PEP8 standards
"nnoremap <leader>f :PymodeLintAuto<CR>


"emmett_settings ...
" ---------------------------------------------------------
"This allows the use of the trigger key in all modes
let g:user_emmet_mode='a'



" Coc.nvim settings...
" ---------------------------------------------------------
" add extensions here
let g:coc_global_extensions = [
    \'coc-json',
    \'coc-tsserver',
    \'coc-highlight',
    \'coc-eslint',
    \'coc-prettier'
    \ ]
" Use :Prettier to format current buffer
" command! -narg=0 Prettier :CocCommand prettier.formatFile

" use tab for trigger
inoremap <expr> <TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr> <S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"

"coc-highlight extension
set termguicolors               " Needed this for coc-highlight to work for showing hex color preview


" Ultisnips plugin settings...
" ---------------------------------------------------------
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
"let g:UltiSnipsExpandTrigger="<c-j>"
"let g:UltiSnipsJumpForwardTrigger="<c-j>"
"let g:UltiSnipsJumpBackwardTrigger="<c-k>"

" If you want :UltiSnipsEdit to split your window.
"let g:UltiSnipsEditSplit="vertical"




"===============================================================================
"                                                                              =
"                             Mapping                                          =
"                                                                              =
"===============================================================================

" Note: When mapping, do not comment on the same line

"----------------------------misc mappings--------------------------------------

"source vimrc
nnoremap <leader>sv :source $MYVIMRC

"Quick way to edit your vimrc
nnoremap <leader>ev :vsplit $MYVIMRC<cr>

"To run certain lines in bash you would use this...
":line#start,line#endw !bash

"if you just want to run the current line than use...
":w !bash

"This works by instead of writing to disk it 'writes' to the stdin of another
"program which in this case is bash.


"Save(update) and run a python file using <F5>
"inoremap <F5> <Esc>:update<CR>:!python2 %<CR>
"nnoremap <F5> <Esc>:update<CR>:!python2 %<CR>
"inoremap <F6> <Esc>:update<CR>:!python3 %<CR>
"nnoremap <F6> <Esc>:update<CR>:!python3 %<CR>


" Enter command mode easier ...
nnoremap ; :




"----------------------------tmux mapping in vim--------------------------------

" We can combine vimscript and tmux scripting to do things in other panes.


" This mapping will run the current python file (which is currently open in vim) in a
" seperate tmux pane (I usually make pane # 1 the bottom pane)
"autocmd Filetype python nnoremap <silent> <buffer> <CR> <Esc>:update<CR>:!tmux send-keys -t 1 "cd %:p:h && clear && python -i %" Enter <CR> <CR>

" So... To break this down ...

" autocmd Filetype python            -Makes this mapping only apply to python files (.py)
" nnoremap <buffer> <CR>             -Make a mapping in normal mode using the 'enter' key as the shortcut key
" <Esc>:w<CR>:                       -Get out of insert mode, enter command mode, save, enter, and then go back to command mode
" !                                  -Run the following commands as if they were in the bash shell
" tmux send-keys -t 1                -send the following commands to terminal 1 (I usually have this as the bottom pane)
" "cd %:p:h && cl && python -i %"    -cd into the same path as the current file thats open in vim,
"                                     cl screen(this is an alias for clear), and start python in interactive mode (the
"                                     % symbol just stands for the filename which is currently open in vim)
" Enter                              -Tells bash to press 'Enter'
" <CR>                               -Tells vim to press 'Enter'
" <CR>                               -Tells vim to return to where you left off


" This one (pressing g<CR>) will reload the python shell with the current file open in vim
"autocmd Filetype python nnoremap g<CR> <Esc>:update<CR>:!tmux send-keys -t 1 "exit()" Enter "clear && python -i %" Enter <CR> <CR>




"----------------------------editing mappings-----------------------------------

"Change a WORD to UPPERCASE
"steps for this to work are... <Esc> back to normal mode than...
" move one left(h), go uppercase for the inner word(hUiw), move to the end of the word(w),
" move one more space so your back where you started.
" Note: the youcompleteme also uses ctr-u. So may not work in insert mode.
inoremap <C-u> <Esc>gUiwea
nnoremap <C-u> gUiw

"inserting a space or a character in normal mode
nnoremap <Space> i_<Esc>r

"select all
nnoremap <Leader>a ggVG

"When indenting keep selection highlighted
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
nnoremap <c-j> <c-w>j
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

" Python abbreviations
" --------------------

" autocmd Filetype python iabbrev <buffer> pr print()<Esc>i
" autocmd Filetype python iabbrev <buffer> prr print("")<Esc>hi

" iab ifname if __name__=='__main__':



iab pritn print
iab blink <script src='http://127.0.0.1:9001/js/socket.js'></script>
iab cl console.log




"===============================================================================
"                                                                              =
"                             Modelines                                        =
"                                                                              =
"===============================================================================

"These are turned on with the 'set modelines=1'

"vim:foldmethod=marker:foldlevel=0
