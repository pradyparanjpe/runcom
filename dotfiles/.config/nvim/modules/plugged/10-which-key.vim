"set timeoutlen=500
autocmd! User vim-which-key call which_key#register('<Space>', 'g:leader_map')

 "Define leaders
let g:mapleader = "\<Space>"
let g:maplocalleader = ','
let g:leader_map = {}
let g:leader_map.name = 'which-key'


nnoremap <silent><leader>          :<c-u>WhichKey '<Space>'<CR>
nnoremap <silent><localleader>     :<c-u>WhichKey  ','<CR>
vnoremap <silent><leader>          :<c-u>WhichKeyVisual '<Space>'<CR>


" Define prefix dictionary
for s:i in range(1, 9)
    let g:leader_map[s:i] = [':'.s:i.'wincmd w', 'which_key_ignore']
endfor
unlet s:i
let g:leader_map['<Tab>'] = ['<C-w>w', 'switch-window']


let g:leader_map['/'] = [':Rg!<CR>', 'find in project']


let g:leader_map.b = {
    \ 'name' : '+buffer' ,
    \ '1' : ['b1'        , 'buffer 1']        ,
    \ '2' : ['b2'        , 'buffer 2']        ,
    \ 'b' : ['Buffers'   , 'fzf-buffer']      ,
    \ 'd' : ['bd'        , 'delete-buffer']   ,
    \ 'f' : ['bfirst'    , 'first-buffer']    ,
    \ 'h' : ['Startify'  , 'home-buffer']     ,
    \ 'l' : ['blast'     , 'last-buffer']     ,
    \ 'n' : ['bnext'     , 'next-buffer']     ,
    \ 'p' : ['bprevious' , 'previous-buffer'] ,
    \ }

let g:leader_map.e = {
    \ 'name': '+errors',
    \ 'N': ['n_coc-diagnostic-prev-error', 'previous-error'],
    \ 'n': ['n_coc-diagnostic-next-error', 'next-error'],
    \ }

nnoremap <silent> <leader>fed :e $XDG_CONFIG_HOME/nvim/init.vim<CR>
nnoremap <silent> <leader>fep :e $XDG_CONFIG_HOME/nvim/modules/50-plugins.vim<CR>
let g:leader_map.f = {
    \ 'name' : '+file',
    \ 'e': {
        \ 'name': '+evil',
        \ 'd': 'open-vimrc',
        \ 'p': 'open-plugins',
    \ },
    \ 'f': ['Files', 'open file'],
    \ 's': ['update', 'save-file'],
    \ 't': ['NERDTreeToggle', 'Show/Hide-NERDTree'],
    \ 'w': ['wall', 'save-all'],
    \ }

let g:leader_map.g = {
    \ 'name': '+git',
    \ 's': ['Git', 'open-fugitive-buffer'],
    \ }

let g:leader_map.j = {
    \ 'name': '+jump',
    \ 'j': [':BLine!<CR>', 'open-fugitive-buffer'],
    \ }

nnoremap <leader>lb :!clear && bashate %<CR>
let g:leader_map.l = {
    \ 'name': '+linter',
    \ 'b': 'bashate',
    \ }

let g:leader_map.p = {
    \ 'name': '+Plug',
    \ 'C': {
    \ 'name': '+coc',
    \ 'u': ['CocUpdate', 'update coc'],
    \ },
    \ 'c': ['PlugClean', 'clean'],
    \ 'i': ['PlugInstall', 'install'],
    \ 'u': ['PlugUpdate', 'update'],
    \ }

let g:leader_map.q = {
    \ 'name': '+quit',
    \ 'q': ['quit', 'qall'],
    \ 'Q': ['quit', 'qall'],
    \ }

vnoremap <leader>scy "+y
vnoremap <leader>scY "+Y
vnoremap <leader>scp "+p
vnoremap <leader>scP "+P
nnoremap <leader>scy "+y
nnoremap <leader>scY "+Y
nnoremap <leader>scp "+p
nnoremap <leader>scP "+P
let g:leader_map.s = {
    \ 'name': '+system',
    \ 'c': {
        \ 'name': 'clipboard',
        \ 'y': 'copy-to-system-clipboard',
        \ 'Y': 'copy-line-to-system-clipboard',
        \ 'p': 'paste-from-system-clipboard',
        \ 'P': 'paste-behind-from-system-clipboard',
        \ }
    \}

let g:leader_map.w = {
    \ 'name' : '+windows' ,
    \ 'd' : ['<C-W>c'     , 'delete-window']         ,
    \ 'm' : ['only'     , 'expand-currnet-window']         ,
    \ '-' : ['<C-W>s'     , 'split-window-below']    ,
    \ '|' : ['<C-W>v'     , 'split-window-right']    ,
    \ '2' : ['<C-W>v'     , 'layout-double-columns'] ,
    \ 'h' : ['<C-W>h'     , 'window-left']           ,
    \ 'j' : ['<C-W>j'     , 'window-below']          ,
    \ 'l' : ['<C-W>l'     , 'window-right']          ,
    \ 'k' : ['<C-W>k'     , 'window-up']             ,
    \ 'H' : ['<C-W>5<'    , 'expand-window-left']    ,
    \ 'J' : [':resize +5'  , 'expand-window-below']   ,
    \ 'L' : ['<C-W>5>'    , 'expand-window-right']   ,
    \ 'K' : [':resize -5'  , 'expand-window-up']      ,
    \ '=' : ['<C-W>='     , 'balance-window']        ,
    \ 's' : ['<C-W>s'     , 'split-window-below']    ,
    \ 'v' : ['<C-W>v'     , 'split-window-below']    ,
    \ 'w' : ['Window'     , 'fzf-window']            ,
    \ }

let g:leader_map.u = {
    \ 'name': '+Undotree',
    \ 't': ['UndotreeToggle', 'toggle'],
    \ }

autocmd! FileType which_key
autocmd  FileType which_key set laststatus=0 noshowmode noruler
\| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
