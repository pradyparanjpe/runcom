" reset cursor on start:
augroup myCmds
au!
autocmd VimEnter * silent !echo -ne "\e[2 q"
augroup END

" Switch to block / beam in cmd / ins mode
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"

