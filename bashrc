#!/usr/bin/env bash
# -*- coding:utf-8; mode:shell-script; -*-

#
# Copyright 2020 Pradyumna Paranjape
#
# This file is part of Prady_runcom.
#
# Prady_runcom is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Prady_runcom is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Prady_runcom.  If not, see <https://www.gnu.org/licenses/>.
#

export BLACK="\033[0;30m";
export BLACK_BOLD="\033[1;30m";
export RED="\033[0;31m";
export RED_BOLD="\033[1;31m";
export GREEN="\033[0;32m";
export GREEN_BOLD="\033[1;32m";
export YELLOW="\033[0;33m";
export YELLOW_BOLD="\033[1;33m";
export BLUE="\033[0;34m";
export BLUE_BOLD="\033[1;34m";
export MAGENTA="\033[0;35m";
export MAGENTA_BOLD="\033[1;35m";
export CYAN="\033[0;36m";
export CYAN_BOLD="\033[1;36m";
export WHITE="\033[0;37m";
export WHITE_BOLD="\033[1;37m";
export BG_BLACK="\033[0;40m";
export BG_BLACK_BOLD="\033[1;40m";
export BG_RED="\033[0;41m";
export BG_RED_BOLD="\033[1;41m";
export BG_GREEN="\033[0;42m";
export BG_GREEN_BOLD="\033[1;42m";
export BG_YELLOW="\033[0;43m";
export BG_YELLOW_BOLD="\033[1;43m";
export BG_BLUE="\033[0;44m";
export BG_BLUE_BOLD="\033[1;44m";
export BG_MAGENTA="\033[0;45m";
export BG_MAGENTA_BOLD="\033[1;45m";
export BG_CYAN="\033[0;46m";
export BG_CYAN_BOLD="\033[1;46m";
export BG_WHITE="\033[0;47m";
export BG_WHITE_BOLD="\033[1;47m";
export NO_EFFECTS="\033[m";

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

export RUNCOMDIR="${HOME}/.runcom"
PATH="${PATH}:${HOME}/bin";
export PATH="${PATH}:${HOME}/.local/bin";

function python_ver() {
    python --version |cut -d "." -f1,2 |sed 's/ //' |sed 's/P/p/'
}
export PYTHONPATH="${PYTHONPATH}:${HOME}/lib/$(python_ver)/site-packages:${HOME}/lib64/$(python_ver)/site-packages";

export LD_LIBRARY_PATH="${HOME}/.local/lib:${HOME}/.local/lib64";

export PYOPENCL_CTX='0';
export PYOPENCL_COMPILER_OUTPUT=1;
export OCL_ICD_VENDORS="/etc/OpenCL/vendors/";

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

    if [ $modified -ne 0 ]; then
        echo -ne "${RED}M"
    fi

    if [ $cached -ne 0 ]; then
        echo -ne "${GREEN}C"
    fi

    if [ $untracked -ne 0 ]; then
        echo -ne "${RED}?"
    fi

    if [ -n "$(git stash list)" ]; then
        echo -ne "${CYAN}S"
    fi
    echo -e "${NO_EFFECTS}"
}

function git_branch() {
    local branch
    branch="$(git branch 2>/dev/null | grep '^\*' | sed -e "s/^* //")"
    if [[ "${branch}" =~ ^bug- ]]; then
        echo -ne "${GREEN}"
    elif [[ "${branch}" =~ ^atc- ]]; then
        echo -ne "${CYAN}"
    elif [[ "${branch}" =~ ^tmp ]]; then
        echo -ne "${MAGRNTA}"
    elif [[ "${branch}" = "(detached from hde/master)" ]]; then
        echo -ne "${YELLOW}"
    elif [[ "${branch}" == "master" ]]; then
        return
    else
        echo -ne "${MAGENTA}"
    fi
    echo -n "${branch}"
    echo -e "${NO_EFFECTS}"
}

function git_hash() {
    git log --pretty=format:'%h' -n 1
}

function git_ps() {
    if ! git status --ignore-submodules &>/dev/null; then
        return
    else
        echo " $(git_branch)·$(git_hash)·$(git_status) "
    fi
}

PS1=""
PS1="${PS1}\n"
PS1="${PS1}\[${GREEN}\]\u\[${NO_EFFECTS}\]"
PS1="${PS1}@"
PS1="${PS1}\[${BLUE}\]\h\[${NO_EFFECTS}\]"
PS1="${PS1}\$(git_ps)"
PS1="${PS1}\[${WHITE}\]<"
PS1="${PS1}\[${CYAN}\]\W"
PS1="${PS1}\[${WHITE}\]>"
PS1="${PS1}\[${YELLOW}\]\t\[${NO_EFFECTS}\]"
PS1="${PS1}\n» "
export PS1

PS2=""
PS2="${PS2}\[${CYAN}\]cont..."
PS2="${PS2}\[${NO_EFFECTS}\]"
PS2="${PS2}» ";
export PS2

PS3="Selection: ";
export PS3

alias tcpz="tar -c --use-compress-program=pigz ";
alias txpz="tar -x --use-compress-program=pigz ";

alias du='du -hc';
alias df='df -h';
alias duall="du -hc |grep '^[3-9]\{3\}M\|^[0-9]\{0,3\}\.\{0,1\}[0-9]\{0,1\}G'";

