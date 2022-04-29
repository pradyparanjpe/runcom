# shellcheck shell=bash
# -*- coding:utf-8; mode:shell-script; -*-
#
# Copyright 2020, 2021 Pradyumna Paranjape
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
#===================================================================
#  ___             _      ___                     _
# | _ \_ _ __ _ __| |_  _| _ \__ _ _ _ __ _ _ _  (_)_ __  ___
# |  _/ '_/ _` / _` | || |  _/ _` | '_/ _` | ' \ | | '_ \/ -_)
# |_| |_| \__,_\__,_|\_, |_| \__,_|_| \__,_|_||_|/ | .__/\___|
#                    |__/                      |__/|_|
#===================================================================

# The following lines were added by compinstall

zstyle ':completion:*' completer _complete _ignored _approximate
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' matcher-list ''
zstyle ':completion:*' max-errors 2
zstyle ':completion:*' menu select=3
zstyle ':completion:*' select-prompt %SScrolling \
       active: current selection at %p%s
zstyle :compinstall filename "${HOME}/.zshrc"

# End of lines added by compinstall
# Lines configured by zsh-newuser-install

HISTFILE="${XDG_CACHE_HOME:-${HOME}/.cache}/.zhistory"
HISTSIZE=10000
SAVEHIST=10000

ZSH_COMPDUMP="${XDG_CACHE_HOME:-${HOME}/.cache}/.zcompdump"

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#5f6f7f,bg=#172737"
ZSH_AUTOSUGGEST_STRATEGY=("history" "completion")
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
autoload add-zsh-hook
autoload -Uz compinit
autoload -Uz bashcompinit
compinit
bashcompinit

term_key_source="${HOME}/.zkbd/$TERM-${${DISPLAY:t}:-$VENDOR-$OSTYPE}"
if [ -f "${term_key_source}" ]; then
    . "${term_key_source}"
fi
# keybindings
bindkey -v
bindkey -s '^o' 'lfcd\n'
bindkey -s '^f' 'fzfcd\n'
bindkey -s '^E' 'deactivate 2>/dev/null || true\n'
bindkey -s '^N' 'force_global_venv\n'
bindkey '^[[P' delete-char  # backspace key
bindkey '^[[1;5D' vi-backward-word  # ctrl <-
bindkey '^[[1;5C' vi-forward-word  # ctrl ->
bindkey '^[[3~' vi-delete-char  # delete key
bindkey '^[[F' vi-end-of-line  # end key
bindkey '^[[H' vi-beginning-of-line  # home key
bindkey "^[[27;2;13~" vi-open-line-below  # shift Return
export KEYTIMEOUT=10

# Use beam shape cursor for each new prompt.
_fix_cursor () {
    echo -ne '\e[6 q'
}
add-zsh-hook precmd _fix_cursor

# Change cursor shape for different vi modes.
zle-keymap-select () {
    if [ "${KEYMAP}" = "vicmd" ] ||
           [ "${1}" = 'block' ]; then
        printf '\e[2 q'

    elif [ "${KEYMAP}" = "main" ] ||
             [ "${KEYMAP}" = "viins" ] ||
             [ "${KEYMAP}" = '' ] ||
             [ "${1}" = 'beam' ]; then
        printf '\e[6 q'
    elif [ "${KEYMAP}" = "visual" ]; then
        printf '\e[4 q'
    fi
}
# Use vim keys in tab complete menu:
zmodload zsh/complist
zmodload zsh/mapfile
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char
bindkey -M viins 'jk' vi-cmd-mode
bindkey '^r' history-incremental-search-backward

zle -N zle-keymap-select

# shellcheck source=".runcom/env/shrc"
if [ -f "${RUNCOMDIR:-${HOME}/.runcom}/env/shrc" ]; then
    . "${RUNCOMDIR:-${HOME}/.runcom}/env/shrc"
fi
while read -r addition; do
    while read -r share_dir; do
        add_dir="${share_dir}/zsh-${addition}"
        if [ -d "${add_dir}" ]; then
            # shellcheck disable=SC1090
            . "${add_dir}/zsh-${addition}.zsh"
            break
        fi
    done << data_dir
/usr/local/share
/usr/share
/usr/share/zsh/plugins
${XDG_DATA_HOME:-${HOME}/.local/share}
${XDG_DATA_HOME:-${HOME}/.local/share}/pspman/local/share
${HOME}/local/share
${HOME}/share
data_dir
done << addlist
syntax-highlighting
autosuggestions
addlist

unset addition share_dir add_dir

_pspexec() {
    _cmd_start_t="${SECONDS}"
}

_pspps () {
    _exit_color="$(last_exit_color $?)"

    _elapsed="$(_elapsed_time $_cmd_start_t ${SECONDS})"
    unset _cmd_start_t

    # unset previous
    PS1=$''
    PS2=$''
    PS3=$''
    PS4=$''
    RPROMPT=$''

    PS1+=$'%{\e[0;32m%}%n%{\e[m%}'
    PS1+=$'%{\e[3;35m%}'
    PS1+="$(_show_venv)"
    PS1+=$'%{\e[m%}'
    PS1+=$'@'
    PS1+=$'%{\e[0;34m%}%m%{\e[m%}'
    PS1+="$(git_ps)"
    PS1+=$'%{\e[0;36m%}:%1~'
    PS1+=$'%{\e[0;37m%}\n%{\e[m%}» '

    PS2+=$'%{\e[0;36m%}cont...'
    PS2+=$'%{\e[m%}'
    PS2+=$'» '

    PS3='Selection: '

    RPROMPT+=$'%*'
    RPROMPT+="%{$_exit_color%}-${_elapsed}"
    RPROMPT+=$'%{\e[m%}'
    unset _exit_stat _elapsed
}

add-zsh-hook precmd _pspps
add-zsh-hook preexec _pspexec
