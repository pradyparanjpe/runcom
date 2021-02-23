#!/usr/bin/env bash
# -*- coding: utf-8; mode: shell-script; -*-

# Affirm argparse installation
if ! command -v register-python-argcomplete 2>&1 >> /dev/null; then
    python3 -m pip install -U argcomplete
    activate-global-python-argcomplete --user
fi


pycomplete=( "pspbar" "ppsid" "ppsi" "pspman" "frac-time" );

for pyscript in ${pycomplete[*]}; do
    eval "$( register-python-argcomplete $pyscript )"
done


function _complete_gui() {
    COMPREPLY=()
    if [[ $3 == "gui" ]]; then
        COMPREPLY=( $( compgen -c "$2") )
    else
        _command ${COMP_WORDS[1]} $2 $3
    fi
}

complete -F _complete_gui gui
