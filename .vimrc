" Don't try to be vi compatible
set nocompatible

" Helps force plugins to load correctly when it is turned back on below
filetype off

" Plugin Settings
let g:clang_library_path='/usr/lib/x86_64-linux-gnu/libclang-6.0.so.1'

" Turn on syntax highlighting
syntax on

" For plugins to load correctly
filetype plugin indent on

let mapleader = ";"

" Security
set modelines=0
set mouse=a

" Show line numbers
set number

" Show file stats
set ruler

" Blink cursor on error instead of beeping (grr)
set novisualbell
set noswapfile 

" Encoding
set encoding=utf-8

" Whitespace
set wrap
set textwidth=100
set formatoptions=tcqrn1
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set noshiftround

" Cursor motion
set scrolloff=3
set backspace=indent,eol,start
set matchpairs+=<:> " use % to jump between pairs
runtime! macros/matchit.vim

" Navigate splits with one key
nmap <C-h> <C-w>h
nmap <C-j> <C-w>j
nmap <C-k> <C-w>k
nmap <C-l> <C-w>l

" Move up/down editor lines
nnoremap j gj
nnoremap k gk

" Allow hidden buffers
set hidden

" Rendering
set ttyfast

" Status bar
set laststatus=2

" Last line
set showmode
set showcmd

" Searching
set hlsearch
set incsearch
set ignorecase
set smartcase
set showmatch
map <leader><space> :let @/=''<cr> " clear search

" Remap help key.
inoremap <F1> <ESC>:set invfullscreen<CR>a
nnoremap <F1> :set invfullscreen<CR>
vnoremap <F1> :set invfullscreen<CR>

" Helpful Buffer Commands
nnoremap <leader>e :bp<CR> :bd # <CR>

" Add a line
nnoremap [<space> :call append(line('.')-1, '')<CR>
nnoremap ]<space> :call append(line('.'), '')<CR>

" Various save commands
inoremap <leader>s <ESC>:w<CR>
inoremap <leader>S <C-O>:w<CR>
nnoremap <leader>s :w<CR>

" Textmate holdouts

" Formatting
map <leader>q gqip

" Visualize tabs and newlines
set listchars=tab:▸\ ,eol:¬
" Uncomment this to enable by default:
" set list " To enable by default
" Or use your leader key + l to toggle on/off
map <leader>l :set list!<CR> " Toggle tabs and EOL

" Color scheme (terminal)
set t_Co=256
set background=dark
let g:solarized_termcolors=256
let g:solarized_termtrans=1
" put https://raw.github.com/altercation/vim-colors-solarized/master/colors/solarized.vim
" in ~/.vim/colors/ and uncomment:
" colorscheme solarized

" Plugins
nnoremap <leader>ff :Files<CR>
nnoremap <leader>fF :Files ~<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>fb <esc>:b#<CR>
nnoremap <leader>fT :Tags<CR>
nnoremap <leader>ft :BTags<CR>
