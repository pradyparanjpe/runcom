#!/usr/bin/env fish
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

set -xU BLACK "\033[0;30m";
set -xU BLACK_BOLD "\033[1;30m";
set -xU RED "\033[0;31m";
set -xU RED_BOLD "\033[1;31m";
set -xU GREEN "\033[0;32m";
set -xU GREEN_BOLD "\033[1;32m";
set -xU YELLOW "\033[0;33m";
set -xU YELLOW_BOLD "\033[1;33m";
set -xU BLUE "\033[0;34m";
set -xU BLUE_BOLD "\033[1;34m";
set -xU MAGENTA "\033[0;35m";
set -xU MAGENTA_BOLD "\033[1;35m";
set -xU CYAN "\033[0;36m";
set -xU CYAN_BOLD "\033[1;36m";
set -xU WHITE "\033[0;37m";
set -xU WHITE_BOLD "\033[1;37m";
set -xU BG_BLACK "\033[0;40m";
set -xU BG_BLACK_BOLD "\033[1;40m";
set -xU BG_RED "\033[0;41m";
set -xU BG_RED_BOLD "\033[1;41m";
set -xU BG_GREEN "\033[0;42m";
set -xU BG_GREEN_BOLD "\033[1;42m";
set -xU BG_YELLOW "\033[0;43m";
set -xU BG_YELLOW_BOLD "\033[1;43m";
set -xU BG_BLUE "\033[0;44m";
set -xU BG_BLUE_BOLD "\033[1;44m";
set -xU BG_MAGENTA "\033[0;45m";
set -xU BG_MAGENTA_BOLD "\033[1;45m";
set -xU BG_CYAN "\033[0;46m";
set -xU BG_CYAN_BOLD "\033[1;46m";
set -xU BG_WHITE "\033[0;47m";
set -xU BG_WHITE_BOLD "\033[1;47m";
set -xU NO_EFFECTS "\033[m";

if [ "$TERM" = "linux" ]
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
end

set -xU RUNCOMDIR "$HOME/.runcom"
set PATH "$PATH" "$HOME/bin";
set -xU PATH "$PATH" "$HOME/.local/bin";
set fish_greeting

function python_ver
    python --version |cut -d "." -f1,2 |sed 's/ //' |sed 's/P/p/'
end
set -xU PYTHONPATH "$PYTHONPATH $HOME/lib/(python_ver)/site-packages" "$HOME/lib64/(python_ver)/site-packages";

set -xU LD_LIBRARY_PATH "$HOME/.local/lib" "$HOME/.local/lib64";

set -xU PYOPENCL_CTX '0';
set -xU PYOPENCL_COMPILER_OUTPUT 1;
set -xU OCL_ICD_VENDORS "/etc/OpenCL/vendors/";

set -g spark_version 1.0.0

complete -xc spark -n __fish_use_subcommand -a --help -d "Show usage help"
complete -xc spark -n __fish_use_subcommand -a --version -d "$spark_version"
complete -xc spark -n __fish_use_subcommand -a --min -d "Minimum range value"
complete -xc spark -n __fish_use_subcommand -a --max -d "Maximum range value"

function spark -d "sparkline generator"
    if isatty
        switch "$argv"
            case {,-}-v{ersion,}
                echo "spark version $spark_version"
            case {,-}-h{elp,}
                echo "usage: spark [--min=<n> --max=<n>] <numbers...>  Draw sparklines"
                echo "examples:"
                echo "       spark 1 2 3 4"
                echo "       seq 100 | sort -R | spark"
                echo "       awk \\\$0=length spark.fish | spark"
            case \*
                echo $argv | spark $argv
        end
        return
    end

    command awk -v FS="[[:space:],]*" -v argv="$argv" '
        BEGIN {
            min = match(argv, /--min=[0-9]+/) ? substr(argv, RSTART + 6, RLENGTH - 6) + 0 : ""
            max = match(argv, /--max=[0-9]+/) ? substr(argv, RSTART + 6, RLENGTH - 6) + 0 : ""
        }
        {
            for (i = j = 1; i <= NF; i++) {
                if ($i ~ /^--/) continue
                if ($i !~ /^-?[0-9]/) data[count + j++] = ""
                else {
                    v = data[count + j++] = int($i)
                    if (max == "" && min == "") max = min = v
                    if (max < v) max = v
                    if (min > v ) min = v
                }
            }
            count += j - 1
        }
        END {
            n = split(min == max && max ? "▅ ▅" : "▁ ▂ ▃ ▄ ▅ ▆ ▇ █", blocks, " ")
            scale = (scale = int(256 * (max - min) / (n - 1))) ? scale : 1
            for (i = 1; i <= count; i++)
                out = out (data[i] == "" ? " " : blocks[idx = int(256 * (data[i] - min) / scale) + 1])
            print out
        }
    '
end

set PS1 ""
 set PS1 "$PS1\n"
 set PS1 "$PS1\[$GREEN\]\u\[$NO_EFFECTS\]"
 set PS1 "$PS1@"
 set PS1 "$PS1\[$BLUE\]\h\[$NO_EFFECTS\]"
 # set PS1 "$PS1\(git_ps)"
 set PS1 "$PS1\[$WHITE\]<"
 set PS1 "$PS1\[$CYAN\]\W"
 set PS1 "$PS1\[$WHITE\]>"
 set PS1 "$PS1\[$YELLOW\]\t\[$NO_EFFECTS\]"
 set PS1 "$PS1\n» "
