" Plug plugins
let g:data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.local/share/vim/site'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
let g:plugged_dir = has('nvim') ? stdpath('data') . '/plugged' : '~/.local/share/vim/plugged'

call plug#begin(g:plugged_dir)

Plug 'jiangmiao/auto-pairs'

Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'Shougo/denite.nvim',
Plug 'zchee/deoplete-jedi'

Plug 'junegunn/fzf.vim'

Plug 'scrooloose/nerdtree'
Plug 'preservim/nerdcommenter'
Plug 'Xuyuanp/nerdtree-git-plugin'

Plug 'equalsraf/neovim-gui-shim'

"Plug 'neovim/nvim-lspconfig'

Plug 'scrooloose/syntastic'

Plug 'mbbill/undotree'

Plug 'vim-airline/vim-airline-themes'
Plug 'vim-airline/vim-airline'
Plug 'nvie/vim-flake8'
Plug 'ryanoasis/vim-devicons'
Plug 'easymotion/vim-easymotion'
Plug 'tpope/vim-fugitive'
Plug 'equalsraf/neovim-gui-shim'
Plug 'airblade/vim-gitgutter'
Plug 'etdev/vim-hexcolor'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'jceb/vim-orgmode'
Plug 'sheerun/vim-polyglot'
Plug 'mhinz/vim-startify'
Plug 'tpope/vim-surround'
Plug 'christoomey/vim-tmux-navigator'
Plug 'jmcantrell/vim-virtualenv'
Plug 'mg979/vim-visual-multi'
Plug 'liuchengxu/vim-which-key', { 'on': ['WhichKey', 'WhichKey!'] }

call plug#end()
