let g:confdir = has('nvim') ? stdpath('config') : '~/.vim'
let g:datadir = has('nvim') ? stdpath('data') : '~/.local/share/vim'
let g:cachedir = has('nvim') ? stdpath('cache') : '~/.cache/vim'

" only for plain vim
if ! has('nvim')
for autosrc in split(glob(g:datadir . '/site/autoload/*.vim'), '\n')
exe 'source' autosrc
endfor
endif

