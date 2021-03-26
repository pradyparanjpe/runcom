#!/usr/bin/env bash
# -*- coding:utf-8; mode:shell-script; -*-

if [[ "$TERM" = "linux" ]]; then
    echo -en "\e]P0000000" #black
    echo -en "\e]P83f3f3f" #darkgrey
    echo -en "\e]P19f3f3f" #darkred
    echo -en "\e]P9ff9f9f" #red
    echo -en "\e]P23f9f3f" #darkgreen
    echo -en "\e]PAbfefbf" #green
    echo -en "\e]P3bf9f3f" #brown
    echo -en "\e]PB9fff9f" #yellow
    echo -en "\e]P45f5f9f" #darkblue
    echo -en "\e]PC9f9fff" #blue
    echo -en "\e]P59f3f9f" #darkmagenta
    echo -en "\e]PDff9fff" #magenta
    echo -en "\e]P63f9f9f" #darkcyan
    echo -en "\e]PE9fffff" #cyan
    echo -en "\e]P7afafaf" #lightgrey
    echo -en "\e]PFffffff" #white
    clear #for background artifacting
fi

shopt -s autocd # Allows to cd by only typing name
set -o vi
bind '"jk":vi-movement-mode'

function python_ver() {
    python --version |cut -d "." -f1,2 |sed 's/ //' |sed 's/P/p/'
}

function deactivate() {
    true
}

alias to_venv="source .venv/bin/activate";

export BEMENU_OPTS='--fn firacode 14 '

function git_status() {
    local modified=0
    local cached=0
    local untracked=0

    while read -r line; do
        if [ "$line" = '_?_?_' ]; then
            untracked=1
            continue
        fi

        if [[ "$line" =~ ^_[^[:space:]]_.?_ ]]; then
            cached=1
        fi

        if [[ "$line" =~ ^_._[^[:space:]]_ ]]; then
            modified=1
        fi
    done < <(git status --short | cut -b -2 | sed -e 's/\(.\)\(.*\)/_\1_\2_/')

    stat_str=''
    if [ $modified -ne 0 ]; then
        stat_str="${stat_str}\033[0;31m\ue728"
    fi

    if [ $cached -ne 0 ]; then
        stat_str="${stat_str}\033[0;32m\ue729"
    fi

    if [ $untracked -ne 0 ]; then
        stat_str="${stat_str}\033[0;31m\uf476"
    fi

    if [ -n "$(git stash list)" ]; then
        stat_str="${stat_str}\e[0;36m\uf48e"
    fi
    if [[ -n "${stat_str}" ]]; then
        echo -en "${stat_str}\e[m"
    fi
}

function git_branch() {
    local branch
    branch="$(git branch 2>/dev/null | grep '^\*' | sed -e "s/^* //")"
    if [[ -n "$branch" ]]; then
        if [[ "${branch}" =~ ^feat- ]]; then
            echo -ne "\033[0;32m"
        elif [[ "${branch}" =~ ^bug- ]]; then
            echo -ne "\033[0;31m"
        elif [[ "${branch}" =~ ^atc- ]]; then
            echo -ne "\e[0;36m"
        elif [[ "${branch}" =~ ^tmp ]]; then
            echo -ne "\e[0;35m"
        elif [[ "${branch}" = "(detached from hde/master)" ]]; then
            echo -ne "\e[0;33m"
        elif [[ "${branch}" == "master" ]]; then
            return
        else
            echo -ne "\e[0;35m"
        fi
        echo -ne "${branch}\ue725"
        echo -ne "\e[m"
    fi
}

function git_hash() {
    git log --pretty=format:'%h' -n 1
}

function git_ps() {
    if ! git status --ignore-submodules &>/dev/null; then
        return
    else
        echo -ne " $(git_branch)$(git_hash)$(git_status) "
    fi
}

