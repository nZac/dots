" 01101110 01011010 01100001 01100011
"
"            /$$$$$$$$
"           |_____ $$
" /$$$$$$$      /$$/   /$$$$$$   /$$$$$$$
" | $$__  $$    /$$/   |____  $$ /$$_____/
" | $$  \ $$   /$$/     /$$$$$$$| $$
" | $$  | $$  /$$/     /$$__  $$| $$
" | $$  | $$ /$$$$$$$$|  $$$$$$$|  $$$$$$$
" |__/  |__/|________/ \_______/ \_______/
"
" By: Nick Zaccardi
" Project: Dotfiles
" License: GNU GPLv3 (https://www.gnu.org/copyleft/gpl.html)

" Load all of the plugins I like
call plug#begin('~/.vim/plugged')


function! BuildYCM(info)
  " info is a dictionary with 3 fields
  " - name:   name of the plugin
  " - status: 'installed', 'updated', or 'unchanged'
  " - force:  set on PlugInstall! or PlugUpdate!
  if a:info.status == 'installed' || a:info.force
    !./install.py
  endif
endfunction

" Must have plugins
Plug 'mhinz/vim-signify'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-unimpaired'
Plug 'flazz/vim-colorschemes'
Plug 'kien/ctrlp.vim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'christoomey/vim-tmux-navigator'
Plug 'Valloric/YouCompleteMe', { 'do': function('BuildYCM') }
Plug 'davidhalter/jedi-vim'
Plug 'ervandew/supertab'
Plug 'janko-m/vim-test'
Plug 'vimscripts/closetag.vim'
Plug 'rizzatti/dash.vim'
Plug 'junegunn/vim-easy-align'
Plug 'MarcWeber/vim-addon-local-vimrc'

" Reference Library Plugins
Plug 'tomtom/tlib_vim'
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'vim-scripts/Align'

" Language Plugins
Plug 'sheerun/vim-polyglot'
Plug 'pearofducks/ansible-vim'
Plug 'nvie/vim-flake8'
Plug 'xolox/vim-easytags'
Plug 'xolox/vim-misc'
Plug 'justinj/vim-react-snippets'
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'elmcast/elm-vim'
Plug 'vimwiki/vimwiki'
Plug 'rust-lang/rust.vim'
Plug 'vim-scripts/SQLUtilities'
Plug 'leafgarland/typescript-vim', { 'do': 'npm -g install typescript' }

" Plugins that are nice in order of use
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-vinegar'
Plug 'scrooloose/syntastic'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'mattn/emmet-vim'
Plug 'godlygeek/tabular'
Plug 'majutsushi/tagbar'
Plug 'mtth/scratch.vim'
Plug 'benmills/vimux'
Plug 'scrooloose/nerdcommenter'

call plug#end()

"------------------------------------------------------------------------------
" GENERAL SETTINGS
"------------------------------------------------------------------------------
let mapleader = ";"
syntax enable
set autoread
set backspace=2
set colorcolumn=80,100
set cursorline
set confirm
set conceallevel=0
set fileformat=unix
set hidden
set laststatus=2
set listchars=tab:›\ ,eol:¬,trail:⋅
set nonumber
set t_Co=256
set scrolloff=999
set showmatch
set noshowmode
set spell spelllang=en
set splitbelow
set splitright
set title
set visualbell
set nobackup
set nostartofline
set noswapfile
set foldmethod=indent
set ignorecase
set smartcase
set incsearch
set ttyfast
set ttimeoutlen=0 " set how long vim waits for the command

if !has('nvim')
  set cryptmethod=blowfish  " Set crypto method
endif

"------------------------------------------------------------------------------
" Tab Settings
"------------------------------------------------------------------------------
set autoindent              " Turn on auto indentation
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set textwidth=80

"------------------------------------------------------------------------------
" Syntax Highlighting and Color
"------------------------------------------------------------------------------
set background=dark
let g:solarized_termcolors=256
colorscheme solarized
let g:airline_powerline_fonts=1
set guifont=Source\ Code\ Pro\ for\ Powerline\ Medium\ 10

"------------------------------------------------------------------------------
" File Type Specific
"------------------------------------------------------------------------------
filetype plugin on
filetype plugin indent on

augroup vimrc_autocmd
    autocmd!
    autocmd BufNewFile,BufRead Vagrantfile set filetype=ruby " Vagrant is ruby :(
    autocmd BufWritePre * :%s/\s\+$//e " Automatically strip whitespace on save
    au BufNewFile,BufRead *.j2 set filetype=htmldjango
    au BufNewFile,BufRead *.yaml\|*.yml set filetype=ansible

    autocmd FileType javascript setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2
    autocmd FileType html  setlocal expandtab shiftwidth=2 tabstop=2 textwidth=0
    autocmd FileType rst setlocal shiftwidth=2 tabstop=2 textwidth=80 softtabstop=2
    autocmd FileType python setlocal expandtab tabstop=4 softtabstop=4 shiftwidth=4 textwidth=80 comments=b:#,fb:-,b:#:
    autocmd FileType markdown setlocal textwidth=80  " wrap at 80
    autocmd FileType elm setlocal expandtab tabstop=2 softtabstop=2 shiftwidth=2 textwidth=100
    autocmd FileType sh setlocal expandtab tabstop=2 softtabstop=2 shiftwidth=2 textwidth=0

    "------------------------------------------------------------------------------
    " Editor Settings
    "------------------------------------------------------------------------------
    autocmd VimResized * wincmd = " Make vim equalize when resized
