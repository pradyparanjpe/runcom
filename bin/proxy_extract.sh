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

# Confirm that dependencies are available.
affirm_availability () {
    for _import in pass curl; do
        if ! command -v "${_import}" >/dev/null 2>&1; then
            unset _import
            clean_exit 127 "${_import} is not installed\n"
        fi
    done
    unset _import
}

# Set clean variables before running script.
set_vars () {
    # send to clipboard
    clip=false

    # compiled proxy header
    proxy_header=

    pass_keys=
    if [ -z "${proxy_protocol}" ]; then
        proxy_protocol='all'
    fi

    proxy_username=
    proxy_password=
    proxy_host=
    proxy_port=

    #help (usage)
    usage="
    usage: ${0} -h
    usage: ${0} --help
    usage: ${0}
"
    #help (detailed)
    help_msg="${usage}

    DESCRIPTION:
      extract proxy authentication from password store


    Optional Arguments:
      -h\tprint usage message and exit
      --help\tprint this help message and exit
      -c|--clip\tCopy to clipboard
"
}

# Unsetset local variables to clean the environment.
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
            -c|--clip)
                clip=true
                shift
                ;;
            *)
                clean_exit 1 "${usage}"
        esac
    done
}

# Convert plain-text value into html quoted form.
quote () {
    printf "%s" "$1" \
        | tr -d '\n' \
        | curl -Gso /dev/null -w "%{url_effective}" --data-urlencode @- "" \
        | cut -c 3-
}

# Extract value from key-value pair separated by <:>.
# Args:
#    $1: secret of the form "key: value"
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

# Extract secret(s) from passed string.
# Args:
#    $1: string with secrets.
#        This may be simply the proxy_password
#        or elaborate list of secrets.
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

# Retrieve proxy from unix password manager.
get_pass_proxy () {
    ## build proxy authentication
    if command -v "pass" >/dev/null 2>&1; then
        # password store is available
        if [ -n "${proxy_auth}" ]; then
            extract_secret "$(pass show "${proxy_auth}")"
        fi
    fi
}

# Compile proxy into the form accepted by http request.
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

# Main routine call
main() {
    set_vars
    cli "$@"
    get_pass_proxy
    compile_proxy
    if $clip; then
        if ! wl-copy "${proxy_header}" ; then
            xcopy "${proxy_header}"
        fi
    else
        printf "%s\n" "${proxy_header}"
    fi
    clean_exit
}

main "$@"
