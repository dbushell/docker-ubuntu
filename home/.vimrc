" Optimize for fast terminal connections
set ttyfast

" Allow cursor keys in insert mode
set esckeys

" Allow backspace in insert mode
set backspace=indent,eol,start

" Use UTF-8
set encoding=utf-8
set fileencoding=utf-8

set viminfo+=n~/.vim/viminfo
set backupdir=~/.vim/backup
set directory=~/.vim/swap
set undodir=~/.vim/undo
set undofile

" Enable line numbers
set number

" Enable syntax highlighting
syntax enable

" highlight matching parenthesis and brackets
set showmatch
set t_Co=256

" Highlight current line
set cursorline

" Make tabs as wide as two spaces
set tabstop=2

set shiftwidth=2

set expandtab

" Show the cursor position
set ruler

" Show “invisible” characters
set listchars=tab:»\ ,extends:›,precedes:‹,nbsp:·,trail:·,eol:¬
set list
