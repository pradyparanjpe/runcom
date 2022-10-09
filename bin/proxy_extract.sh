#!/usr/bin/env sh
# -*- coding:utf-8; mode:shell-script -*-
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

affirm_availability () {
    for _import in pass curl; do
        if ! command -v "${_import}" >/dev/null 2>&1; then
            unset _import
            clean_exit 127 "${_import} is not installed\n"
        fi
    done
    unset _import
}

set_vars () {
    show=false
    proxy_header=
    pass_keys=
    if [ -z "${proxy_protocol}" ]; then
        proxy_protocol='all'
    fi
    proxy_username=
    proxy_password=
    proxy_host=
    proxy_port=
    usage="
    usage: ${0} -h
    usage: ${0} --help
    usage: ${0}
"
    help_msg="${usage}

    DESCRIPTION: |
      extract proxy authentication from password store


    Optional Arguments: |
      -h\t\t\tprint usage message and exit
      --help\t\t\tprint this help message and exit

"
}

unset_vars() {
    unset help_msg
    unset usage
    unset proxy_port
    unset proxy_host
    unset proxy_password
    unset proxy_username
    unset pass_keys
    unset proxy_header
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
            -s|--show)
                show=true
                shift
                ;;
            *)
                clean_exit 1 "${usage}"
        esac
    done
}

quote () {
    printf "%s" "$1" \
        | tr -d '\n' \
        | curl -Gso /dev/null -w "%{url_effective}" --data-urlencode @- "" \
        | cut -c 3-
}

extract_key () {
    key="$(printf "%s" "$1" | cut -d: -f1 )"
    value="$(printf "%s" "$1" | cut -d: -f2 )"
    value="${value## }"  # remove exactly 1 space from the start
    case "${key}" in
        protocol)
            proxy_protocol="${value}"
            ;;
        address)
            proxy_host="${value}"
            ;;
        port)
            proxy_port="${value}"
            ;;
        username)
            proxy_username="$(quote "${value}")"
            ;;
        password)
            proxy_password="$(quote "${value}")"
            ;;
        *)
            # do nothing about misplaced information
            true
            ;;
    esac
    unset key value
}

extract_secret () {
    if [ -z "$1" ]; then
        return
    fi
    if [ "$(printf "%s" "$1" | wc -l)" = 1 ]; then
        # only 1 line, may be password or single secret
        if [ "${1##: *}" = "${1}" ]; then
            # ': ' is not present in the secret, must be password
            proxy_password="$(quote "$1")"
            return
        fi
        for secret in ${pass_keys}; do
            if [ "$(printf "%s" "${1}" | cut -d: -f1)" = "${secret}" ]; then
                # secret key is found
                extract_key "${1}"
                unset secret
                return
            fi
        done
        unset secret_ley
    fi
    o_ifs="${IFS}"
    IFS="$(printf '\n ')" && IFS="${IFS% }"
    for line in $1; do
        extract_key "${line}"
    done
    IFS="${o_ifs}"
    unset o_ifs line
}

get_pass_proxy () {
    ## build proxy authentication
    if command -v "pass" >/dev/null 2>&1; then
        # password store is available
        if [ -n "${proxy_auth}" ]; then
            extract_secret "$(pass show "${proxy_auth}")"
        fi
    fi
}

compile_proxy () {
    if [ -z "${proxy_host}" ]; then
        return
    fi
    if [ -n "${proxy_protocol}" ]; then
        if [ "${proxy_protocol}" = "all" ]; then
            proxy_header="http://"
        else
            proxy_header="${proxy_protocol}://"
        fi
    fi
    if [ -n "${proxy_username}" ]; then
        scrt="${proxy_username}"
        if [ -n "${proxy_password}" ]; then
            scrt="${proxy_username}:${proxy_password}"
        fi
        proxy_header="${proxy_header}${scrt}@"
    fi
    proxy_header="${proxy_header}${proxy_host}"
    if [ -n "${proxy_port}" ]; then
        proxy_header="${proxy_header}:${proxy_port}"
    fi
    proxy_header="${proxy_header}/"
    unset scrt
}

main() {
    # Main routine call
    set_vars
    cli "$@"
    get_pass_proxy
    compile_proxy
    printf "%s\n" "${proxy_header}"
    clean_exit
}

main "$@"
