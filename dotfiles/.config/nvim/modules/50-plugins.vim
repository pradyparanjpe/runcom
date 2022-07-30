" Plugged plugins
"
" download plug.vim if unavailable
if empty(glob(g:datadir . '/site/autoload/plug.vim'))
  silent execute '!curl -fLo '.g:datadir.'/site/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin(g:datadir . '/plugged')

Plug 'jiangmiao/auto-pairs'

Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'Shougo/denite.nvim',
Plug 'zchee/deoplete-jedi'

Plug 'junegunn/fzf.vim'

Plug 'scrooloose/nerdtree'
Plug 'preservim/nerdcommenter'
Plug 'Xuyuanp/nerdtree-git-plugin'

Plug 'equalsraf/neovim-gui-shim'
Plug 'jalvesaq/Nvim-r'
Plug 'neovim/nvim-lspconfig'

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
Plug 'tpope/vim-speeddating'
Plug 'mhinz/vim-startify'
Plug 'tpope/vim-surround'
Plug 'christoomey/vim-tmux-navigator'
Plug 'jmcantrell/vim-virtualenv'
Plug 'mg979/vim-visual-multi'
Plug 'liuchengxu/vim-which-key', { 'on': ['WhichKey', 'WhichKey!'] }

call plug#end()

for plugcfg in split(glob(fnamemodify(resolve(expand('<sfile>:p')), ':h')
      \ . '/plugged/*.vim'), '\n')
exe 'source' plugcfg
endfor
