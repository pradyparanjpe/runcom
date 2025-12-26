#!/usr/bin/env sh
nil

RUNCOMDIR="${RUNCOMDIR:-${HOME}/.runcom}"

unstow_undeploy() {
    if ! stow -v -t "${HOME}" -d "${RUNCOMDIR}" -D dotfiles; then
        # stow threw error
        stow_error="$?"
        printf "Fix above errors and try again."
        exit "${stow_error}"
    fi
}

restore_configurations() {

if [ ! -d "${1:-${XDG_CACHE_HOME:-${HOME}/.cache}/OLD_CONFIG}" ]; then
    printf "Old Configuration not found. Please supply as a positional argument.\n"
    printf "Such as %s <path/to/old/config/directory>\n" "$0"
    exit 1
fi

for conf_dir in "${1:-${XDG_CACHE_HOME:-${HOME}/.cache}/OLD_CONFIG}"/*; do
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

rm -rf "${RUNCOMDIR}" && printf "Goodbye 👋\n"

}

 main () {
     unstow_undeploy
     restore_configurations "$@"
     delete_repo

move_roots .cargo CARGO_HOME
move_roots go GOPATH

}

 main "$@"
