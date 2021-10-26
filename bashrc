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

shopt -s autocd
set -o vi
bind '"jk":vi-movement-mode'

# shellcheck source=".runcom/shrc"
if [ -f "${RUNCOMDIR}/shrc" ]; then
    . "${RUNCOMDIR}/shrc"
fi
if [ -f "${RUNCOMDIR}/bash-preexec/bash-preexec.sh" ]; then
    . "${RUNCOMDIR}/bash-preexec/bash-preexec.sh"
fi

# export PROMPT_COMMAND=__prompt_command

preexec() {
    _cmd_start_t="${SECONDS}"
}

precmd () {
    _exit_color="$(last_exit_color $?)"

    _elapsed="$(_elapsed_time $_cmd_start_t ${SECONDS})"
    unset _cmd_start_t

    # unset previous
    PS1=""
    PS2=""
    PS3=""
    PS4=""
    RPROMPT=""

    PS1+="\[\e[0;32m\]\u\[\e[m\]"
    PS1+="\[\e[3;35m\]\$(_show_venv)\[\e[m\]"
    PS1+="@"
    PS1+="\[\e[0;34m\]\h\[\e[m\]"
    PS1+="\$(git_ps)"
    PS1+="\[\e[0;36m\]:\W"
    PS1+="\[\e[0;37m\]"

    PS1+="$(date '+%H:%M:%S')"
    PS1+=" ${_exit_color}-${_elapsed}"
    PS1+='\[\e[m\]\n» '

    PS2=""
    PS2+="\[\e[0;36m\]cont..."
    PS2+="\[\e[m\]"
    PS2+="» ";

    PS3='Selection: ';
}
