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

shopt -s autocd
set -o vi
bind '"jk":vi-movement-mode'

# shellcheck source=".runcom/shrc"
if [ -f "${RUNCOMDIR}"/shrc ]; then
    . "${RUNCOMDIR}"/shrc
fi

export PROMPT_COMMAND=__prompt_command
__prompt_command () {
    exit_stat="$?"
    PS1=""
    PS1+="\[\$(last_exit_color ${exit_stat})\]┏━ \[\e[m\]"
    PS1+="\[\e[0;32m\]\u\[\e[m\]"
    PS1+="@"
    PS1+="\[\e[0;34m\]\h\[\e[m\]"
    PS1+="\$(git_ps)"
    PS1+="\[\e[0;37m\]<"
    PS1+="\[\e[0;36m\]\W"
    PS1+="\[\e[0;37m\]>"
    PS1+="\[\e[0;33m\]\t\[\e[m\]"
    PS1+="\n\[\$(last_exit_color ${exit_stat})\]┗━ \[\e[m\]"

    PS2=""
    PS2+="\[\e[0;36m\]cont..."
    PS2+="\[\e[m\]"
    PS2+="» ";

    PS3='Selection: ';
}
