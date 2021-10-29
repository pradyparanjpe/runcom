let g:confdir = has('nvim') ? stdpath('config') : '~/.vim'
let g:datadir = has('nvim') ? stdpath('data') : '~/.local/share/vim'
let g:cachedir = has('nvim') ? stdpath('cache') : '~/.cache/vim'

if ! has('nvim')
for auto in split(glob(g:datadir . '/site/autoload/*.vim'), '\n')
exe 'source' auto
endfor
endif

exe 'source' g:confdir . '/modules/00-cursor.vim'
exe 'source' g:confdir . '/modules/10-settings.vim'
exe 'source' g:confdir . '/modules/20-maps.vim'
exe 'source' g:confdir . '/modules/30-hooks.vim'
exe 'source' g:confdir . '/modules/40-plugins.vim'
exe 'source' g:confdir . '/modules/50-which-key.vim'
exe 'source' g:confdir . '/modules/60-coc.vim'
exe 'source' g:confdir . '/modules/70-nerdtree.vim'
exe 'source' g:confdir . '/modules/80-startify.vim'
exe 'source' g:confdir . '/modules/90-colors.vim'
autocmd BufNewFile,BufRead *.py exe 'source' g:confdir . '/modules/91-pycolors.vim'
exe 'source' g:confdir . '/modules/A0-gui.vim'
