#!/usr/bin/env sh
#-*- coding:utf-8; mode:shell-script -*-
#
# Copyright (c) 2020-2023 Pradyumna Paranjape
#
## Check for network connectivity at the beginning
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
set_vars() {

    # Google's ip address (also used as DNS server)
    google_ip="8.8.8.8"

    # Google's domain name
    google_dn="www.google.com"

    # our current IP
    if ! ip_addr="$(hostname -I 2>/dev/null)"; then
        ip_addr="$(hostname -i | awk '{print $(NF);}')"
    fi

    # Our current access point address
    ap_addr="$(ip route show default \
            | grep -o "\([0-9]\{1,3\}\.\)\{3\}[0-9]\{1,3\}")"

    # State of network Code.
    netstate=0

    # @ work bit
    work_net=1

    # @ home bit
    home_net=2

    # @ Intranet bit
    intranet=4

    # @ Internet bit
    internet=8

    # @ DNS bit
    googledn=16
}

# Unsetset local variables to clean the environment.
unset_vars() {
    unset netstate
    unset ip_addr
    unset ap_addr
    unset google_ip
    unset google_dn
    unset googledn
    unset internet
    unset intranet
    unset home_net
    unset work_net
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

# Are we at home?
at_home() {
    # shellcheck disable=SC2154
    for ap in ${home_ap}; do
        if [ "${ap}" = "${ap_addr}"  ]; then
            netstate=$((netstate | home_net))
            break
        fi
    done
    unset ap
}

# Ping a target
#
# Send a quiet ping to a target, wait for a reply for 2 seconcs.
# Args:
#    $1: target to ping
#
# Returns:
#    exit code fom ping trial
ping_target () {
    if [ -z "${1}" ]; then
        return 1
    fi
    ping -c 1 -q -w 2 "${1}" >/dev/null 2>&1
    return $?
}

# Check if various targets can be pinged.
#
# Set netstate based on replies from various targets.
# Args:
#    $1: Proxy details.
check_ping() {
    for line in $1; do
        extract_key "${line}"
    done

    if [ -z "$ip_addr" ]; then
        clean_exit 1
    fi
    if ping_target "${google_dn}"; then
        # Google's domain name can be resolved and pinged.
        netstate=$((netstate | googledn | internet))
    elif ping_target "${google_ip}"; then
        # can't resolve dns, but Google's ip can be pingged.
        netstate=$((netstate | internet))
    fi
    if ping_target "${ap_addr}"; then
        # can't reach google, but access-point is still reachable
        netstate=$((netstate | intranet))
    fi
    if [ ! $((netstate & home_net)) = $home_net ]; then
        # !@ HOME
        # shellcheck disable=SC2154
        for ap in ${work_ap}; do
            if ping_target "${ap}"; then
                # @ work
                netstate=$((netstate | work_net))
                break
            fi
        done
    fi
    unset ap
}

main() {
    set_vars
    at_home
    check_ping "$@"
    printf "%s\t%s\t%s\n" "${ip_addr}" "${ap_addr}" "${netstate}"
    clean_exit
}

main "$@"
