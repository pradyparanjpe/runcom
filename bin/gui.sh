#!/usr/bin/env sh
# -*- coding:utf-8; mode:shell-script -*-
#
# Copyright (c) 2020-2024 Pradyumna Paranjape
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

# Set clean variables before running script.
set_vars () {
    # Arguments for application to be launched
    args=

    # Executable for application to be launched
    call=

    # Complete command as passed to us
    cmd=

    # Usage (help)
    usage="
     usage: ${0} -h
     usage: ${0} --help
     usage: ${0} [--] CMD
"

    # help (detailed)
    help_msg="${usage}

     DESCRIPTION: |
       Launch CMD, switch to it, and exit the parent terminal

     Optional arguments: |
       -h\tprint usage message and exit
       --help\tprint this help message and exit
       --\tEnd of ${0}'s arguments; necessary if CMD has arguments

     Positional argument: |
       CMD\tCommand to launch
"
}

# Unsetset local variables to clean the environment.
unset_vars() {
    unset help_msg
    unset usage
    unset cmd
    unset call
    unset args
}

# Clean environment and exit optionally with an exit error code
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

# Parse command line arguments
cli () {
    while [ $# -gt 0 ]; do
        case "${1}" in
            -h)
                # shellcheck disable=SC2059
                clean_exit 0 "${usage}"
                ;;
            --help)
                # shellcheck disable=SC2059
                clean_exit 0 "${help_msg}"
                ;;
            --)
                shift 1;
                # end of gui arguments
                if [ -n "${cmd}" ]; then
                    cmd="${cmd} $*"
                else
                    cmd="$*"
                fi
                break
                ;;
            *)
                # assume gui argument
                if [ -n "${cmd}" ]; then
                    cmd="${cmd} ${1}"
                    shift 1;
                else
                    cmd="${1}"
                    shift 1;
                fi
                break
                ;;
        esac
    done
}

# Launch
launch_gui() {
    call="$(echo "${cmd}" | cut -d " " -f 1)"
    args="${cmd#"${call}"}"
    if [ -z "${call}" ]; then
        printf "%s" "${usage}"
        clean_exit 1
    fi
    if ! command -v "${call}" >/dev/null 2>&1; then
        clean_exit 127 "${call} not found..."
    fi
    unset cmd_help
    unset usage
    eval nohup "${call}" "${args}" >/dev/null 0<&- 2>&1 &
    unset call
    unset args
    exit 65
}

# Main routine call
main() {
    set_vars
    cli "$@"
    launch_gui
    clean_exit
}

main "$@"