alias nload="nload -u M -U G -t 10000 -a 3600 "$(ip a | grep -m 1 " UP " | cut -d " " -f 2 | cut -d ":" -f 1)""
alias nethogs="\su - -c \"nethogs $(ip a |grep  'state UP' | cut -d ' ' -f 2 | cut -d ':' -f 1) -d 10\"";
alias ping="ping -c 4 ";

alias to_venv="source .venv/bin/activate";
alias activateGRN="deactivate || true; source ${HOME}/.virtualenvs/Leish_Petri/bin/activate";
alias activateRNA="deactivate || true; source ${HOME}/.virtualenvs/RNASeq3/bin/activate";

alias watch="watch -n 10 --color";
alias psauxgrep="ps aux |head -1 && ps aux | grep -v 'grep' | grep -v 'rg'| grep -i";

alias qqqq="exit";

for sc in "rg" "ag" "pt" "ack" "grep"; do
    if command -v "$sc" >>/dev/null; then
        alias grep="$sc --color=auto";
        break
    fi
done

if command -v "exa" >>/dev/null; then
    alias ls="exa -Fh --color=auto";
    alias la='exa -a --color=auto';
    alias ll='exa -lr -s size';
    alias lla='exa -a';
    alias l.='exa -a --color=auto |grep "^\."';
    alias sl="sl -al";
fi

if command -v nvim >>/dev/null; then
    alias ex="nvim"; ## always open vim in normal mode
    alias vim="nvim"; ## always use neo
fi

if command -v podman >>/dev/null; then
    alias docker="podman";  # Podman is drop-in replacement for docker
    alias docker-compose="podman-compose";  # Podman is drop-in replacement for docker
fi
alias pip="python -m pip"; # Invoke pip with python

function mathcalc() {
    echo "scale=4; $@"| bc
}

function dec2hex() {
    echo "hex:"
    echo "obase=16; $@"| bc
    echo "dec:"
    echo "ibase=16; $@"| bc
}

function deactivate() {
    true
}

function pdfcompile() {
    pdflatex $1
    for ext in toc log aux; do
        delfile=${1/\.tex/\.$ext}
        [[ -f "$delfile" ]] && rm "$delfile"
    done
    evince ${1/\.tex/\.pdf}
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

function gui () {
    if [[ -n "$@" ]]; then
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

netcodes=( $(${RUNCOMDIR}/netcheck.sh) )
export IP_ADDR="${netcodes[0]}"
export AP_ADDR="${netcodes[1]}"
if [[ "${netcodes[2]}" -gt 7 ]]; then
    echo -e "${BLUE_BOLD}Internet (GOOGLE) Connected${NO_EFFECTS}"
    echo -e "${GREEN}$IP_ADDR ${NO_EFFECTS} is current wireless ip address"
else
    echo -e "${RED_BOLD}Internet (GOOGLE) Not reachable${NO_EFFECTS}"
    if [[ $(( netcodes[2] % 8 )) -gt 3 ]]; then  # Intranet is connected
        echo -e "${RED}Internet Down${NO_EFFECTS}"
        case $(( netcodes[2] % 4 )) in
            2) echo -e "Home network connected,"
               ;;
            1) echo -e "CCMB network connected,"
               if [[ -f "${RUNCOMDIR}/proxy_send.py" ]]; then
                   ${RUNCOMDIR}/proxy_send.py \
                       && echo -e "${YELLOW}PROXY AUTH SENT${NO_EFFECTS}";
               fi
               ;;
            *) echo -e "HOTSPOT connected"
               ;;
        esac
    else
        echo -e "${YELLOW_BOLD}Network connection Disconnected${NO_EFFECTS}"
    fi
fi

if [[ ! -S ~/.ssh/ssh_auth_sock ]]; then
    eval `ssh-agent`
    ln -sf "$SSH_AUTH_SOCK" ~/.ssh/ssh_auth_sock
fi
export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock
ssh-add -l > /dev/null || ssh-add

if [[ $(( netcodes[2] % 4 )) -eq 2 ]]; then
    clouddir=( "/media/data" "/home/pradyumna" )
    srv_mnt_dir="${HOME}/www.anubandha.d"
    if [[ $(mount | grep -c "${srv_mnt_dir}") \
              -lt "${#clouddir[@]}" ]]; then
        # not mounted
        for pathloc in ${clouddir[@]}; do
            mntpath="${srv_mnt_dir}${pathloc}"
            mkdir -p "$mntpath"
            sshfs -o "reconnect,ServerAliveInterval=15,ServerAliveCountMax=3" "pradyumna@www.anubandha.home:${pathloc}" "$mntpath"
        done
    fi
fi

export NO_AT_BRIDGE=1

for term in foot termite tilix xterm gnome-terminal; do
    if [[ -n "$(command -v $term)" ]]; then
        export defterm="$term";
        break;
    fi;
done

if [ "$(tty)" = "/dev/tty1" ]; then
    # export DISPLAY=":0.0"
    # export WAYLAND_DISPLAY=wayland-0
    export XDG_SESSION_TYPE=wayland
    export SDL_VIDEODRIVER=wayland
    export QT_QPA_PLATFORM=wayland-egl
    export ELM_DISPLAY=wl
    export ECORE_EVAS_ENGINE=wayland_egl
    export ELM_ENGINE=wayland_egl
    export ELM_ACCEL=opengl
    export GDK_BACKEND=wayland
    unset GDK_BACKEND
    export DBUS_SESSION_BUS_ADDRESS
    export DBUS_SESSION_BUS_PID
    export MOZ_ENABLE_WAYLAND=1
    # unset WAYLAND_DISPLAY
    exec sway
fi
