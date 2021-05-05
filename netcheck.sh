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


# Variables
# IP->AP addresses

setvar() {
    ip_addr="$(hostname -I | awk '{print $1}')"
    ap_addr="$(ip route show default \
            | grep -o "\([0-9]\{1,3\}\.\)\{3\}[0-9]\{1,3\}")"
    google_ping_cmd="ping 8.8.8.8 -c 1 -q -w 2"
    office_ping_cmd="ping 192.168.1.101 -c 1 4 -q -w 2"
    intra_ping_cmd="ping ${ap_addr} -c 1 -q -w 2"
    inter=0
    intra=0
    home=0
    [ ! "${ap_addr#*'192.168.1.1'}" = "${ap_addr}"  ] && home=1
    [ ! "${ap_addr#*'192.168.0.1'}" = "${ap_addr}" ] && home=1
    office=0
}

unset_var() {
    unset ip_addr
    unset ap_addr
    unset google_ping_cmd
    unset office_ping_cmd
    unset intra_ping_cmd
    unset inter
    unset intra
    unset office
    unset home
}

clean_exit() {
    unset_var
    if [ -n "${1}" ]; then
        exit "${1}"
    fi
    exit 0
}

check_ping() {
    if [ -z "$ip_addr" ]; then
        clean_exit 1
    fi
    $google_ping_cmd >/dev/null 2>&1 && inter=1
    $intra_ping_cmd >/dev/null 2>&1 && intra=1
    [ "${home}" -eq 0 ] && $office_ping_cmd >/dev/null 2>&1 && office=1
}

main() {
    setvar
    check_ping
    printf "%s\t%s\t%s\n" "${ip_addr}" "${ap_addr}" \
           "$(( 8 * inter + 4 * intra + 2 * home + office ))"
    clean_exit
}

main
