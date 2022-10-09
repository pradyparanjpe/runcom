#!/usr/bin/env sh
# -*- coding: utf-8; mode: shell-script; -*-

unstow_undeploy() {
    if ! stow -vp -t "${HOME}" -d "${HOME}/.runcom" -D dotfiles; then
        # stow threw error
        stow_error="$?"
        printf "Fix above errors and try again."
        exit "${stow_error}"
    fi
}

restore_configurations() {

if [ ! -d "${1:-${HOME}/OLD_CONFIG}" ]; then
    printf "Old Configuration not found. Please supply as a positional argument.\n"
    printf "Such as %s <path/to/old/config/directory>\n" "$0"
    exit 1
fi

for conf_dir in "${1:-${HOME}/OLD_CONFIG}"/*; do
    cp -r "${conf_dir}" "${HOME}"/. || break
done

# shellcheck disable=SC2181
if [ $? -ne 0 ]; then
    printf "Restoration unsuccessful, copy backup files manually.\n"
else
    printf "Restoration successful, backup directory may be deleted.\n"
fi

BAD_CARGO_HOME="${HOME}/.cargo"
if [ -L "${BAD_CARGO_HOME}" ]; then
    rm "${BAD_CARGO_HOME}"
fi
mv "${CARGO_HOME}" "${HOME}/.cargo"
unset CARGO_HOME BAD_CARGO_HOME
export CARGO_HOME

}

 delete_repo () {

rm -rf "${RUNCOMDIR:-${HOME}/.runcom}" && printf "Goodbye ✋"

}

 main () {
     unstow_undeploy
     restore_configurations "$@"
     delete_repo
 }
 main "$@"
