"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""               
"               
"               ██╗   ██╗██╗███╗   ███╗██████╗  ██████╗
"               ██║   ██║██║████╗ ████║██╔══██╗██╔════╝
"               ██║   ██║██║██╔████╔██║██████╔╝██║     
"               ╚██╗ ██╔╝██║██║╚██╔╝██║██╔══██╗██║     
"                ╚████╔╝ ██║██║ ╚═╝ ██║██║  ██║╚██████╗
"                 ╚═══╝  ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝
"               
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""        

" current color-scheme
colorscheme badwolf
" enable file type detection
filetype on
" enable and load plugins for the detected file type
filetype plugin on
" load filetype-specific indent files
filetype indent on
" turn syntax highlighting on
syntax on
" enable syntax processing
syntax enable
" show line numbers on the left-hand side
set number
" highlight cursor line underneath the cursor horizontally
set cursorline
" highlight cursor line underneath the cursor vertically
set cursorcolumn
" highlight text length after 120 chars
set colorcolumn=120
" show command in bottom line
set showcmd
" show mode in bottom line
set showmode
" set shift width to 4 spaces
set shiftwidth=4
" number of visual spaces per TAB
set tabstop=4
" number of spaces in TAB when editing
set softtabstop=4
" tabs are spaces
set expandtab
" make backspace work like most other programs
set backspace=2
" when searching, incrementally highlight matching characters
set incsearch
" when searching, ignore capital letters
set ignorecase
" when searching, show matching words or parentheses
set showmatch
" when searching, use highlighting
set hlsearch
" enable auto completion menu after pressing TAB
set wildmenu
" make wildmenu behave like Bash completion
set wildmode=list:longest
" let wildmenu ignore these files
set wildignore=*.docx,*.xlsx,*.pdf,*.jpg,*.png,*.gif,*.exe
