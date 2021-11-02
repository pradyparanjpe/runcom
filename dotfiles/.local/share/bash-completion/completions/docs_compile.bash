#!/usr/bin/env bash
# -*- coding: utf-8; mode: shell-script; -*-

_complete_pdfcompile() {
    COMPREPLY=("$(compgen -o filenames -G "*.tex" -- "${3}")")
}

complete -F _complete_pdfcompile pdfcompile

_complete_org2export() {
    COMPREPLY=()
    if [ "${COMP_WORDS[*]}" =~ '-h' ] \
           || [ "${COMP_WORDS[*]}" =~ '--help' ]; then
        return
    fi
    if [ "${COMP_WORDS[*]}" =~ '-f' ] \
           ||[ "$COMP_WORDS[*]" =~ '--force' ]; then
        # force non-org extension
        COMPREPLY+=("$(compgen -- "$3")")
    else
        COMPREPLY+=('-f' '--force' '-h' '--help')
        COMPREPLY+=("$(compgen -o dirnames -G "*.org" -- "$3")")
    fi
}


complete -F _complete_org2export org2export
