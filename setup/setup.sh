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

# @description Edit file in appropriate text editor
# @param $1 file to edit
# Caution zsh doesn't split _text_edit variable
edit_text () {
    _text_edit="${FCEDIT:-${VISUAL:-${EDITOR}}}"
    if [ -z "$_text_edit" ]; then
        for avail in nvim nano vim vi ed; do
            if builtin command -v "${avail}" >/dev/null 2>&1; then
                _text_edit="${avail}"
                break
            fi
        done
    fi
    $_text_edit "$1"
    unset _text_edit
}

clone_repo () {
    if [ ! -d "${RUNCOMDIR:-${HOME}/.runcom}" ]; then

RUNCOMDIR="${HOME}/.runcom"
git clone --recurse-submodules \
    "https://gitlab.com/pradyparanjpe/runcom" \
    "${RUNCOMDIR}" || exit 1

else
    printf "%s already exists. Quitting...\n" "${RUNCOMDIR}"
    exit 0
fi
}

 unsubscribe () {

cp --update=none "${RUNCOMDIR}/setup/dot-stow-local-ignore" \
   "${RUNCOMDIR}/dotfiles/.stow-local-ignore"

printf "Unsubscribe from some upstream configuration? [y/N]:\t"
read -r response
if echo "${response}" | grep -iq "y"; then
    edit_text "${RUNCOMDIR}/dotfiles/.stow-local-ignore" || exit 0
fi
unset response
}

 mask_stow_directories() {

presence="${XDG_CACHE_HOME:-${HOME}/.cache}/OLD_CONFIG"
mkdir -p "${presence}"
cp --update=none "${RUNCOMDIR}/setup/backup.md" "${presence}/README.md"

stow --simulate --no-folding --dotfiles --verbose --stow \
     -t "${HOME}" \
     -d "${RUNCOMDIR}/" \
     dotfiles 2>&1 >/dev/null \
    | grep -o 'target \+\S\+\? ' \
    | cut -d' ' -f2 \
    | xargs -I{} mv {} "${presence}"/{}

}

 stow_deploy() {

if stow --no-folding --dotfiles -v --restow \
        -t "${HOME}" \
        -d "${RUNCOMDIR}" \
        dotfiles ; then

    # Engrave RUNCOMDIR path
    mkdir -p "${HOME}/.profile.d/base_path"
    printf "RUNCOMDIR=\"%s\"\nexport RUNCOMDIR\n" "${RUNCOMDIR}" \
           > "${HOME}/.profile.d/00-base-path"
else
    # stow threw error
    stow_error="$?"
    printf "Fix above errors and try again."
    exit "${stow_error}"
fi

}

# @description
# Move root of LANGuage named as (HOME/$1) to XDG_DATA_HOME/$1. e.g. ".cargo"
#  Any leading dots are stripped to unhide.
# Set Language ROOT Variable ($2) to point to that location. e.g. "CARGO_HOME"
# Symlink ($3) bin location relative to ROOT to "XDG_DATA_HOME/../bin/".
#   E.g. bin: ROOT/bin -> "XDG_DATA_HOME/../bin/". Default: bin
# Set BINVAR ($4) to point to "XDG_DATA_HOME/../bin/". e.g. GOBIN.
move_roots () {
    local_bin="$(realpath "${XDG_DATA_HOME:-${HOME}/.local/share}/../bin")"
    lang_home="${XDG_DATA_HOME:-${HOME}/.local/share}/${1##*.}"
    bad_lang_home="${HOME}/${1}"
    root_lang_bin="${lang_home}/${3:-bin}"
    if [ -d "${bad_lang_home}" ] && [ ! -L "${bad_lang_home}" ]; then
        printf "Moving %s to a better location, %s.\n" "${bad_lang_home}" \
               "${lang_home}"
        mv "${bad_lang_home}" "${lang_home}"
    fi
    eval "${2}=\"${lang_home}\""
    export "${2?}"
    if [ ! "$(readlink -f "${root_lang_bin}")" = "${local_bin}" ]; then
        mv -t "${local_bin}" "${root_lang_bin}"/* 2>&1
        rmdir "${root_lang_bin}"
        ln -s "${local_bin}" "${root_lang_bin}"
    fi
    if [ -n "${4}" ]; then
        eval "${4}=${local_bin}"
        export "${4?}"
    fi
    unset local_bin lang_home bad_lang_home root_lang_bin
}

main () {
    clone_repo
    mask_stow_directories
    unsubscribe
    stow_deploy

move_roots .cargo CARGO_HOME
move_roots go GOPATH

}

main "$@"
