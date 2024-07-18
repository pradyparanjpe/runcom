#!/usr/bin/env sh
# -*- coding: utf-8; mode: shell-script; -*-
#
# Copyright © 2020-2024 Pradyumna Paranjape
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

RUNCOMDIR="${RUNCOMDIR:-${HOME}/.runcom}"

unstow_undeploy() {
    if ! stow -v -t "${HOME}" -d "${RUNCOMDIR}" -D dotfiles; then
        # stow threw error
        stow_error="$?"
        printf "Fix above errors and try again."
        exit "${stow_error}"
    fi
}

restore_configurations() {

if [ ! -d "${1:-${XDG_CACHE_HOME:-${HOME}/.cache}/OLD_CONFIG}" ]; then
    printf "Old Configuration not found. Please supply as a positional argument.\n"
    printf "Such as %s <path/to/old/config/directory>\n" "$0"
    exit 1
fi

for conf_dir in "${1:-${XDG_CACHE_HOME:-${HOME}/.cache}/OLD_CONFIG}"/*; do
    cp -r "${conf_dir}" "${HOME}"/. || break
done

# shellcheck disable=SC2181
if [ $? -ne 0 ]; then
    printf "Restoration unsuccessful, copy backup files manually.\n"
else
    printf "Restoration successful, backup directory may be deleted.\n"
fi

}

 delete_repo () {

rm -rf "${RUNCOMDIR}" && printf "Goodbye 👋\n"

}

 main () {
     unstow_undeploy
     restore_configurations "$@"
     delete_repo

move_roots .cargo CARGO_HOME
move_roots go GOPATH

}

 main "$@"
