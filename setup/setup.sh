#!/usr/bin/env sh
# -*- coding: utf-8; mode: shell-script; -*-

clone_repo () {
    if [ ! -d "${HOME}/.runcom" ]; then

git clone --recurse-submodules "https://github.com/pradyparanjpe/runcom" "${HOME}/.runcom" || exit 1

else
    printf "${HOME}/.runcom already exists. Quitting...\n"
    exit 0
fi
}

 mask_stow_directories() {

presence="${HOME}/OLD_CONFIG"
mkdir -p "${presence}"
cat << EOR >> "${presence}/README.md"
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
        fi
        if ! mkdir "${hard_directory}" 2>/dev/null; then
            # still no luck
            printf "%s Couldn't be removed and backed up\n"
            printf "This *shall* cause stow error\n"
        fi
    fi
done
for data_mask in "${HOME}/.runcom/dotfiles/.local/share"/*; do
    if [ -d "${conf_mask}" ]; then
        hard_directory="${HOME}/.local/share/${data_mask##*/}"
        if ! mkdir "${hard_directory}" 2>/dev/null; then
            mv "${hard_directory}" "${presence}/${hard_directory}"
        fi
        if ! mkdir "${hard_directory}" 2>/dev/null; then
            # still no luck
            printf "%s Couldn't be removed and backed up\n"
            printf "This *shall* cause stow error\n"
        fi
    fi
done
unset hard_directory
unset non_mt_msg

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
 }
 main "$@"
