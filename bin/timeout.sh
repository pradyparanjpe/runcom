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
    # time out seconds
    t_o_s=5

    # Command to attempt
    cmd_exec=

    # help (usage)
    usage="
    usage: ${0} -h
    usage: ${0} --help
    usage: ${0}
    usage: ${0} [--] TIME CMD
"

    # help (details)
    help_msg="${usage}

    DESCRIPTION:
        Launch CMD, wait for it to complete, if not in time, kill

    Optional arguments:
        -h\tprint usage message and exit
        --help\tprint this help message and exit
        --\t$(basename "${0}")'s argument end; required if CMD has arguments

    Optional Positional argument:
        TIME\tTime out in seconds [default: ${t_o_s}]
        CMD\tCommand to launch [default: print netinfo]
"
}

# Unsetset local variables to clean the environment.
unset_vars() {
    unset help_msg
    unset usage
    unset cmd_exec
    unset t_o_s
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
                shift 1
                t_o_s="${1}"
                shift 1
                if [ -n "${cmd_exec}" ]; then
                    cmd_exec="${cmd_exec} $*"
                else
                    cmd_exec="$*"
                fi
                break
                ;;
            *)
                t_o_s="${1}"
                shift 1
                if [ -n "${cmd_exec}" ]; then
                    cmd_exec="${cmd_exec} $*"
                else
                    cmd_exec="$*"
                fi
                break
                ;;
        esac
    done
    if [ -z "${cmd_exec}" ]; then
        cmd_exec=netinfo
    fi
}

# Cpmmected omtermet info
netinfo () {
    # shellcheck source=./bin/netcheck.sh
    net_out="$("${RUNCOMDIR}"/bin/netcheck.sh | tr '\n' ' ')"
    # fish first arg as ip_addr and last arg as netstat
    ip_addr="$(echo "${net_out}" | awk '{print $1}')"
    netstate="$(echo "${net_out}" | rev | awk '{print $1}' | rev)"
    unset net_out
    if [ $(( netstate & 8)) = 8 ]; then
        printf "\e[1;34mInternet (GOOGLE) Connected\e[m\n"
        if [ ! $(( netstate & 16 )) = 16 ]; then
            printf "\e[1;35mProblem with DNS\e[m\n"
        fi
        printf "\033[0;32m%s \e[m is current wireless ip address\n" "$ip_addr"
    else
        printf "\e[1;31mInternet (GOOGLE) Not reachable\e[m\n"
        if [ $(( netstate & 4 )) = 4 ]; then  # Intranet is connected
            printf "\033[0;31mInternet Down\e[m\n"
            if [ $(( netstate & 2 )) = 2 ]; then
                printf "Home network connected,\n"
            elif [ $(( netstate & 1 )) = 1 ]; then
                printf "OFFICE network connected,\n"
            else
                printf "HOTSPOT connected\n"
            fi
        else
            printf "\e[1;33mNetwork connection Disconnected\e[m\n"
        fi
    fi
    # shellcheck source=./bin/proxy_send.sh
    if [ -n "${http_proxy}" ] \
           && ! curl "https://duckduckgo.com/" > /dev/null 2>&1 \
           && [ $(( netstate & 1 )) = 1 ]; then
        # shellcheck source=./proxy_send.sh
        eval "${RUNCOMDIR}/bin/proxy_send.sh" \
            && printf "\e[0;33mPROXY AUTH SENT\e[m\n";
        unset auto_proxy
    fi
    unset o_ifs ip_addr
}

_cleanup () {
    kill %1 %2
}

_timeout () {
    trap _cleanup TERM

    (
        $cmd_exec
        kill $$
    ) &

    (
        sleep "$t_o_s"
        printf "Command '%s' timed out, skipping...\n" "${cmd_exec}"
        kill $$
    ) &
    wait
}

main() {
    # Main routine call
    set_vars
    cli "$@"
    _timeout
    clean_exit
}

main "$@"
