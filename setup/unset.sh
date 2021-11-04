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

for conf_dir in "${1:-${HOME}/OLD_CONFIG}"/*; do
    cp -r "${conf_dir}" "${HOME}"/. || break
done

# shellcheck disable=SC2181
if [ $? -ne 0 ]; then
    printf "Restoration unsuccessful, copy backup files manually.\n"
else
    printf "Restoration successful, backup directory may be deleted.\n"
fi

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
