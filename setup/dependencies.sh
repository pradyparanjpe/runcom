#!/usr/bin/env sh
# -*- coding: utf-8; mode: shell-script; -*-
dnf_install() {

dnf update || return 65
dnf -y install curl git stow || return 66

}

 apk_install() {

apk update || return 65
apk --virtual runcom add curl git stow || return 66

}

 apt_install() {

apt update || return 65
apt install curl git stow || return 66

}

 zypper_install() {

zypper ref || return 65
zypper install curl git stow || return 66

}

 pacman_install() {

pacman -Syu curl git stow || return 65

}
 guess_manager() {
     for manager in dnf apt apk zypper pacman; do
         if builtin command -v "${manager}" 1>/dev/null 2>&1; then
             printf "${manager}"
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
     return eval "${manager}_install"
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
             printf "aborting..."
             return 1;
             ;;
         66)
             printf "Manager is available, but package installation threw error\n"
             printf "Please install dependencies manually\n"
             printf "aborting..."
             return 1;
             ;;
         127)
             printf "Couldn't guess package manger\n"
             printf "Please install dependencies manually\n"
             printf "aborting..."
             return 127;
             ;;
         *) printf "Error number %s was thrown by the package manager\n" "$?"
            printf "Please install dependencies manually\n"
            printf "aborting..."
            ;;
     esac
 }

 main "$@"
