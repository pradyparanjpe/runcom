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

_complete_sync_gitlab_issues() {
    if [ "${3}" = '-b' ] || [ "${3}" = '--block' ]; then
        COMPREPLY=('default')
    else
        [ -n "${ZSH_VERSION}" ] && COMPREPLY+=($(compgen -o nospace -f --))
        [ -n "${BASH_VERSION}" ] && mapfile -t COMPREPLY < <(compgen -o nospace -f -- "${3}")
        COMPREPLY+=('-b=default' '-f ' '-h ' '-v ' '-V ' '--block=default'
                    '--pull ' '--help' '--verbose' '--very-verbose')
    fi
    }

complete -o nospace -F _complete_sync_gitlab_issues sync_all_gitlab_issues.sh
