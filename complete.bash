#!/usr/bin/env bash
# -*- coding: utf-8; mode: shell-script; -*-


[ -z "${ZSH_VERSION}" ] && [ -z "${BASH_VERSION}" ] && return
# Affirm argparse installation
if ! command -v register-python-argcomplete &>/dev/null; then
    pip install -U argcomplete
    activate-global-python-argcomplete --user
fi

# zsh-specific initiation
if [ -n "${ZSH_VERSION}" ]; then
    autoload -U bashcompinit
    bashcompinit
    setopt sh_word_split
fi

for pyscript in ${PY_ARG_COMPL_SCRIPTS}; do
    eval "$(register-python-argcomplete "$pyscript")"
done

[ -n "${ZSH_VERSION}" ] && unsetopt sh_word_split

_complete_gui() {
    COMPREPLY=()
    if [[ "${3}" == "gui" ]]; then
        mapfile -t COMPREPLY < <(compgen -c "${2}")
    else
        _command "${COMP_WORDS[1]}" "${2}" "${3}"
    fi
}
complete -F _complete_gui gui