augroup END

"------------------------------------------------------------------------------
" Plugin  Settings
"------------------------------------------------------------------------------

let NERDTreeIgnore = ['\.pyc$', '__pycache__', '\.egg-info']
let NERDTreeHijackNetrw=1
let g:riv_fold_auto_update = 0       " Turn off auto folding on save for rst files
let g:miniBufExplBRSplit = 0         " put MBE on top
let g:miniBufExplBuffersNeeded = 1
let g:ctrlp_working_path_mode = 'ra' " Set the working path to a .git folder
let g:ctrlp_custom_ignore = '\v[\/](node_modules|target|dist|bower_components)|(\.(swp|ico|git|svn|hg|tox))$'
let g:ctrlp_show_hidden = 1
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"
let g:ultisnips_python_style             = 'sphinx'
let g:UltiSnipsSnippetDirectories        = ["UltiSnips", $HOME."/.vim/extra-snippets"]
let g:tagbar_autofocus = 1
let g:tagbar_autoclose = 1
let g:tagbar_sort = 0
let g:tagbar_show_linenumbers = 1
let test#javascript#runner = 'mocha'

let test#python#pytest#options = {
                                    \ 'nearest': '-x -s -vv --pudb --strict -rw',
                                    \ 'file': '-x -s -vv --pudb --strict -rw',
                                    \ 'suite': '',
                                \}

let g:vim_json_syntax_conceal            = 0
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme                      = 'bubblegum'
let g:easytags_auto_highlight            = 0
let g:easytags_events                    = ['BufWritePost']
let g:easytags_async                     = 1
let g:ycm_rust_src_path                  = $RUST_SRC_PATH
let g:ycm_python_binary_path             = 'python'
let g:ycm_key_list_select_completion     = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion   = ['<C-p>', '<Up>']
let g:SuperTabDefaultCompletionType      = '<C-p>'
let g:SuperTabCrMapping = 0

let g:sqlutil_keyword_case = '\U'
let g:sqlutil_align_comma = 1
let g:closetag_html_style=1

" Change the curson in different modes
let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
let &t_SR = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=2\x7\<Esc>\\"
let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"


"------------------------------------------------------------------------------
" Tab completion setup
"------------------------------------------------------------------------------
set wildmode=list:longest     " Wildcard matches show a list, matching the longest first
set wildignore+=.git,.hg,.svn " Ignore version control repos
set wildignore+=*.6           " Ignore Go compiled files
set wildignore+=*.pyc         " Ignore Python compiled files
set wildignore+=*.rbc         " Ignore Rubinius compiled files
set wildignore+=*.swp         " Ignore vim backups

"------------------------------------------------------------------------------
" General Remappings
"------------------------------------------------------------------------------
" Helpful escape remaps
inoremap jj <ESC>j
inoremap hh <ESC>h
inoremap kk <ESC>k
inoremap lll <ESC>l

" Navigating splits is much easier
nmap <C-h> <C-w>h
nmap <C-j> <C-w>j
nmap <C-k> <C-w>k
nmap <C-l> <C-w>l

" using visual up/down instead of linewise very helpful for wrapped text
map j gj
map k gk

" Ctrl-a I use for my tmux commands so remap incrementing numbers
nnoremap ≈ <C-x>

"------------------------------------------------------------------------------
" Leader mappings
"------------------------------------------------------------------------------
" Toggle Nerd Tree
nnoremap <leader>k :NERDTreeToggle<CR>

" close current buffer without close split
nnoremap <leader>e :bp<CR> :bd # <CR>

" open previous bufer
nnoremap <leader>b <esc>:b#<CR>

" Reformat paragraph
nnoremap <leader>} <esc>gq}

" Add noqa to end of line
nnoremap <leader>c# o# noqa<esc>kJi<space>

" Make splits even
nnoremap <leader>W <C-w>=

" Various save commands
inoremap <leader>s <ESC>:w<CR>
inoremap <leader>S <C-O>:w<CR>
nnoremap <leader>s :w<CR>

" System clipboard
map <leader>y "*y
map <leader>p "*p

"------------------------------------------------------------------------------
" Plugin mappings
"------------------------------------------------------------------------------
nnoremap <leader>ff :CtrlP<cr>
nnoremap <leader>b :CtrlPBuffer<cr>
nnoremap <leader>l :CtrlPLine<cr>
nnoremap <leader>h :TagbarToggle<CR>   " Toggle Tabar
nnoremap <leader>a :Scratch<CR>

nmap <silent> <leader>tn :TestNearest<CR>
nmap <silent> <leader>tf :TestFile<CR>
nmap <silent> <leader>ta :TestSuite<CR>

nmap <silent> <leader>d <Plug>DashSearch

xmap ga <Plug>(LiveEasyAlign)
nmap ga <Plug>(LiveEasyAlign)

vmap <leader>fs <Plug>SQLUFormatter<CR>

"------------------------------------------------------------------------------
" Custom Functions
"------------------------------------------------------------------------------

" Pretty up a JSON File
com! FormatJSON %!python -m json.tool

