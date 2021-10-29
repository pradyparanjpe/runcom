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
    stow_deploy
}
main "$@"
