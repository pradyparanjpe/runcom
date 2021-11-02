#!/usr/bin/env bash
# -*- coding: utf-8; mode: shell-script; -*-

_complete_gui() {
    COMPREPLY=()
    if [ "${3}" = "gui" ]; then
        # no arguments have been passed
        COMPREPLY=("-h" "--help" '--')
    elif [ "$3" = '--' ]; then
        COMPREPLY+=("$(compgen -c | grep -v "^_")")
    fi
}

complete -F _complete_gui gui
