#!/usr/bin/env sh
# -*- coding: utf-8; mode: shell-script; -*-
#
# Copyright © 2020-2024 Pradyumna Paranjape
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
#===================================================================
#  ___             _      ___                     _
# | _ \_ _ __ _ __| |_  _| _ \__ _ _ _ __ _ _ _  (_)_ __  ___
# |  _/ '_/ _` / _` | || |  _/ _` | '_/ _` | ' \ | | '_ \/ -_)
# |_| |_| \__,_\__,_|\_, |_| \__,_|_| \__,_|_||_|/ | .__/\___|
#                    |__/                      |__/|_|
#===================================================================

#!/usr/bin/env sh
# -*- coding: utf-8; mode: shell-script; -*-
dnf_install() {

dnf -y update || return 65
dnf -y install coreutils curl git stow || return 66

}

 apk_install() {

apk update || return 65
apk --virtual runcom add coreutils curl git stow || return 66

}

 apt_install() {

apt update || return 65
apt install -y coreutils curl git stow || return 66

}

 zypper_install() {

zypper ref || return 65
zypper -n install coreutils curl git stow || return 66

}

 pacman_install() {

pacman --noconfirm -Syu coreutils curl git stow || return 65

}

 brew_install() {

brew update || return 65
brew install coreutils curl git stow || return 66

}
 guess_manager() {
     for manager in apt apk dnf pacman zypper brew; do
         if command -v "${manager}" 1>/dev/null 2>&1; then
             printf "%s" "${manager}"
             return 0
         fi
     done
     printf ""
     return 127
 }

 install_dep () {
     if [ -z "$1" ]; then
         manager="$(guess_manager)"
         if [ -z "${manager}" ]; then
             return 127
         fi
     else
         manager="${1}"
     fi
     eval "${manager}_install"
 }

 main() {
     install_dep "$@"
     case $? in
         0)
             printf "Dependencies installation complete\n"
             printf "Proceed to setup\n"
             ;;
         65)
             printf "Manager is available, but update threw error\n"
             printf "Please install dependencies manually\n"
             printf "aborting...\n"
             return 1;
             ;;
         66)
             printf "Manager is available, but package installation threw error\n"
             printf "Please install dependencies manually\n"
             printf "aborting...\n"
             return 1;
             ;;
         127)
             printf "Couldn't guess package manger\n"
             printf "Please install dependencies manually\n"
             printf "aborting...\n"
             return 127;
             ;;
         *) printf "Error number %s was thrown by the package manager\n" "$?"
            printf "Please install dependencies manually\n"
            printf "aborting...\n"
            ;;
     esac
 }

 main "$@"
