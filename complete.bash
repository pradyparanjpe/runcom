#!/usr/bin/env bash
# -*- coding: utf-8; mode: shell-script; -*-

if ! command -v register-python-argcomplete 2>&1 > /dev/null; then
    python -m pip install -U argcomplete
fi

_gui_complete() {
    COMPREPLY=()
    if [[ $3 == "gui" ]]; then
        COMPREPLY=( $( compgen -c "$2") )
    else
        _command ${COMP_WORDS[1]} $2 $3
    fi
}

complete -F _gui_complete gui


PY_ARG_COMPL_SCRIPTS=( "frac-time" "ppsid" "ppsi pspbar")

for py_arg_parse in ${PY_ARG_COMPL_SCRIPTS[*]}; do
    eval "$(register-python-argcomplete $py_arg_parse)"
done
