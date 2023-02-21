#!/usr/bin/env sh
# -*- coding:utf-8; mode:shell-script -*-
#
# Copyright 2020, 2021, 2022 Pradyumna Paranjape
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

clean_exit() {
    unset_vars
    if [ -n "${1}" ] && [ "${1}" -ne "0" ]; then
        if [ -n "${2}" ]; then
            # shellcheck disable=SC2059
            printf "${2}\n" >&2
        fi
        # shellcheck disable=SC2086
        exit ${1}
    fi
    if [ -n "${2}" ]; then
        # shellcheck disable=SC2059
        printf "${2}\n"
    fi
    exit 0
}

parse_desktop_entry () {
    client="${1}"
    proto="${2}"
    if [ ! -f "${client}" ]; then
        if [ "$(dirname "${client}")" = '.' ]; then
            client="/usr/share/${proto}sessions/${client}"
        else
            clean_exit 1 "Bad wayland session: ${client}."
        fi
    fi
    exec_line="$(grep -i "^exec" "${client}" | head -1)"
    if [ -z "${exec_line}" ]; then
        exec_line="$(grep -i "^tryexec" "${client}" | head -1)"
    fi
    # exec_cmd is used by waystart  and x11start scripts, which call this function
    # shellcheck disable=SC2034
    exec_cmd="${exec_line#*=}"
    unset desk_line
}
