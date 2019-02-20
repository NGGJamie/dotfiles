" Basic stuff
filetype plugin indent on
syntax enable
set nocompatible
set encoding=utf-8
set number
set wrap
" Make splits real good
set splitbelow
set splitright
set ruler
" Incremental search
set incsearch
" I don't want backups
set nobackup
" Sets functionality of backspace/delete/etc
set bs=2
" I want tabs to expand into spaces, with 4 spaces.
"set expandtab
"set tabstop=4

" Theme stuff - Airline
let g:airline#extensions#tabline#formatter = 'jsformatter'
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline_theme='night_owl'

" Theme stuff - General
set bg=dark
" let g:molokai_original = 1
let g:rehash256 = 1
" colorscheme molokai

" Quality of Life
set wildmode=longest,list,full
set wildmenu
set laststatus=2
" Make bell visual rather than beep
set visualbell
" Enables highlighting when searching
set hlsearch
" Allows searching local path when using tab
set path+=**
" Show (partial) command in the last line of the screen.
set showcmd
set nostartofline

" Status line magic, when not using Airline
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]
" 0 = never show filename, 1 = only with multi-tab, 2 = Always
set laststatus=2

" Key remapping
map <F5> :setlocal spell! spelllang=en_us<CR>
map <F2> :NERDTreeToggle<CR>
map <F4> :nohl<CR>
map > :bn<CR>
map < :bp<CR>
" Map replace-all to S
nnoremap S :%s//g<Left><Left>
set softtabstop=0 noexpandtab
