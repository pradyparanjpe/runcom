if [ -f "${HOME}/.profile" ]; then
    # shellcheck disable=SC1091
    . "${HOME}/.profile"
fi

if [ -f "${HOME}/.bashrc" ]; then
    # shellcheck disable=SC1091
    . "${HOME}/.bashrc"
fi

if [ -f "${HOME}/.bash_login" ]; then
    # shellcheck disable=SC1091
    . "${HOME}/.bash_login"
fi