set -xU PS1 $PS1

set PS2 ""
 set PS2 "$PS2\[$CYAN\]cont..."
 set PS2 "$PS2\[$NO_EFFECTS\]"
 set PS2 "$PS2» ";
set -xU PS2 $PS2

set PS3 "Selection" " ";
set -xU PS3 $PS3

function tcpz
    tar -c --use-compress-program pigz $argv
end
function txpz
    tar -x --use-compress-program pigz $argv
end

function du
    du -hc $argv
end
function df
    df -h $argv
end
function duall
    du -hc |grep '^[3-9]\{3\}M\|^[0-9]\{0,3\}\.\{0,1\}[0-9]\{0,1\}G' $argv
end

function nload
    /usr/bin/nload -u M -U G -t 10000 -a 3600 "(ip a | grep -m 1 " UP " | cut -d " " -f 2 | cut -d "" "" -f 1)"
end
function nethogs
    /usr/bin/su - -c "nethogs (ip a |grep  'state UP' | cut -d ' ' -f 2 | cut -d '" "' -f 1) -d 10" $argv
end
function ping
    ping -c 4 $argv
end

function to_venv
    source .venv/bin/activate $argv
end
function activateGRN
    deactivate || true; source $HOME/.virtualenvs/Leish_Petri/bin/activate $argv
end
function activateRNA
    deactivate || true; source $HOME/.virtualenvs/RNASeq3/bin/activate $argv
end

function watch
    watch -n 10 --color=auto $argv
end
function psauxgrep
    ps aux |head -1 && ps aux | grep -v 'grep' | grep -v 'rg'| grep -i $argv
end

function qqqq
    exit $argv
end

for sc in "rg" "ag" "pt" "ack" "grep"
    if command -v "$sc" >>/dev/null
        function grep
            $sc --color=auto $argv
        end;
        break
    end
end

if command -v "exa" >>/dev/null
    function ls
        exa -Fh --color=auto $argv
    end
    function la
        exa -a --color=auto $argv
    end
    function ll
        exa -lr -s size $argv
    end
    function lla
        exa -a $argv
    end
    function l.
        exa -a --color=auto |grep "^\." $argv
    end
    function sl
        /usr/bin/sl -al $argv
    end
end

if command -v nvim >>/dev/null
     function ex
         nvim $argv
     end ## always open vim in normal mode
     function vim
         nvim $argv
     end ## always use neo
end

if command -v podman >>/dev/null
     function docker
         podman $argv
     end  # Podman is drop-in replacement for docker
     function docker-compose
         podman-compose $argv
     end  # Podman is drop-in replacement for docker
end
function pip
    python -m pip $argv
end # Invoke pip with python

function mathcalc
    echo "scale 4; $argv"| bc
end

function dec2hex
    echo "hex:"
    echo "obase 16; $argv"| bc
    echo "dec:"
    set echo "ibase 16; $argv"| bc
end

function deactivate
    true
end

function gui
    if [ -n "$argv" ]
        if command -v "$1" >> /dev/null
            exec nohup "$argv" &>/dev/null 0<&- &
            exit 0
        end
    end
end

function deconvolute
    if [ ! -f "$1" ]
        echo "$1" " no such file";
    else
        switch "$1"
            case *.tar.bz2
                tar -xjf "$1"
            case *.tbz2
                tar -xjf "$1"
            case *.tar.gz
                tar -x --use-compress-program pigz -f "$1"
            case *.tgz
                tar -x --use-compress-program pigz -f "$1"
            case *.gz
                pigz "$1"
            case *.rar
                unrar -x "$1"
            case *.tar
                tar -xf "$1"
            case *.zip
                unzip "$1"
            case *.tar.xz
                tar -xf "$1"
            case *
                echo "Cannot extract $1, provide explicit command"
        end
    end
end

if [ ! -S ~/.ssh/ssh_auth_sock ]
    eval `ssh-agent`
    ln -sf "$SSH_AUTH_SOCK" ~/.ssh/ssh_auth_sock
end
set -xU SSH_AUTH_SOCK ~/.ssh/ssh_auth_sock
ssh-add -l > /dev/null || ssh-add

set -xU NO_AT_BRIDGE 1

for term in foot termite tilix xterm gnome-terminal
    if [ -n "(command -v $term)" ]
        set -xU defterm "$term";
        break;
    end
end

if [ "(tty)" = "/dev/tty1" ]
    # set -xU DISPLAY "" "0.0"
    # set -xU WAYLAND_DISPLAY wayland-0
    set -xU XDG_SESSION_TYPE wayland
    set -xU SDL_VIDEODRIVER wayland
    set -xU QT_QPA_PLATFORM wayland-egl
    set -xU ELM_DISPLAY wl
    set -xU ECORE_EVAS_ENGINE wayland_egl
    set -xU ELM_ENGINE wayland_egl
    set -xU ELM_ACCEL opengl
    set -xU GDK_BACKEND wayland
    unset GDK_BACKEND
    # export DBUS_SESSION_BUS_ADDRESS
    # export DBUS_SESSION_BUS_PID
    set -xU MOZ_ENABLE_WAYLAND 1
    # unset WAYLAND_DISPLAY
    exec sway
end