last_exit_color () {
    err="$1"
    if test "$err" == "0"; then
        # no error
        printf "\e[0;32m"
    elif test "$err" == "1"; then
        # general error
        printf "\e[0;33m"
    elif test "$err" == "2"; then
        # misuse of shell builtins
        printf "\e[0;31m"
    elif [ "$err" -gt 63 ]  && [ "$err" -lt 84 ]; then
        # syserror.h
        printf "\e[0;91m"
    elif test "$err" == "126"; then
        # cannot execute
        printf "\e[0;37m"
    elif test "$err" == "127"; then
        # command not found
        printf "\e[0;30m"
    elif [ "$err" -gt 127 ] && [ "$err" -lt 191 ]; then
        # Fatal error
        printf "\e[0;41m"
    elif test "$err" == "255"; then
        # exit status limit
        printf "\e[0;31m"
    else
        printf "\e[0;31m"
    fi
}
export PROMPT_COMMAND=__prompt_command
__prompt_command () {
    exit_stat="$?"
    PS1=""
    PS1="${PS1}\[\$(last_exit_color ${exit_stat})\]┏━ \[\e[m\]"
    PS1="${PS1}\[\e[0;32m\]\u\[\e[m\]"
    PS1="${PS1}@"
    PS1="${PS1}\[\e[0;34m\]\h\[\e[m\]"
    PS1="${PS1}\$(git_ps)"
    PS1="${PS1}\[\e[0;37m\]<"
    PS1="${PS1}\[\e[0;36m\]\W"
    PS1="${PS1}\[\e[0;37m\]>"
    PS1="${PS1}\[\e[0;33m\]\t\[\e[m\]"
    PS1="${PS1}\n\[\$(last_exit_color ${exit_stat})\]┗━ \[\e[m\]"
}

PS2=""
PS2="${PS2}\[\e[0;36m\]cont..."
PS2="${PS2}\[\e[m\]"
PS2="${PS2}» ";
export PS2

PS3="Selection: ";
export PS3

export RUNCOMDIR="${HOME}/.runcom"
export PY_ARG_COMPL_SCRIPTS=( "frac-time" "ppsid" "ppsi pspbar")
# shellcheck source=.local/share/pspman/src/runcom/complete.bash
if [[ -f "${RUNCOMDIR}"/complete.bash ]]; then
    # shellcheck source=.local/share/pspman/src/runcom/complete.bash
    source "${RUNCOMDIR}"/complete.bash
fi

alias tcpz="tar -c --use-compress-program=pigz ";
alias txpz="tar -x --use-compress-program=pigz ";

alias du='du -hc';
alias df='df -h';
alias duall="du -hc |\grep '^[3-9]\{3\}M\|^[0-9]\{0,3\}\.\{0,1\}[0-9]\{0,1\}G'";

alias nload='nload -u M -U G -t 10000 -a 3600 $(ip a | grep -m 1 " UP " | cut -d " " -f 2 | cut -d ":" -f 1)'
alias nethogs='\su - -c "nethogs $(ip a |grep  "state UP" | cut -d " " -f 2 | cut -d ":" -f 1) -d 10"';
alias ping="ping -c 4 ";

alias watch="watch -n 10 --color";
alias psauxgrep="ps aux |head -1 && ps aux | grep -v 'grep' | grep -v 'rg'| grep -i";

alias qqqq="exit";

for sc in "rg" "ag" "pt" "ack" "grep"; do
    if command -v "${sc%% *}" &>/dev/null; then
        # shellcheck disable=SC2139
        alias grep="${sc} --color=auto";
        break
    fi
done

if command -v "exa" >>/dev/null; then
    alias ls="exa -Fh --color=auto";
    alias la='exa -a --color=auto';
    alias ll='exa -lr -s size';
    alias lla='exa -a';
    alias l.='exa -a --color=auto |grep "^\."';
    alias sl="ls";
fi

if command -v nvim >>/dev/null; then
    alias ex="nvim"; ## always open vim in normal mode
    alias vim="nvim"; ## always use neo
fi

if command -v podman >>/dev/null; then
    alias docker="podman";  # Podman is drop-in replacement for docker
    alias docker-compose="podman-compose";  # Podman is drop-in replacement for docker
fi

function mathcalc() {
    echo "scale=4; $*"| bc
}

function dec2hex() {
    echo "hex:"
    echo "obase=16; $*"| bc
    echo "dec:"
    echo "ibase=16; $*"| bc
}

function pdfcompile() {
    pdflatex "$1"
    for ext in toc log aux; do
        delfile="${1/\.tex/\.$ext}"
        [[ -f "$delfile" ]] && rm "$delfile"
    done
    evince "${1/\.tex/\.pdf}"
}

