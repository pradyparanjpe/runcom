" Syntax
syntax region DocString start=/^ *\v"""/ skip=/\\"\\"\\"/ end=/\v"""/
syntax region DocString start="^ *\v'''" skip="\\'\\'\\'" end="\v'''"
syntax keyword PyBuiltIn any all
syntax keyword PyBuiltIn len repr open file
syntax keyword PyBuiltIn str int float list tuple dict set bool
syntax keyword PyBuiltIn open file
syntax keyword PyMagic __init__
syntax keyword PySelf self cls print
call matchadd('PyMagic', '__.*__')
syntax keyword PyArgs args kwargs

" Highlights
highlight link PyMagic PyBuiltIn

highlight PyBuiltin cterm=None  ctermbg=None    ctermfg=178  gui=None   guibg=None  guifg=#d7af00
highlight DocString cterm=None  ctermbg=None    ctermfg=134  gui=None   guibg=None  guifg=#af5f00
highlight link PyArgs Statement
highlight link PySelf Statement

