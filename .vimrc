" Modified: Fri 05 May 2017 02:25:39 PM CEST

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible
set fileformat=unix
set fileformats=unix,dos,mac
try
	lang en_US
catch
endtry

" Load plugins
call plug#begin()

" Sensible defaults
Plug 'tpope/vim-sensible'

" Status bar
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Fuzzy file, buffer, mru, tag, etc finder
Plug 'ctrlpvim/ctrlp.vim'

" A tree explorer plugin for vim.
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'

" Git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" Syntax checking
Plug 'scrooloose/syntastic'
Plug 'mtscout6/syntastic-local-eslint.vim'
Plug 'chr4/sslsecure.vim'

" Completions
Plug 'marijnh/tern_for_vim'
" Plug 'Valloric/YouCompleteMe'

" Strip whitespace
Plug 'bronson/vim-trailing-whitespace'

" JSON
Plug 'elzr/vim-json'

" Snippets
Plug 'honza/vim-snippets'

" JavaScript
Plug 'othree/yajs.vim'
Plug 'othree/es.next.syntax.vim'

" File type support
Plug 'ap/vim-css-color'
Plug 'rodjek/vim-puppet'
Plug 'tmux-plugins/vim-tmux'

" And the rest
Plug 'wincent/command-t'
Plug 'scrooloose/nerdcommenter'
Plug 'raimondi/delimitmate'
Plug 'rstacruz/sparkup'
Plug 'ervandew/supertab'
Plug 'majutsushi/tagbar'
Plug 'marcweber/vim-addon-mw-utils'
Plug 'tpope/vim-eunuch'
Plug 'altercation/vim-colors-solarized'
Plug 'christoomey/vim-tmux-navigator'
Plug 'easymotion/vim-easymotion'

call plug#end()