function org2export() {
    # Usage: org2oth [-f] <infile> <othtype>
    proceed=
    while test $# -gt 1; do
        case "$1" in
            -f|--force)
                proceed=true
                shift 1
                ;;
            *)
                infile="${1}"
                shift 1
                ;;
        esac
    done
    if [[ "${1}" == "pdf" ]]; then
        target="latex"
    else
        target="${1}"
    fi
    tarext="${1}"
    if [[ "$infile" == *.org ]]; then
        proceed=true
    else
        echo "Input file should be an org file"
    fi
    if [[ -n "$proceed" ]]; then
        pandoc -f org -t "${target}" -o "${infile/.org/}.${tarext}" "$infile"
    fi
    proceed=
    target=
    infile=
}

function org2doc () {
    org2export "$@" "docx"
}

function org2pdf () {
    org2export "$@" "pdf"
}

function doc2org() {
    if [[ "$1" == *.docx ]]; then
        pandoc -f docx -t org -o  "${1/%docx/org}" "$1"
    else
        echo "Input file must be a docx file"
    fi
}

function mount_home_cloud() {
    # shellcheck disable=SC2154
    if [[ -z "${home_cloud}" || -z "${cloud_user}" ]]; then
        echo "variables \$home_cloud OR \$cloud_user haven't been defined"
        return
    fi
    # netcheck source=./netcheck.sh
    IFS=$'\t' read -r -a netcodes <<< "$("${RUNCOMDIR}"/netcheck.sh)"
    if [[ $(( netcodes[2] % 4 )) -eq 2 ]]; then
        clouddir=( "/media/data" "/home/${cloud_user}" )
        srv_mnt_dir="${HOME}/${home_cloud}"
        if [[ $(mount | grep -c "${srv_mnt_dir}") \
                  -lt "${#clouddir[@]}" ]]; then
            # not mounted
            for pathloc in "${clouddir[@]}"; do
                mntpath="${srv_mnt_dir}${pathloc}"
                mkdir -p "$mntpath"
                sshfs -o "reconnect,ServerAliveInterval=15,ServerAliveCountMax=3" "${cloud_user}@${home_cloud}:${pathloc}" "$mntpath"
            done
        fi
    fi
}

function gui () {
    if [[ -n "$*" ]]; then
        if command -v "${@%% *}" >> /dev/null; then
            exec nohup "$@" &>/dev/null 0<&- &
            exit 0
        fi
    fi
}

deconvolute() {
    if [[ ! -f "$1" ]]; then
        echo "$1: no such file";
    else
        case "$1" in
            *.tar.bz2) tar -xjf "$1" ;;
            *.tbz2) tar -xjf "$1" ;;
            *.tar.gz) tar -x --use-compress-program=pigz -f "$1" ;;
            *.tgz) tar -x --use-compress-program=pigz -f "$1" ;;
            *.gz) pigz "$1" ;;
            *.rar) unrar -x "$1" ;;
            *.tar) tar -xf "$1" ;;
            *.zip) unzip "$1" ;;
            *.tar.xz) tar -xf "$1" ;;
            *) echo "Cannot extract $1, provide explicit command";;
        esac
    fi
}

# shellcheck source=./netcheck.sh
IFS=$'\t' read -r -a netcodes <<< "$("${RUNCOMDIR}"/netcheck.sh)"
export IP_ADDR="${netcodes[0]}"
export AP_ADDR="${netcodes[1]}"
if [[ "${netcodes[2]}" -gt 7 ]]; then
    echo -e "\e[1;34mInternet (GOOGLE) Connected\e[m"
    echo -e "\033[0;32m$IP_ADDR \e[m is current wireless ip address"
else
    echo -e "\e[1;31mInternet (GOOGLE) Not reachable\e[m"
    if [[ $(( netcodes[2] % 8 )) -gt 3 ]]; then  # Intranet is connected
        echo -e "\033[0;31mInternet Down\e[m"
        case $(( netcodes[2] % 4 )) in
            2) echo -e "Home network connected,"
               ;;
            1) echo -e "CCMB network connected,"
               # shellcheck source=./proxy_send.py
               if [[ -f "${RUNCOMDIR}/proxy_send.py" ]]; then
                   # shellcheck source=./proxy_send.py
                   "${RUNCOMDIR}/proxy_send.py" \
                       && echo -e "\e[0;33mPROXY AUTH SENT\e[m";
               fi
               ;;
            *) echo -e "HOTSPOT connected"
               ;;
        esac
    else
        echo -e "\e[1;33mNetwork connection Disconnected\e[m"
    fi
fi
