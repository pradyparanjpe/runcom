#!/usr/bin/env sh
# -*- coding: utf-8; mode: shell-script; -*-

clone_repo () {
    if [ ! -d "${HOME}/.runcom" ]; then

git clone --recurse-submodules "https://github.com/pradyparanjpe/runcom" "${HOME}/.runcom" || exit 1

else
    printf "%s already exists. Quitting...\n" "${HOME}/.runcom"
    exit 0
fi
}

 mask_stow_directories() {

presence="${HOME}/OLD_CONFIG"
mkdir -p "${presence}"
cat << EOR >> "${presence}/README.md"
# RUNCOM backup
  This directory contains a backup of configuration that existed before runcom setup.
  Files in this directory may be merged to their respective place after inspection.
  I recommend that this directory should **NOT** be deleted.
  It will be required during un-doing the setup.
EOR

for conf_mask in "${HOME}/.runcom/dotfiles/.config"/*; do
    if [ -d "${conf_mask}" ]; then
        hard_directory="${HOME}/.config/${conf_mask##*/}"
        if ! mkdir "${hard_directory}" 2>/dev/null; then
            mv "${hard_directory}" "${presence}/${hard_directory}"
            if ! mkdir "${hard_directory}" 2>/dev/null; then
                # still no luck
                printf "%s Couldn't be removed and backed up\n" "${hard_directory}"
                printf "This *shall* cause stow error\n"
            fi
        fi
    fi
done
mkdir -p "${HOME}/.config/pvt.d"
mkdir -p "${HOME}/.config/local.d"

for data_mask in "${HOME}/.runcom/dotfiles/.local/share"/*; do
    if [ -d "${conf_mask}" ]; then
        hard_directory="${HOME}/.local/share/${data_mask##*/}"
        if ! mkdir "${hard_directory}" 2>/dev/null; then
            mv "${hard_directory}" "${presence}/${hard_directory}"
            if ! mkdir "${hard_directory}" 2>/dev/null; then
                # still no luck
                printf "%s Couldn't be removed and backed up\n" "${hard_directory}"
                printf "This *shall* cause stow error\n"
            fi
        fi
    fi
done
unset hard_directory
unset non_mt_msg

move_cargo () {
    CARGO_HOME="${HOME}/.local/share/cargo"
    LOCAL_BIN="${HOME}/.local/bin"
    BAD_CARGO_HOME="${HOME}/.cargo"
    BAD_CARGO_BIN="${HOME}/.cargo/bin"
    if [ -d "${BAD_CARGO_HOME}" ] && [ ! -L "${BAD_CARGO_HOME}" ]; then
        mv -t "${CARGO_HOME}" "${BAD_CARGO_HOME}"
    fi
    if [ ! "$(readlink -f "${CARGO_HOME}/bin")" = "${LOCAL_BIN}" ]; then
        mv -t "${LOCAL_BIN}" "${CARGO_HOME}/bin"/* && \
            rmdir "${CARGO_HOME}/bin" && \
            ln -s "${LOCAL_BIN}" "${CARGO_HOME}/bin"
    fi
    export CARGO_HOME
    unset LOCAL_BIN
    unset BAD_CARGO_HOME
    unset BAD_CARGO_BIN
}

}
 stow_deploy() {
     if ! stow -vS -t "${HOME}" -d "${HOME}/.runcom" dotfiles; then
         # stow threw error
         stow_error="$?"
         printf "Fix above errors and try again."
         exit "${stow_error}"
     fi
 }

 main () {
     clone_repo
     mask_stow_directories
     stow_deploy
     move_cargo
 }
 main "$@"