" File-type
filetype on
filetype plugin on
filetype indent on
"set backspace=2      " allow backspacing over everything in insert mode
" allow <BkSpc> to delete line breaks, beyond the start of the current
" insertion, and over indentations:
silent execute '!mkdir -p ~/.vim/backup'
set backupdir=~/.vim/backup/
set backupskip=/tmp/*,/private/tmp/*
"helptags ~/.vim/doc
set backup             " keep a backup file
set cindent
set complete=k,.,w,b,u,t,i
set directory=~/.vim/backup,/tmp " This is where the swapfiles go
set history=1000       " keep 50 lines of command line history
set undolevels=1000
"set ignorecase         " Ignore the case when searching
set smartcase          " Override the 'ignorecase' option if the search pattern contains ucase
set laststatus=2       " Show status only when there are more than two windows
set lazyredraw         " Don't redraw while executing macros (good performance config)
set cmdheight=2        " Helps avoiding 'hit enter' prompt
set foldmethod=indent
set foldminlines=5
set foldlevelstart=1
set magic              " Use some magic in search patterns
set matchtime=2        " Show the match for n tenths of a second
set noerrorbells       " Damn error bells!
set noexpandtab
set number             " Show line numbers
set copyindent
set nostartofline      " Don't jump to start of line on pagedown
set nrformats+=alpha   " Allows CTRL-A and CTRL-X to increment/decrement letters
set pastetoggle=<F11>
"if exists('+colorcolumn')
"	set colorcolumn=+1
"endif
set scrolloff=3        " Keep 3 lines above and below the cursor
set shell=/bin/bash    " Shell to use for ! and :! commands
set shiftwidth=2
set shortmess=aI       " Avoid 'Hit enter to continue' message, no intro msg
set showbreak=+        " Show character at beginning of wrapped line
set showcmd            " Show uncompleted command
set showmatch          " Show the matching closing bracket
set showmode           " Show current edit mode
set smartindent        " Indent after { has been typed
set softtabstop=2
set splitbelow         " Create new window below current one
set splitright         " Create new window to the right of the current one
set tabstop=2
set title
set titlestring=%t%(\ %M%)%(\ (%{expand(\"%:~:.:h\")})%)%(\ %a%)
set ttyfast            " We're running on a fast terminal
" Tell vim to remember certain things when we exit
"  '10  :  marks will be remembered for up to 10 previously edited files
"  "100 :  will save up to 100 lines for each register
"  :50  :  up to 50 lines of command-line history will be remembered
"  %    :  saves and restores the buffer list
"  n... :  where to save the viminfo files
set viminfo='10,\"100,:50,%,n~/.viminfo
set visualbell         " Better than a beep
set nowrap             " Don't wrap long lines
set whichwrap=<,>,h,l,~,[,]   " Left/right motion line wrap
" have command-line completion <Tab> (for filenames, help topics, option names)
" first list the available options and complete the longest common part, then
" have further <Tab>s cycle through the possibilities:
set wildmode=list:longest,full
set wildchar=<TAB>     " the char used for "expansion" on the command line
set wildignore+=*.DS_Store,*.o,*.obj,.git,.svn,*.pyc " Ignore certain files in wildmenu


" normally don't automatically format `text' as it is typed, IE only do this
" with comments, at 79 characters:
set formatoptions-=t
set textwidth=79
set mouse=a


" statusbar
let g:airline_theme='distinguished'
let g:airline_powerline_fonts = 1


" Set up pretty colors
syntax enable
set background=dark
let myColorscheme = 'solarized'
"let myColorscheme = 'inkpot'

" Personal preferences for users
if $USER == 'ldx' || $USER == 'michiel' || $USER == 'vagrant'
	let myColorscheme = 'typofree'
endif

if &term ==? 'xterm-256color' || &term ==? 'screen-256color-bce' || &term ==? 'screen-256color'
	set t_Co=256
	execute "colorscheme ".myColorscheme
	let g:solarized_termtrans = 1
else
	colorscheme default
endif


" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = ","
let g:mapleader = ","


" Fast editing of the .vimrc
map <leader>e :tabedit! ~/.vimrc<cr>
" When vimrc is edited, reload it
autocmd! bufwritepost ~/.vimrc source ~/.vimrc


" Fast editing of the colorscheme
silent execute "map <leader>co :tabedit! ~/.vim/colors/".myColorscheme.".vim<cr>"
" When colorscheme is edited, reload it
autocmd! bufwritepost ~/.vim/colors/*.vim execute "colorscheme ".myColorscheme


" Make ;w work http://nvie.com/posts/how-i-boosted-my-vim/
nnoremap ; :


" Saving shortcuts
nmap <F2> :w<C-M>
nmap <F4> :wq<C-M>
nmap <F10> :qall<C-M>

" Use system-wide clipboard
set clipboard+=unnamed


" Copy to clipboard
map <leader>c "+y<cr>


" Let's see some useful info in the status line
" set statusline=%f\ %1*%m%*%=[%{strlen(&fenc)?&fenc:'none'},%{&ff}]\ %{fugitive#statusline()}\ %2*%r%*%w\ %l,%c-%v/%L\ %P


" Session management
" Maybe checkout http://peterodding.com/code/vim/session/
silent execute '!mkdir -p ~/.vim/sessions'
nmap SM :wa<C-M>:mksession! ~/.vim/sessions/
nmap SO :wa<C-M>:source ~/.vim/sessions/


" View management
au BufWritePost,BufLeave,WinLeave ?* mkview
au BufWritePost,BufLeave,WinLeave quickfix au!
au BufWinEnter ?* silent loadview
au BufWinEnter quickfix au!


" Delete trailing whitespace
nmap <leader>wd :%s/\s\+$//<cr>
vmap <leader>wd :s/\s\+$//<cr>


"Move a line of text using ALT+[jk] or Comamnd+[jk] on mac
nmap <M-j> mz:m+<cr>`z
nmap <M-k> mz:m-2<cr>`z
vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z


" Use Q for formatting the current paragraph (or selection)
vmap Q gq
nmap Q gqap


" Easy window navigation
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l


" Create new windows horizontal (-) and vertical (/)
map <leader>- <C-W>n
map <leader>/ :vne<cr>


" Tab configuration
map <leader>tn :tabnew<cr>
map <leader>te :tabedit
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove
map <Left> :tabprevious<CR>
map <Right> :tabnext<CR>


" When pressing <leader>cd switch to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>


" Make p in Visual mode replace the selected text with the "" register.
vnoremap p <Esc>:let current_reg = @"<CR>gvdi<C-R>=current_reg<CR><Esc>


" Specify the behavior when switching between buffers
try
	set switchbuf=usetab
	set stal=2
catch
endtry


" http://cloudhead.io/2010/04/24/staying-the-hell-out-of-insert-mode/
inoremap kj <Esc>


" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
	set hlsearch
	map <C-\> :nohlsearch<CR>
endif


" Only do this part when compiled with support for autocommands.
if has("autocmd")
" When editing a file, always jump to the last cursor position.
" http://vim.wikia.com/wiki/Restore_cursor_to_file_position_in_previous_editing_session
function! ResCur()
	if line("'\"") <= line("$")
		normal! g`"
		return 1
	endif
endfunction

augroup resCur
	autocmd!
	autocmd BufWinEnter * call ResCur()
augroup END

endif " has("autocmd")


" open and close folds
" Toggle fold state between closed and opened.
"
" If there is no fold at current line, just moves forward.
" If it is present, reverse its state.
fun! ToggleFold()
if foldlevel('.') == 0
	normal! l
else
	if foldclosed('.') < 0
		. foldclose
	else
		. foldopen
	endif
endif
" Clear status line
echo
endfun

" Map this function to Space key.
nnoremap <space> :call ToggleFold()<cr>
vnoremap <space> :call ToggleFold()<cr>


" have the usual indentation keystrokes still work in visual mode:
vnoremap <C-T> >
vnoremap <C-D> <LT>
vmap <Tab> <C-T>
vmap <S-Tab> <C-D>


" Bash like keys for the command line
cnoremap <C-A> <Home>
cnoremap <C-E> <End>
cnoremap <C-K> <C-U>
cnoremap <C-P> <Up>
cnoremap <C-N> <Down>


" command-T
let g:CommandTMaxHeight = 30
noremap <leader>ct :CommandT<cr>
noremap <leader>cty :CommandTFlush<cr>
"map <D-t> :CommandT<CR>


" Cope
" Do :help cope if you are unsure what cope is. It's super useful!
map <leader>ccc :botright cope 20<cr>
map <leader>\ :ccl<cr>
map <leader>n :cn<cr>
map <leader>p :cp<cr>


" Tagbar http://majutsushi.github.com/tagbar/
let g:tagbar_autofocus = 1
let g:tagbar_usearrows = 1
au BufWinEnter *.js TagbarOpen
au BufWinEnter *.php TagbarOpen
map <leader>tb :TagbarToggle<cr>


" Restore debug.vim from ~/.vim/plugins/attic
"let g:debuggerMaxChildren = 64
"let g:debuggerMaxData = 2048
"let g:debuggerMaxDepth = 10


" Start NERDTree
" autocmd VimEnter * NERDTree
" Move cursor to main window
autocmd VimEnter * wincmd p
" Close vim if NERDTree is the last open buffer
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
map <leader>nt :NERDTreeToggle<cr>


" Sparkup
let g:sparkupNextMapping = '<c-n>'
let g:sparkupExecuteMapping = '<c-e>'


" PHP Code completion
" autocmd FileType php set omnifunc=phpcomplete#CompletePHP


" Add PHP Omni Completion to SuperTab
let g:SuperTabDefaultCompletionType = "<c-x><c-o>"
" http://amix.dk/vim/vimrc.html
