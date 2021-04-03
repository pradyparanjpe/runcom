# shellcheck shell=bash
# -*- coding:utf-8; mode:shell-script; -*-
#
# Copyright 2020 Pradyumna Paranjape
#
# This file is part of Prady_runcom.
#
# Prady_runcom is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Prady_runcom is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Prady_runcom.  If not, see <https://www.gnu.org/licenses/>.
#

HISTFILE="${HOME}/.zhistory"
HISTSIZE=10000
SAVEHIST=10000

setopt autocd
setopt interactive_comments
setopt appendhistory extendedglob notify
setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY               # Don't execute immediately upon history expansion.
unsetopt beep
autoload colors && colors
autoload bashcompinit
bashcompinit

# vim keybindings
bindkey -v
bindkey -s '^o' 'lfcd\n'
bindkey -s '^f' 'fzfcd\n'
bindkey '^[[P' delete-char

export KEYTIMEOUT=40

# Change cursor shape for different vi modes.
zle-keymap-select () {
    if [[ ${KEYMAP} == vicmd ]] ||
           [[ $1 = 'block' ]]; then
        echo -ne '\e[2 q'

    elif [[ ${KEYMAP} == main ]] ||
             [[ ${KEYMAP} == viins ]] ||
             [[ ${KEYMAP} = '' ]] ||
             [[ $1 = 'beam' ]]; then
        echo -ne '\e[6 q'
    fi
}
# Use vim keys in tab complete menu:
zmodload zsh/complist
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

zle -N zle-keymap-select

# Use beam shape cursor for each new prompt.
_fix_cursor () {
    echo -ne '\e[6 q'
}
precmd_functions+=(_fix_cursor)

bindkey -M viins 'jk' vi-cmd-mode
bindkey '^r' history-incremental-search-backward
while read -r share_dir; do
    highlight_dir="${share_dir}/zsh-syntax-highlighting"
    if [ -d "${highlight_dir}" ]; then
        # shellcheck disable=SC1090
        . "${highlight_dir}/zsh-syntax-highlighting.zsh"
        break
    fi
done << EOF
/usr/local/share
/usr/share
${XDG_DATA_HOME:-${HOME}/.local/share}
${XDG_DATA_HOME:-${HOME}/.local/share}/pspman/local/share
${HOME}/local/share
${HOME}/share
EOF

unset share_dir
unset highlight_file

# shellcheck source=".runcom/shrc"
if [ -f "${RUNCOMDIR}"/shrc ]; then
    . "${RUNCOMDIR}"/shrc
fi

precmd () {
    exit_stat="$?"
    PS1=$''
    PS1+="%{$(last_exit_color ${exit_stat})%}"
    PS1+=$'┏━ \e[m'
    PS1+=$'%{\e[0;32m%}%n%{\e[m%}'
    PS1+=$'@'
    PS1+=$'%{\e[0;34m%}%m%{\e[m%}'
    PS1+="$(git_ps)"
    PS1+=$'%{\e[0;37m%}<'
    PS1+=$'%{\e[0;36m%}%1~'
    PS1+=$'%{\e[0;37m%}>'
    PS1+=$'%{\e[0;33m%}%*%{\e[m%}\n'
    PS1+="%{$(last_exit_color ${exit_stat})%}"
    PS1+=$'┗━ %{\e[m%}'

    PS2=$''
    PS2+=$'%{\e[0;36m%}cont...'
    PS2+=$'%{\e[m%}'
    PS2+=$'» ';

    PS3='Selection: ';
}
