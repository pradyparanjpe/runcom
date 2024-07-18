#!/usr/bin/env sh
#-*- coding:utf-8; mode:shell-script -*-
#
# Copyright (c) 2020-2024 Pradyumna Paranjape
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

# Confirm that dependencies are available.
affirm_availability () {
    for _import in sshfs grep; do
        if ! command -v "${_import}" >/dev/null 2>&1; then
            unset _import
            clean_exit 127 "${_import} is not installed\n"
        fi
    done
    unset _import
}

# Set clean variables before running script.
set_vars () {
    # shellcheck disable=SC2154
    if [ -z "${cloud_sship}" ] || [ -z "${cloud_user}" ]; then
        clean_exit 127 "\$cloud_sship AND/OR \$cloud_user is unset\n"
    fi

    # directory to mount all cloud devices
    srv_mnt_dir=
    num_locs=0

    # Mount/"U"Mount
    action="mount"

    #help (usage)
    usage="
    usage: ${0} -h
    usage: ${0} --help
"
    #help (detailed)
    help_msg="${usage}

    DESCRIPTION:
      ssh filesystem mount


    Optional Arguments:
      -h\t\t\tprint usage message and exit
      --help\t\t\tprint this help message and exit

    Optional Positional Arguments:
      u[n]mount\t\tunmount filesystems
"
}

# Unsetset local variables to clean the environment.
unset_vars () {
    unset help_msg
    unset usage
    unset action
    unset num_locs
    unset srv_mnt_dir
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
            unmount|umount)
                action="unmount"
                shift
                ;;
            *)
                clean_exit 1 "${usage}"
        esac
    done
}

# Are we on the right network?
discover () {
    IFS="$(printf '\t')" read -r _ _ netstate << netcheck
$(eval "${RUNCOMDIR}/bin/netcheck.sh")
netcheck
    # shellcheck disable=SC2154
    if [ $(( netstate & mount_net )) ]; then
        # On home network
        srv_mnt_dir="${HOME}/${cloud_sship}"
        # shellcheck disable=SC2154
        num_locs="$(echo "${cloud_locs}" | grep ' ' -c)"
        if [ -n "${clod_locs}" ]; then
            num_locs="$(( num_locs + 1 ))"
        fi
    else
        clean_exit 1 "Not on correct network"
    fi
}

# Mount
mountssh () {
    if [ "$(mount | grep -c "${srv_mnt_dir}")" -lt "${num_locs}" ]; then
        # not mounted
        CDR="${cloud_locs} "
        while [ -n "${CDR}" ]; do
            CAR="${CDR%% *}"
            printf "mounting %s -> %s\n" \
                   "${cloud_user}@${cloud_sship}:${CAR}" \
                   "${srv_mnt_dir}${CAR}"
            mkdir -p "${srv_mnt_dir}${CAR}"
            sshfs -o \
                  "reconnect,ServerAliveInterval=15,ServerAliveCountMax=3" \
                  "${cloud_user}@${cloud_sship}:${CAR}" "${srv_mnt_dir}${CAR}"
            CDR="${CDR#* }";
        done;
        unset CAR CDR
    fi
}

# Unmount
umountssh () {
    set -- "${cloud_locs}"
    if [ "$(mount | grep -c "${srv_mnt_dir}")" -ge "${num_locs}" ]; then
        # mounted
        CDR="${cloud_locs} "
        while [ -n "${CDR}" ]; do
            CAR="${CDR%% *}"
            printf "unmounting %s\n" "${srv_mnt_dir}${CAR}"
            umount "${srv_mnt_dir}${CAR}"
            CDR="${CDR#* }";
        done
    fi
    unset CAR CDR
}

# main routine call
main () {
    affirm_availability
    set_vars
    cli "$@"
    discover
    if [ "${action}" = 'unmount' ]; then
        umountssh
    else
        mountssh
    fi
    clean_exit
}

main "$@"
