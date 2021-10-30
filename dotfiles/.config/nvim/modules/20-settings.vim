syntax on
filetype plugin on
filetype plugin indent on
set colorcolumn=80
set tabstop=4
set softtabstop=4
set shiftwidth=4
set smarttab
set autoindent
set smartindent
set number
set relativenumber
set shiftround
set ignorecase
set showmatch
set smartcase
set hlsearch
set incsearch
set list
set listchars=tab:……,trail:·,extends:#
set scrolloff=7
set fileformat=unix
set clipboard=unnamed
set expandtab
if has('persistent_undo')
  let undodir = g:cachedir . '/undodir'
  set undofile
endif
set background=dark
let g:python_host_prog="/usr/bin/python3"
