let s:fontsize = 9
function! AdjustFontSize(amount)
  let s:fontsize = s:fontsize+a:amount
  :execute "GuiFont! Fira Code:h" . s:fontsize
endfunction

noremap <C-ScrollWheelUp> :call AdjustFontSize(1)<CR>
noremap <C-ScrollWheelDown> :call AdjustFontSize(-1)<CR>
inoremap <C-ScrollWheelUp> <Esc>:call AdjustFontSize(1)<CR>a
inoremap <C-ScrollWheelDown> <Esc>:call AdjustFontSize(-1)<CR>a

    "set g:eovim_cursor_cuts_ligatures = 0
    "set g:eovim_running=
    "set g:eovim_theme_bell_enabled=
    "set g:eovim_theme_react_to_key_presses= 0
    "set g:eovim_theme_react_to_caps_lock=
    "set g:eovim_theme_completion_styles=
    "set g:eovim_ext_tabline=
    "set g:eovim_ext_popupmenu=
    "set g:eovim_ext_cmdline=
