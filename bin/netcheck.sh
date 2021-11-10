#!/usr/bin/env sh
#-*- coding:utf-8; mode:shell-script -*-
#
# Copyright 2020, 2021 Pradyumna Paranjape
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

set_vars() {
    google_ip="8.8.8.8"
    google_dn="www.google.com"
    if ! ip_addr="$(hostname -I 2>/dev/null)"; then
        ip_addr="$(hostname -i | awk '{print $(NF);}')"
    fi
    ap_addr="$(ip route show default \
            | grep -o "\([0-9]\{1,3\}\.\)\{3\}[0-9]\{1,3\}")"
    net_state=0
    googledn=16
    internet=8
    intranet=4
    home_net=2
    work_net=1
}

unset_vars() {
    unset net_state
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

at_home() {
    # shellcheck disable=SC2154
    for ap in ${home_ap}; do
        if [ "${ap}" = "${ap_addr}"  ]; then
            net_state=$((net_state | home_net))
            break
        fi
    done
    unset ap
}

ping_target () {
    if [ -z "${1}" ]; then
        return 1
    fi
    ping -c 1 -q -w 2 "${1}" >/dev/null 2>&1
    return $?
}

check_ping() {
    if [ -z "$ip_addr" ]; then
        clean_exit 1
    fi
    if ping_target "${google_dn}"; then
        net_state=$((net_state | googledn | internet))
    elif ping_target "${google_ip}"; then
        # can't resolve dns
        net_state=$((net_state | internet))
    fi
    if ping_target "${ap_addr}"; then
        net_state=$((net_state | intranet))
    fi
    if [ ! $((net_state & home_net)) ]; then
        # shellcheck disable=SC2154
        for ap in ${work_ap}; do
            if ping_target "${ap}"; then
                net_state=$((net_state | work_net))
                break
            fi
        done
    fi
    unset ap
}

main() {
    set_vars
    at_home
    check_ping
    printf "%s\t%s\t%s\n" "${ip_addr}" "${ap_addr}" "${net_state}"
    clean_exit
}

main
