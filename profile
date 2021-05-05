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

RUNCOMDIR="${HOME}/.runcom"
export RUNCOMDIR
# shellcheck source="bin"
if [ -d "${HOME}/bin" ] ; then
    if [ "${PATH#*${HOME}/bin}" = "${PATH}" ]; then
        PATH="${HOME}/bin:${PATH}"
    fi
fi
# shellcheck source=".local/bin"
if [ -d "${HOME}/.local/bin" ] ; then
    if [ "${PATH#*${HOME}/.local/bin}" = "${PATH}" ]; then
        PATH="${HOME}/.local/bin:${PATH}"
    fi
fi
export PATH;

while read -r avail; do
    if command -v "${avail}" >/dev/null 2>&1; then
        EDITOR="${avail}"
    fi
done << EOF
nano
vi
vim
nvim
EOF
export EDITOR

case "$EDITOR" in
    vim)
        export MANPAGER='/bin/bash -c "vim -MRn -c \"set buftype=nofile showtabline=0 ft=man ts=8 nomod nolist norelativenumber nonu noma\" -c \"normal L\" -c \"nmap q :qa<CR>\"</dev/tty <(col -b)"'
        ;;
    nvim)
        export MANPAGER="nvim -c 'set ft=man' -"
        ;;
    *)
        export MANPAGER='bat -l man -p'
        ;;
esac
export MANPAGER

LD_LIBRARY_PATH="${HOME}/.local/lib:${HOME}/.local/lib64";
C_INCLUDE_PATH="${HOME}/.pspman/include/"
CPLUS_INCLUDE_PATH="${HOME}/.pspman/include/"
export LD_LIBRARY_PATH
export C_INCLUDE_PATH
export CPLUS_INCLUDE_PATH

PYOPENCL_CTX='0';
PYOPENCL_COMPILER_OUTPUT=1;
OCL_ICD_VENDORS="/etc/OpenCL/vendors/";
export PYOPENCL_CTX
export PYOPENCL_COMPILER_OUTPUT
export OCL_ICD_VENDORS

NO_AT_BRIDGE=1
export NO_AT_BRIDGE
