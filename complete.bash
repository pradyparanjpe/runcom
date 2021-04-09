#!/usr/bin/env bash
# -*- coding: utf-8; mode: shell-script; -*-


[ "${0}" != 'zsh' ] && [ "${0}" != "bash" ] && return
# Affirm argparse installation
if ! command -v register-python-argcomplete &>/dev/null; then
    pip install -U argcomplete
    activate-global-python-argcomplete --user
fi

pycomplete=( "pspbar" "ppsid" "ppsi" "pspman" "frac-time" );
for pyscript in ${pycomplete[*]}; do
    eval "$( register-python-argcomplete "$pyscript" )"
done

function _complete_gui() {
    COMPREPLY=()
    if [[ "${3}" == "gui" ]]; then
        mapfile -t COMPREPLY < <(compgen -c "${2}")
    else
        _command "${COMP_WORDS[1]}" "${2}" "${3}"
    fi
}
complete -F _complete_gui gui
