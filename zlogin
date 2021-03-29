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

avail_editors=( 'emacsclient -nw -c -a=""'
                'nvim'
                'vim'
                'vi'
                'nano' )
for avail in "${avail_editors[@]}"; do
    if command -v "${avail%% *}" -- &>/dev/null; then
        EDITOR="${avail}"
        break
    fi
done
export EDITOR

if [ -f "${RUNCOMDIR}"/ui ]; then
    . "${RUNCOMDIR}"/ui
fi
