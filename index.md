- [Prady\_runcom](#sec-)
  - [What's this?](#sec-)
  - [Will you be able to set this up?](#sec-)
- [Copyright/License Header](#sec-)
- [Requirements](#sec-)
  - [Knowledge](#sec-)
  - [Dependencies](#sec-)
- [Legend](#sec-)
  - [Brackets](#sec-)
- [Setup](#sec-)
  - [Bootstrap setup using script](#sec-)
  - [Guide for manual setup.](#sec-)
  - [Personalization](#sec-)
- [Structure](#sec-)
  - [Bash](#sec-)
  - [Zsh](#sec-)
- [Headers](#sec-)
- [Profiles](#sec-)
- [Init](#sec-)
  - [bash](#sec-)
  - [zsh](#sec-)
- [Inherit](#sec-)
  - [bash](#sec-)
  - [zsh](#sec-)
  - [shrc](#sec-)
- [Better alternatives](#sec-)
  - [cat](#sec-)
  - [g/re/p](#sec-)
  - [List Contents](#sec-)
  - [neo visual editor improved](#sec-)
  - [Container](#sec-)
- [Variables](#sec-)
  - [PATH](#sec-)
  - [Editor wars](#sec-)
  - [C(++) exports](#sec-)
  - [GPU exports](#sec-)
  - [Bemenu exports](#sec-)
  - [GTK+ debugging output](#sec-)
- [Functions](#sec-)
  - [Python](#sec-)
  - [Git](#sec-)
  - [Prompt String](#sec-)
  - [Mathematical](#sec-)
  - [Compilation](#sec-)
  - [Mount over ssh](#sec-)
  - [Launch gui](#sec-)
  - [Un-Compress by context](#sec-)
  - [Navigate](#sec-)
  - [zwc](#sec-)
  - [disable autovenv](#sec-)
  - [lszcat](#sec-)
  - [manual pages](#sec-)
- [Aliases](#sec-)
  - [Disk Usage](#sec-)
  - [manual page help](#sec-)
  - [Network](#sec-)
  - [Monitor Job queues](#sec-)
  - [Lazy single-handed exit](#sec-)
  - [[z]wc](#sec-)
- [Networking](#sec-)
  - [State](#sec-)
  - [SSH Agent](#sec-)
- [Window Manager settings](#sec-)
  - [Sway exports](#sec-)
  - [User Interface (GUI/CLI)](#sec-)
- [Calls](#sec-)
  - [bash](#sec-)
  - [zsh](#sec-)


# Prady\_runcom<a id="sec-"></a>

## What's this?<a id="sec-"></a>

-   A compilation of dotfiles: default variables, custom functions.
-   **My** configuration backup, "[push](https://git-scm.com/docs/git-push)"ed to work as a template for yours.

### Aim<a id="sec-"></a>

-   Cross-machine synchronization (hence, git, .local)
-   Modularity (hence, not a single file)
-   Self-documenting (hence, a single 😉 org file)
-   Workflow speed (obviously)
-   "Pretty" low resource load (hence, not GNOME/KDE)

### Non-aim<a id="sec-"></a>

-   Ease

## Will you be able to set this up?<a id="sec-"></a>

Probably [**NOT**](#org6dd3906).

<div class="important" id="orgfa599b0">
<p>
Read till the end before you decide to set this up.
</p>

</div>

# Copyright/License Header<a id="sec-"></a>

Copyright 2020, 2021 Pradyumna Paranjape

This file is part of Prady\_runcom.

Prady\_runcom is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Prady\_runcom is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Prady\_runcom. If not, see <https://www.gnu.org/licenses/>.

# Requirements<a id="sec-"></a>

## Knowledge<a id="sec-"></a>

-   Linux shell commands. We shall try to be POSIX-compliant.
-   Knowledge of Linux, "dotfiles".
-   super user (sudo) permissions (only for package installation)
    
    <div class="warning" id="org2e9276c">
    <p>
    Avoid use of <b>sudo</b> as much as possible.
    </p>
    
    </div>

## Dependencies<a id="sec-"></a>

-   A GNU/Linux distribution. I use [Fedora](https://fedoraproject.org).
-   [curl](https://curl.se/) for proxy authentication.
-   GNU [stow](https://www.gnu.org/software/stow/): dotfile management
-   [git](https://git-scm.com/): git it

<div class="important" id="org1facc44">
<p>
For Alpine Linux, <a href="file:///etc/apk/repositories">enable</a> the <a href="https://&lt;mirror-server&gt;/alpine/%3Cversion%3E/community">community repository</a>.
</p>

<ul class="org-ul">
<li>If you are using Alpine, you <b>MUST</b> know how.</li>
</ul>

</div>

### Bootstrap installation of dependencies<a id="sec-"></a>

For automated setup, only run the [dependencies script](./setup/dependencies.sh) with elevated privileges.

```sh
curl -sLf "https://pradyparanjpe.github.io/runcom/setup/dependencies.sh" | sudo sh
```

<div class="note" id="orge6a6265">
<p>
Inspecting scripts before running them (especially with <code>sudo</code>) is generally a good idea.
The <i>dependencies</i> script is tangled from the code below.
If you feel an urge to inspect it or if it fails,
install dependencies manually instead, that's all it does.
</p>

</div>

### Guide for manual installation of dependencies.<a id="sec-"></a>

Use suitable package manager to install curl, git, stow. It may be useful to update existing packages and repository database before installing packages.

-   dnf: Fedora, RockyLinux, RHEL, CentOS
    
    ```sh
    dnf update || return 65
    dnf -y install curl git stow || return 66
    ```

-   apk: Alpine Linux
    
    ```sh
    apk update || return 65
    apk --virtual runcom add curl git stow || return 66
    ```

-   apt: Debian, Ubuntu
    
    ```sh
    apt update || return 65
    apt install curl git stow || return 66
    ```

-   zypper: OpenSuSE, SuSE
    
    ```sh
    zypper ref || return 65
    zypper install curl git stow || return 66
    ```

-   pacman: Arch, Manjaro
    
    ```sh
    pacman -Syu curl git stow || return 65
    ```

# Legend<a id="sec-"></a>

## Brackets<a id="sec-"></a>

-   **Square** `[]`: optional parts: `W[orld]H[ealth]O[rganisation]`
-   **Angular** `<>`: instructions to fill: `<a global organisation>`
-   **Curly**, following a dollar `${}`: environment variable `${HOME}`
-   **Round**, with bar separator: `(WHO|UNO)` = *WHO or UNO*

# Setup<a id="sec-"></a>

-   Affirm [requirements](#org9a38544).

<div class="warning" id="org1023135">
<p>
Do <b>NOT</b> use <code>sudo</code> during setup.
</p>

</div>

<div class="warning" id="org0507171">
<ul class="org-ul">
<li>The next steps require you to delete all <a href="#org6cfe7ad">stowed dotfiles</a>.</li>
<li>Copy them elsewhere before proceeding.</li>
<li>You HAVE BEEN warned.</li>
</ul>

</div>

## Bootstrap setup using script<a id="sec-"></a>

-   Setup may be bootstrapped by running the [setup](./setup/setup.sh) script.
    
    ```sh
    curl -sLf "https://pradyparanjpe.github.io/runcom/setup/setup.sh" | sudo sh
    
    ```
    
    <div class="note" id="org1d5bb19">
    <p>
    Inspecting scripts before running them (especially with <code>sudo</code>) is generally a good idea.
    The <i>setup</i> script is tangled from the code below.
    If you feel an urge to inspect it or if it fails,
    follow manual setup instructions with modifications instead.
    </p>
    
    </div>

## Guide for manual setup.<a id="sec-"></a>

-   Clone the repository and place at `${HOME}/.runcom`

```sh
git clone --recurse-submodules "https://github.com/pradyparanjpe/runcom" "${HOME}/.runcom" || exit 1
```

-   Stow dotfiles
    
    ```sh
    stow -vS -t "${HOME}" -d "${HOME}/.runcom" dotfiles
    ```

## Personalization<a id="sec-"></a>

### Local<a id="sec-"></a>

Create a directory at the location `${XDG_CONFIG_HOME:-${HOME}/.config}/local.d`.

-   All files that match the glob `${XDG_CONFIG_HOME:-${HOME}/.config}/local.d/.*rc` are sourced.
-   Do not synchronize this directory. This directory is only for the machine.

```sh
mkdir -p "${XDG_CONFIG_HOME:-${HOME}/.config}/local.d"
```

### Synchronized<a id="sec-"></a>

Create a directory at the location `${XDG_CONFIG_HOME:-${HOME}/.config}/pvt.d`.

```sh
mkdir -p "${XDG_CONFIG_HOME:-${HOME}/.config}/pvt.d"
```

-   All files that match the glob `${XDG_CONFIG_HOME:-${HOME}/.config}/pvt.d/.*rc` are sourced.
-   Synchronize (stow) that directory using a local repository or by simply copying contents.

<div class="danger" id="orgdf946c5">
<ul class="org-ul">
<li><b>DO NOT</b> create this directory inside <code>${RUNCOMDIR}:-${HOME}/.runcom}/.config</code>.</li>
<li><b>DO NOT</b> synchronize this directory using a public repository.</li>
<li><b>DO NOT</b> store passwords in this directory. For password management, use <a href="https://passwordstore.org">pass</a></li>
</ul>

</div>

<div class="tip" id="orgc35268c">
<ul class="org-ul">
<li>Remember to keep the repository updated.</li>
</ul>

<div class="org-src-container">
<pre class="src src-sh">git pull --recurse-submodules
</pre>
</div>

</div>

### Proxy settings<a id="sec-"></a>

Read set up for [proxy\_send](./proxy_send.html).

**<span class="underline">SETUP COMPLETE!</span> Following sections explain and tangle the contents of runcom.**

# Structure<a id="sec-"></a>

Following configuration files are available. This literate configuration tangles their contents.

| Configuration File Path            | POSIX | Stowed | Owner |
| /etc/profile                       | yes   | no     | Root  |
| /etc/bashrc                        | yes   | no     | Root  |
| /etc/zshrc                         | yes   | no     | Root  |
| /etc/profile.d/\*                  | yes   | no     | Root  |
| ${HOME}/.bash\_completion.d/\*     | no    | no     | $USER |
| ${HOME}/.bashrc                    | no    | yes    | $USER |
| ${HOME}/.zshrc                     | no    | yes    | $USER |
| ${HOME}/.bash\_profile             | yes   | yes    | $USER |
| ${HOME}/.bash\_login               | yes   | yes    | $USER |
| ${HOME}/.profile                   | yes   | yes    | $USER |
| ${HOME}/.zprofile                  | yes   | yes    | $USER |
| ${HOME}/.zlogin                    | yes   | yes    | $USER |
| ${RUNCOMDIR}/shrc                  | yes   | yes    | $USER |
| ${RUNCOMDIR}/ui                    | yes   | yes    | $USER |
| ${RUNCOMDIR}/complete.bash         | yes   | yes    | $USER |
| ${XDG\_CONFIG\_HOME}/local.d/.\*rc | yes   | no     | $USER |
| ${XDG\_CONFIG\_HOME}/pvt.d/.\*rc   | yes   | pvt    | $USER |

They are loaded in following order.

## Bash<a id="sec-"></a>

### /etc/profile<a id="sec-"></a>

-   /etc/bashrc

    -   /etc/profile.d/\*

### ${HOME}/.bash\_profile<a id="sec-"></a>

-   ${HOME}/.profile

-   ${HOME}/.bashrc

    -   ${RUNCOMDIR}/shrc
    
        -   ${XDG\_CONFIG\_HOME}/local.d/\*
        
        -   ${XDG\_CONFIG\_HOME}/pvt.d/\*

-   ${HOME}/.bash\_login

    -   ${RUNCOMDIR}/ui

## Zsh<a id="sec-"></a>

### /etc/profile<a id="sec-"></a>

-   /etc/zshrc

    -   /etc/profile.d/\*

### ${HOME}/.zshenv<a id="sec-"></a>

### ${HOME}/.zprofile<a id="sec-"></a>

-   ${HOME}/.profile

### ${HOME}/.zshrc<a id="sec-"></a>

-   ${RUNCOMDIR}/shrc

    -   ${XDG\_CONFIG\_HOME}/local.d/\*
    
    -   ${XDG\_CONFIG\_HOME}/pvt.d/\*

### ${HOME}/.zlogin<a id="sec-"></a>

-   ${RUNCOMDIR}/ui

# Headers<a id="sec-"></a>

Copyright, License banners

# Profiles<a id="sec-"></a>

```bash
if [ -f "${HOME}/.profile" ]; then
    # shellcheck disable=SC1091
    . "${HOME}/.profile"
fi

if [ -f "${HOME}/.bashrc" ]; then
    # shellcheck disable=SC1091
    . "${HOME}/.bashrc"
fi

if [ -f "${HOME}/.bash_login" ]; then
    # shellcheck disable=SC1091
    . "${HOME}/.bash_login"
fi

```

```bash
# shellcheck source=".profile"
if [ -f "${HOME}"/.profile ]; then
    # shellcheck disable=SC1091
    . "${HOME}"/.profile
fi
```

```bash
# The following lines were added by compinstall

zstyle ':completion:*' completer _complete _ignored _approximate
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' matcher-list ''
zstyle ':completion:*' max-errors 2
zstyle ':completion:*' menu select=3
zstyle ':completion:*' select-prompt %SScrolling \
       active: current selection at %p%s
zstyle :compinstall filename "${HOME}/.zshrc"

# End of lines added by compinstall
# Lines configured by zsh-newuser-install

```

# Init<a id="sec-"></a>

## bash<a id="sec-"></a>

-   Prevent bashrc from running outside non-interactive mode

```bash
case $- in
    *i*)
    ;;
    *)
        return
        ;;
esac
```

-   Option settings

```bash
shopt -s autocd
shopt -s checkwinsize
shopt -s globstar
```

-   History

```bash
shopt -s histappend
HISTCONTROL=ignoreboth
HISTSIZE=10000
HISTFILESIZE=10000
```

-   Colored terminals

```bash
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac
```

-   Keybindings

```bash
set -o vi
bind '"jk":vi-movement-mode'
```

## zsh<a id="sec-"></a>

Settings

-   History

```bash
HISTFILE="${XDG_CACHE_HOME:-${HOME}/.cache}/.zhistory"
HISTSIZE=10000
SAVEHIST=10000
```

-   Options
    
    ```bash
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#5f6f7f,bg=#172737"
    ZSH_AUTOSUGGEST_STRATEGY=("history" "completion")
    setopt autocd
    setopt interactive_comments
    setopt appendhistory extendedglob notify
    setopt BANG_HIST                 # Treat the '!' character specially during expansion.
    setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
    setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
    setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
    setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
    setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
    setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
    setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
    setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
    setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
    setopt HIST_VERIFY               # Don't execute immediately upon history expansion.
    unsetopt beep
    autoload colors && colors
    autoload add-zsh-hook
    autoload -Uz compinit
    compinit
    ```

-   Keybindings
    
    ```bash
    term_key_source="${HOME}/.zkbd/$TERM-${${DISPLAY:t}:-$VENDOR-$OSTYPE}"
    if [ -f "${term_key_source}" ]; then
        source "${term_key_source}"
    fi
    # keybindings
    bindkey -v
    bindkey -s '^o' 'lfcd\n'
    bindkey -s '^f' 'fzfcd\n'
    bindkey -s '^E' 'deactivate 2>/dev/null || true\n'
    bindkey -s '^N' 'force_global_venv\n'
    bindkey '^[[P' delete-char  # backspace key
    bindkey '^[[1;5D' vi-backward-word  # ctrl <-
    bindkey '^[[1;5C' vi-forward-word  # ctrl ->
    bindkey '^[[3~' vi-delete-char  # delete key
    bindkey '^[[F' vi-end-of-line  # end key
    bindkey '^[[H' vi-beginning-of-line  # home key
    bindkey "^[[27;2;13~" vi-open-line-below  # shift Return
    export KEYTIMEOUT=10
    
    # Use beam shape cursor for each new prompt.
    _fix_cursor () {
        echo -ne '\e[6 q'
    }
    add-zsh-hook precmd _fix_cursor
    
    # Change cursor shape for different vi modes.
    zle-keymap-select () {
        if [ "${KEYMAP}" = "vicmd" ] ||
               [ "${1}" = 'block' ]; then
            printf '\e[2 q'
    
        elif [ "${KEYMAP}" = "main" ] ||
                 [ "${KEYMAP}" = "viins" ] ||
                 [ "${KEYMAP}" = '' ] ||
                 [ "${1}" = 'beam' ]; then
            printf '\e[6 q'
        elif [ "${KEYMAP}" = "visual" ]; then
            printf '\e[4 q'
        fi
    }
    # Use vim keys in tab complete menu:
    zmodload zsh/complist
    zmodload zsh/mapfile
    bindkey -M menuselect 'h' vi-backward-char
    bindkey -M menuselect 'k' vi-up-line-or-history
    bindkey -M menuselect 'l' vi-forward-char
    bindkey -M menuselect 'j' vi-down-line-or-history
    bindkey -v '^?' backward-delete-char
    bindkey -M viins 'jk' vi-cmd-mode
    bindkey '^r' history-incremental-search-backward
    
    zle -N zle-keymap-select
    
    ```
-   Unset options:
    -   setopt SHARE\_HISTORY # Share history between all sessions.
    -   setopt HIST\_BEEP # Beep when accessing nonexistent history.
    -   HISTCONTROL=ignoreboth # ignore commands staring with " " and duplicate

# Inherit<a id="sec-"></a>

## bash<a id="sec-"></a>

```bash
# shellcheck source=".runcom/shrc"
if [ -f "${RUNCOMDIR:-${HOME}/.runcom}/shrc" ]; then
    . "${RUNCOMDIR:-${HOME}/.runcom}/shrc"
fi
if [ -f "${RUNCOMDIR:-${HOME}/.runcom}/bash-preexec/bash-preexec.sh" ]; then
    . "${RUNCOMDIR:-${HOME}/.runcom}/bash-preexec/bash-preexec.sh"
fi
```

## zsh<a id="sec-"></a>

```bash
# shellcheck source=".runcom/shrc"
if [ -f "${RUNCOMDIR:-${HOME}/.runcom}/shrc" ]; then
    . "${RUNCOMDIR:-${HOME}/.runcom}/shrc"
fi
while read -r addition; do
    while read -r share_dir; do
        add_dir="${share_dir}/zsh-${addition}"
        if [ -d "${add_dir}" ]; then
            # shellcheck disable=SC1090
            . "${add_dir}/zsh-${addition}.zsh"
            break
        fi
    done << data_dir
/usr/local/share
/usr/share
${XDG_DATA_HOME:-${HOME}/.local/share}
${XDG_DATA_HOME:-${HOME}/.local/share}/pspman/local/share
${HOME}/local/share
${HOME}/share
data_dir
done << addlist
syntax-highlighting
autosuggestions
addlist

unset addition
unset share_dir
unset add_dir

```

## shrc<a id="sec-"></a>

### Private synced changes<a id="sec-"></a>

All files `${XDG_CONFIG_HOME:-${HOME}/.config}/pvt.d/.*rc`

```sh
# shellcheck disable=SC1090
if [ -d "${XDG_CONFIG_HOME:-${HOME}/.config}/pvt.d" ]; then
    for pvt_src in "${XDG_CONFIG_HOME:-${HOME}/.config}/pvt.d"/.*rc; do
        . "${pvt_src}"
    done
fi
unset pvt_src
```

### Local unsynced changes<a id="sec-"></a>

All files `${XDG_CONFIG_HOME:-${HOME}/.config}/local.d/.*rc`

```sh
# shellcheck disable=SC1090
if [ -d "${XDG_CONFIG_HOME:-${HOME}/.config}/local.d" ]; then
    for local_src in "${XDG_CONFIG_HOME:-${HOME}/.config}/local.d"/.*rc; do
        . "${local_src}"
    done
fi
unset local_src
```

### Python<a id="sec-"></a>

[Argcomplete](https://github.com/kislyuk/argcomplete) to complete python commands

```sh
# shellcheck source=.local/share/pspman/src/runcom/complete.bash
if [ -f "${RUNCOMDIR:-${HOME}/.runcom}/complete.bash" ]; then
    # shellcheck source=.local/share/pspman/src/runcom/complete.bash
    . "${RUNCOMDIR:-${HOME}/.runcom}/complete.bash"
fi
```

# Better alternatives<a id="sec-"></a>

## cat<a id="sec-"></a>

```sh
if builtin command -v 'bat' >/dev/null 2>&1; then
    alias cat="bat --color=auto";
fi
```

## g/re/p<a id="sec-"></a>

```sh
for sc in "ack" "pt" "ag" "rg"; do
    if builtin command -v "${sc%% *}" >/dev/null 2>&1; then
        # shellcheck disable=SC2139
        alias grep="${sc} --color=auto";
    fi
done
```

## List Contents<a id="sec-"></a>

```sh
if builtin command -v "exa" >/dev/null 2>&1; then
    alias ls="exa -Fh --color=auto";
    alias la='exa -a --color=auto';
    alias ll='exa -lr -s size';
    alias lla='exa -a';
    alias l.='exa -a --color=auto |grep "^\."';
    alias sl="ls";
fi
```

## neo visual editor improved<a id="sec-"></a>

```sh
if builtin command -v nvim >/dev/null 2>&1; then
    alias ex="nvim"; # always open vim in normal mode
    alias vim="nvim"; # always use neo
fi
```

## Container<a id="sec-"></a>

```sh
if builtin command -v podman >/dev/null 2>&1; then
    alias docker="podman";  # Podman is drop-in replacement for docker
    alias docker-compose="podman-compose";  # Podman is drop-in replacement for docker
fi
```

# Variables<a id="sec-"></a>

## PATH<a id="sec-"></a>

```sh
RUNCOMDIR="${HOME}/.runcom"
export RUNCOMDIR
# shellcheck source="bin"
if [ -d "${HOME}/bin" ] ; then
    if [ "${PATH#*${HOME}/bin}" = "${PATH}" ]; then
        PATH="${HOME}/bin:${PATH}"
    fi
fi
# shellcheck source=".local/bin"
if [ -d "${HOME}/.local/bin" ] ; then
    if [ "${PATH#*${HOME}/.local/bin}" = "${PATH}" ]; then
        PATH="${HOME}/.local/bin:${PATH}"
    fi
fi
export PATH;
```

## Editor wars<a id="sec-"></a>

```sh
while read -r avail; do
    if builtin command -v "${avail}" >/dev/null 2>&1; then
        EDITOR="${avail}"
    fi
done << EOF
nano
vi
vim
nvim
EOF
export EDITOR

case "$EDITOR" in
    vim)
        export MANPAGER='/bin/bash -c "vim -MRn -c \"set buftype=nofile showtabline=0 ft=man ts=8 nomod nolist norelativenumber nonu noma\" -c \"normal L\" -c \"nmap q :qa<CR>\"</dev/tty <(col -b)"'
        ;;
    nvim)
        export MANPAGER="nvim -c ':Man!' -"
        ;;
    *)
        if builtin command -v bat; then
            export MANPAGER='bat -l man -p'
        fi
        ;;
esac
export MANPAGER
```

## C(++) exports<a id="sec-"></a>

```sh
LD_LIBRARY_PATH="${HOME}/.local/lib:${HOME}/.local/lib64";
C_INCLUDE_PATH="${HOME}/.local/share/pspman/include/"
CPLUS_INCLUDE_PATH="${HOME}/.local/share/pspman/include/"
export LD_LIBRARY_PATH
export C_INCLUDE_PATH
export CPLUS_INCLUDE_PATH
```

## GPU exports<a id="sec-"></a>

```sh
PYOPENCL_CTX='0';
PYOPENCL_COMPILER_OUTPUT=1;
OCL_ICD_VENDORS="/etc/OpenCL/vendors/";
export PYOPENCL_CTX
export PYOPENCL_COMPILER_OUTPUT
export OCL_ICD_VENDORS
```

## Bemenu exports<a id="sec-"></a>

```sh
export BEMENU_OPTS='--fn firacode 14 '
```

## GTK+ debugging output<a id="sec-"></a>

Silence debugging output for gtk+

```sh
NO_AT_BRIDGE=1
export NO_AT_BRIDGE
```

# Functions<a id="sec-"></a>

## Python<a id="sec-"></a>

### Python version<a id="sec-"></a>

to locate site-packages

```sh
python_ver() {
    python --version |cut -d "." -f1,2 |sed 's/ //' |sed 's/P/p/'
}
```

### Quickly change to virtualenv<a id="sec-"></a>

Scan upto mountpoint, if any direct parent has .venv, source that ".venv/bin/activate" This may require shell-identification for ksh, csh, fish since they have a different activate

```sh
to_venv () {
    test_d="$(realpath "${PWD}")"
    parents=16  # path too long to waste time
    until mountpoint "${test_d}" > /dev/null 2> /dev/null; do
        if [ $parents -le 0 ]; then
            printf "Too many branch-nodes searched" >&2
            unset parents
            unset test_d
            unset env_d
            return 126
        fi
        for env_d in ".venv" "venv"; do
            if [ -d "${test_d}/${env_d}" ] \
                   || [ -L "${test_d}/${env_d}" ]; then
                # shellcheck disable=SC1090
                . "${test_d}/${env_d}/bin/activate"
                printf "Found %s, switching...\n" "${test_d}/${env_d}"
                unset parents
                unset test_d
                unset env_d
                return 0
            fi
        done
        test_d="$(dirname "${test_d}")"
        parents=$((parents - 1))
    done
    printf "Couldn't find .venv upto mountpoint %s\n" "${test_d}" >&2
    unset parents
    unset test_d
    unset env_d
    return 126
}
```

### Virtualenv in prompt string<a id="sec-"></a>

```sh
_show_venv () {
    # if a virtualenv is active, print it's name
    if [ -n "${VIRTUAL_ENV}" ]; then
        base="$(basename "${VIRTUAL_ENV}")"
        if [ "${base}" = ".venv" ] || [ "${base}" = "venv"  ]; then
            printf "/%s" "$(basename "$(dirname "${VIRTUAL_ENV}")")"
            unset base
        else
            printf "/%s" "${base}"
            unset base
        fi
    fi
}
```

## Git<a id="sec-"></a>

### Status<a id="sec-"></a>

```sh
git_status() {
    _modified=0
    _cached=0
    _untracked=0

    while read -r _line; do
        case "${_line}" in
            _*_\ _)
                _cached=1
                ;;
            _\ _*_)
                _modified=1
                ;;
            _?_?_)
                _untracked=1
                ;;
        esac
    done << endstat
$(git status --short | cut -b -2 | sed -e 's/\(.\)\(.*\)/_\1_\2_/')
endstat

    _stat_str=''
    if [ "$_modified" -ne 0 ]; then
        _stat_str="${_stat_str}\033[0;31m\ue728"
    fi

    if [ "$_cached" -ne 0 ]; then
        _stat_str="${_stat_str}\033[0;32m\ue729"
    fi

    if [ "$_untracked" -ne 0 ]; then
        _stat_str="${_stat_str}\033[0;31m\uf476"
    fi

    if [ -n "$(git stash list)" ]; then
        _stat_str="${_stat_str}\e[0;36m\uf48e"
    fi
    if [ -n "${_stat_str}" ]; then
        # shellcheck disable=SC2059  # I do want escape characters
        printf "${_stat_str}\e[m"
    fi
    unset _modified
    unset _cached
    unset _untracked
    unset _stat_str
}
```

### Branch<a id="sec-"></a>

```sh
git_branch() {
    branch_str=''
    branch="$(git branch 2>/dev/null | grep '^\*' | sed -e 's/^* //')"
    if [ -n "${branch}" ]; then
        case "${branch}" in
            feat-*)
                branch_str="${branch_str}\033[0;32m"
                ;;
            bug-*)
                branch_str="${branch_str}\033[0;31m"
                ;;
            act-*)
                branch_str="${branch_str}\e[0;36m"
                ;;
            tmp-*)
                branch_str="${branch_str}\e[0;36m"
                ;;
            *HEAD\ detached*|,*rebasing*)
                branch_str="${branch_str}\e[0;33m"
                ;;
            main|master)
                unset branch
                unset branch_str
                return
                ;;
            *)
                branch_str="${branch_str}\e[0;35m"
                ;;
        esac
    fi
    printf "${branch_str}%s\ue725\e[m" "${branch}"
    unset branch_str
    unset branch
}

```

### Hash<a id="sec-"></a>

```sh
git_hash() {
    git log --pretty=format:'%h' -n 1
}
```

### Prompt string<a id="sec-"></a>

Include git's branch, hash, status in PS1 if in git repository This function is called in PS1 section below

```sh
git_ps() {
    if ! git status --ignore-submodules >/dev/null 2>&1; then
        return
    else
        printf " %s%s%s " "$(git_branch)" "$(git_hash)" "$(git_status)"
    fi
}
```

## Prompt String<a id="sec-"></a>

### Exit\_color<a id="sec-"></a>

```sh
last_exit_color () {
    case "$1" in
        0)
            # success
            printf "\e[0;32m"
            ;;
        1)
            # general error
            printf "\e[0;33m"
            ;;
        2)
            # misuse of shell builtins
            printf "\e[0;31m"
            ;;
        126)
            # cannot execute
            printf "\e[0;37m"
            ;;
        127)
            # command not found
            printf "\e[0;30m"
            ;;
        255)
            # exit status limit
            printf "\e[0;31m"
            ;;
        *)
            if [ "$1" -gt "63" ] && [ "$1" -lt "84" ]; then
                # syserror.h
                printf "\e[0;91m"

            elif [ "$1" -gt "127" ] && [ "$1" -lt "191" ]; then
                # Fatal error
                printf "\e[0;41m"
            else
                printf "\e[0;31m"
            fi
            unset _err
            ;;
    esac
}
```

### Elapsed\_time<a id="sec-"></a>

```sh
_elapsed_time() {
    # $1 is start time $2 is end time
    _cmd_start="$1"
    _cmd_end="$2"
    if [ -z "$_cmd_end" ] || [ -z "$_cmd_start" ]; then
        return
    fi
    _sec=$(( _cmd_end - _cmd_start ))
    unset _cmd_start
    unset _cmd_end
    if [ "$_sec" -le 0 ]; then
        return
    fi
    if [ "$_sec" -le 60 ]; then
        printf "%s" "${_sec}"
        unset _sec
        return
    fi
    _min=$(( _sec/60 ))
    unset _sec
    if [ "$_min" -le 60 ]; then
        printf "%sm" "${_min}"
        unset _min
        return
    fi
    _hr=$(( _min/60 ))
    unset _min
    if [ "$_hr" -le 24 ]; then
        printf "%sh" "${_hr}"
        unset _hr
        return
    fi
    _day=$(( _hr/24 ))
    unset _min
    printf "%sd" "${_day}"
    unset _day
}
```

### PROMPT\_COMMAND<a id="sec-"></a>

-   bash

    ```bash
    # export PROMPT_COMMAND=__prompt_command
    
    preexec() {
        _cmd_start_t="${SECONDS}"
    }
    
    precmd () {
        _exit_color="$(last_exit_color $?)"
    
        _elapsed="$(_elapsed_time $_cmd_start_t ${SECONDS})"
        unset _cmd_start_t
    
        # unset previous
        PS1=""
        PS2=""
        PS3=""
        PS4=""
        RPROMPT=""
    
        PS1+="\[\e[0;32m\]\u\[\e[m\]"
        PS1+="\[\e[3;35m\]\$(_show_venv)\[\e[m\]"
        PS1+="@"
        PS1+="\[\e[0;34m\]\h\[\e[m\]"
        PS1+="\$(git_ps)"
        PS1+="\[\e[0;36m\]:\W"
        PS1+="\[\e[0;37m\]"
    
        PS1+="$(date '+%H:%M:%S')"
        PS1+=" ${_exit_color}-${_elapsed}"
        PS1+='\[\e[m\]\n» '
    
        PS2=""
        PS2+="\[\e[0;36m\]cont..."
        PS2+="\[\e[m\]"
        PS2+="» ";
    
        PS3='Selection: ';
    }
    ```

-   zsh

    ```bash
    _pspexec() {
        _cmd_start_t="${SECONDS}"
    }
    
    _pspps () {
        _exit_color="$(last_exit_color $?)"
    
        _elapsed="$(_elapsed_time $_cmd_start_t ${SECONDS})"
        unset _cmd_start_t
    
        # unset previous
        PS1=$''
        PS2=$''
        PS3=$''
        PS4=$''
        RPROMPT=$''
    
        PS1+=$'%{\e[0;32m%}%n%{\e[m%}'
        PS1+=$'%{\e[3;35m%}'
        PS1+="$(_show_venv)"
        PS1+=$'%{\e[m%}'
        PS1+=$'@'
        PS1+=$'%{\e[0;34m%}%m%{\e[m%}'
        PS1+="$(git_ps)"
        PS1+=$'%{\e[0;36m%}:%1~'
        PS1+=$'%{\e[0;37m%}\n%{\e[m%}» '
    
        PS2+=$'%{\e[0;36m%}cont...'
        PS2+=$'%{\e[m%}'
        PS2+=$'» '
    
        PS3='Selection: '
    
        RPROMPT+=$'%*'
        RPROMPT+="%{$_exit_color%}-${_elapsed}"
        RPROMPT+=$'%{\e[m%}'
        unset _exit_stat
        unset _elapsed
    }
    
    add-zsh-hook precmd _pspps
    add-zsh-hook preexec _pspexec
    
    ```

## Mathematical<a id="sec-"></a>

### In-Line Calculator<a id="sec-"></a>

```sh
mathcalc() {
    echo "$*"| bc -lq
}
```

### Computational<a id="sec-"></a>

```sh
dec2hex() {
    echo "hex:"
    echo "obase=16; $*"| bc
    echo "dec:"
    echo "ibase=16; $*"| bc
}
```

## Compilation<a id="sec-"></a>

### PDF from Latex<a id="sec-"></a>

```sh
pdfcompile() {
    if builtin command -v "pdflatex" 1>/dev/null 2>&1; then
        printf "pdflatex is not installed\n"
        return 127
    fi

    pdflatex "$1"
    for ext in ".toc" ".log" ".aux"; do
        [ -f "${1%.tex}${ext}" ] && rm "${1%.tex}${ext}"
    done
    evince "${1%.tex}.pdf"
}
```

### Pandoc<a id="sec-"></a>

-   Org to Something

    ```sh
    org2export() {
        # Usage: org2oth [-f] <infile> <othtype>
        if ! builtin command -v "pandoc" 1>/dev/null 2>&1; then
            printf "pandoc is not installed\n"
            return 127
        fi
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
        if [ "${1}" = "pdf" ]; then
            target="latex"
        else
            target="${1}"
        fi
        case "$infile" in
            *.org)
                proceed=true
                ;;
            *)
                echo "Input file should be an org file"
                ;;
        esac
        if [ -n "$proceed" ]; then
            pandoc -f org -t "${target}" -o "${infile%.*}.${1}" "$infile"
        fi
        unset proceed
        unset target
        unset infile
    }
    ```

-   Org to Docx

    ```sh
    org2doc () {
        org2export "$@" "docx"
    }
    ```

-   Org to PDF

    ```sh
    org2pdf () {
        org2export "$@" "pdf"
    }
    ```

-   Docx to Org

    ```sh
    doc2org() {
        if ! builtin command -v "pandoc" 1>/dev/null 2>&1; then
            printf "pandoc is not installed\n"
            return 127
        fi
    
        case "${1}" in
            *.docx)
                pandoc -f docx -t org -o "${1%.docx}.org" "$1"
                ;;
            *)
                echo "Input file must be a docx file"
                ;;
        esac
    }
    ```

## Mount over ssh<a id="sec-"></a>

ssh Cloud mounts

```sh
mount_cloud_sshfs() {
    mount_script="${RUNCOMDIR:-${HOME}/.runcom}/bin/cloud_mount.sh"
    if [ -f "${mount_script}" ]; then
        eval "${mount_script}"
    fi
}

umount_cloud_sshfs() {
    mount_script="${RUNCOMDIR:-${HOME}/.runcom}/bin/cloud_mount.sh"
    if [ -f "${mount_script}" ]; then
        eval "${mount_script}" "umount"
    fi
}

```

## Launch gui<a id="sec-"></a>

Launch application and exit terminal window Acts like a launcher Uninteractive terminal commands may also be called

```sh
gui () {
    usage="usage: $0 [-h|--help] CMD\n"
    cmd_help="Launch CMD, switch to it, and exit the parent terminal\n\n"
    cmd_help="${cmd_help}Optional arguments:\n"
    cmd_help="${cmd_help}-h|--help\tdisplay this help and exit\n"
    cmd=
    call=

    while [ $# -gt 0 ]; do
        case "$1" in
            --help|-h)
                printf "%s""${usage}"
                printf "%s""${cmd_help}"
                shift 1
                unset cmd
                unset cmd_help
                unset usage
                unset call
                return 0
                ;;
            --)
                # end of gui arguments
                cmd="${cmd} $*"
                break
                ;;
            *)
                cmd="${1}"
                shift 1
                ;;
        esac
    done

    call="$(echo "${cmd}" | cut -d " " -f 1)"
    if [ -n "${call}" ]; then
        if builtin command -v "${call}" >/dev/null 2>&1; then
            unset cmd_help
            unset usage
            unset call
            nohup "${cmd}" >/dev/null 0<&- 2>&1 & exit 0
        else
            echo "${call} not found..."
            unset cmd
            unset cmd_help
            unset usage
            unset call
            return 127
        fi
    else
        printf "%s""${usage}"
        unset cmd
        unset cmd_help
        unset usage
        unset call
        return 1
    fi

}

```

## Un-Compress by context<a id="sec-"></a>

```sh
deconvolute() {
    if builtin command -v "pigz"; then
        _gzip="pigz"
    else
        _gzip='gzip'
    fi
    if [ ! -f "${1}" ]; then
        echo "${1}: no such file";
    else
        case "${1}" in
            *.tar.bz2) tar -xjf "${1}" ;;
            *.tbz2) tar -xjf "${1}" ;;
            *.tar.gz) tar -x --use-compress-program="${_gzip}" -f "${1}" ;;
            *.tgz) tar -x --use-compress-program="${_gzip}" -f "${1}" ;;
            *.gz) unpigz "${1}" || gunzip "${1}" ;;
            *.rar) unrar -x "${1}" ;;
            *.tar) tar -xf "${1}" ;;
            *.zip) unzip "${1}" ;;
            *.tar.xz) tar -xf "${1}" ;;
            *) echo "Cannot extract ${1}, provide explicit command";;
        esac
    fi
    unset _gzip
}
```

## Navigate<a id="sec-"></a>

-   When no virtualenv is active, but one is available, switch to it

```sh
cd () {
    if [ -z "${1}" ]; then
        builtin cd "${HOME}" || true
    else
        builtin cd "${1}"  || true
    fi
    if [ -z "${VIRTUAL_ENV}" ]; then
        to_venv 2>/dev/null
    fi
}
```

-   Inspired by lukesmith.xyz

```sh
lfcd () {
    if ! command -v 'lf' >/dev/null 2>/dev/null; then
        printf "lf is not installed\n"
        return 127
    fi
    tmp_file="$(mktemp)"
    lf -last-dir-path="${tmp_file}" "$@"
    if [ -f "${tmp_file}" ]; then
        target_dir="$(cat "${tmp_file}")"
        rm -f "${tmp_file}" >/dev/null
        if [ -d "${target_dir}" ] && [ "${target_dir}" != "$(pwd)" ]; then
            cd "${target_dir}" || return
        fi
    fi
    unset tmp_file
    unset target_dir
}

fzfcd () {
    if ! command -v 'fzf' >/dev/null 2>/dev/null; then
        printf "fzf is not installed\n"
        return 127
    fi
    cd "$(dirname "$(fzf)")" || true
}
```

## zwc<a id="sec-"></a>

-   Guess whether target is zipped; if zipped, unzip and count else classical wc

```sh
zwc () {
    args="$*"
    fname="${args##* }"
    args="${args% ${fname}}"
    args="${args%${fname}}"

    if gzip -t "${fname}" > /dev/null 2>&1; then
        if [ -z "${args}" ]; then
            zcat -f "${fname}" | wc
        else
            # shellcheck disable=SC2086
            zcat -f "${fname}" | wc $args
        fi
        return
    else
        wc "$@"
        return
    fi

}
```

## disable autovenv<a id="sec-"></a>

-   To disable autoswitching virtualenvs, hard-set VIRTUAL\_ENV
    -   Calling the function again reverts

```sh
force_global_venv () {
    if [ "${VIRTUAL_ENV}" = "Global_Env" ]; then
        unset VIRTUAL_ENV
        to_venv 2>/dev/null
    else
        deactivate 2>/dev/null
        VIRTUAL_ENV="Global_Env"
    fi
}
```

## lszcat<a id="sec-"></a>

```sh
lszcat () {
    args="$*"
    fname="${args##* }"
    args="${args%% ${fname}}"
    args="${args%%${fname}}"

    if builtin command -v bat >/dev/null 2>&1; then
        betcat="$(which bat)"
    else
        betcat="$(which cat)"
    fi

    if builtin command -v exa >/dev/null 2>&1; then
        betls="$(which exa)"
    else
        betls="$(which ls)"
    fi

    if [ -z "${fname}" ] || [ ! "${fname#-}" = "${fname}" ]; then
        if [ -z "${args}" ]; then
            args="${fname}"
        else
            args="${args} ${fname}"
        fi
        fname="$(readlink -f ".")"
        echo "${fname}"
    fi

    if [ -d "${fname}" ]; then
        # shellcheck disable=SC2086
        "${betls}" ${args} "${fname}"
    elif gzip -t "${fname}" >/dev/null 2>&1; then
        # shellcheck disable=SC2086
        zcat -f ${args} "${fname}" | "${betcat}"
    else
        # shellcheck disable=SC2086
        "${betcat}" ${args} "${fname}"
    fi
}
```

## manual pages<a id="sec-"></a>

```sh
man_help () {
    if man "$@"; then
        return 0
    elif tldr "$@"; then
        return 0
    elif builtin command -v "$1" >/dev/null 2>/dev/null; then
        printf "trying to display %s --help output\n" "${1}"
        if builtin command -v 'bat' >/dev/null 2>/dev/null; then
            $1 --help 2>&1 | bat
        else
            $1 --help 2>&1 | less -RF
        fi
        return 0
    else
        return 16
    fi
}
```

# Aliases<a id="sec-"></a>

## Disk Usage<a id="sec-"></a>

```sh
alias du='du -hc';
alias df='df -h';
alias duall="du -hc |\grep '^[3-9]\{3\}M\|^[0-9]\{0,3\}\.\{0,1\}[0-9]\{0,1\}G'";
```

## manual page help<a id="sec-"></a>

```sh
alias man="man_help";
```

## Network<a id="sec-"></a>

```sh
alias nload='nload -u M -U G -t 10000 -a 3600 $(ip a | grep -m 1 " UP " | cut -d " " -f 2 | cut -d ":" -f 1)'
alias nethogs='\su - -c "nethogs $(ip a | grep  "state UP" | cut -d " " -f 2 | cut -d ":" -f 1) -d 10"';
alias ping="ping -c 4 ";
```

## Monitor Job queues<a id="sec-"></a>

```sh
alias watch="watch -n 10 --color";
```

## Lazy single-handed exit<a id="sec-"></a>

```sh
alias qqqq="exit";
```

## [z]wc<a id="sec-"></a>

```sh
alias wc="zwc";
```

# Networking<a id="sec-"></a>

## State<a id="sec-"></a>

The **OLDEST** part of prady\_runcom&#x2026;

-   &#x2026; although, amended many times

Display state of network connection at the beginning

```sh
# shellcheck source=./bin/netcheck.sh
IFS="$(printf '\t')" read -r IP_ADDR AP_ADDR netstate << netcheck
$("${RUNCOMDIR:-${HOME}/.runcom}"/bin/netcheck.sh)
netcheck
export IP_ADDR
export AP_ADDR
if [ $(( netstate & 8)) ]; then
    printf "\e[1;34mInternet (GOOGLE) Connected\e[m\n"
    if [ ! $(( netstate & 16)) ]; then
        printf "\e[1;35mProblem with DNS\e[m\n"
    fi
    printf "\033[0;32m%s \e[m is current wireless ip address\n" "$IP_ADDR"
else
    printf "\e[1;31mInternet (GOOGLE) Not reachable\e[m\n"
    if [ $(( netstate & 4 )) ]; then  # Intranet is connected
        printf "\033[0;31mInternet Down\e[m\n"
        if [ $(( netstate & 2 )) ]; then
            printf "Home network connected,\n"
        elif [ $(( netstate & 1 )) ]; then
            printf "OFFICE network connected,\n"
            # shellcheck source=./bin/proxy_send.sh
            auto_proxy="${RUNCOMDIR:-${HOME}/.runcom}/bin/proxy_send.sh"
            if [ -f "${auto_proxy}" ]; then
                # shellcheck source=./proxy_send.py
                eval $auto_proxy && printf "\e[0;33mPROXY AUTH SENT\e[m\n";
            fi
            unset auto_proxy
        else
            printf "HOTSPOT connected\n"
        fi
    else
        printf "\e[1;33mNetwork connection Disconnected\e[m\n"
    fi
fi
```

## SSH Agent<a id="sec-"></a>

Reuse ssh agent for all logins

```sh
if [ ! -S ~/.ssh/ssh_auth_sock ]; then
    eval "$(ssh-agent)"
    ln -sf "$SSH_AUTH_SOCK" ~/.ssh/ssh_auth_sock
fi
SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock
export SSH_AUTH_SOCK
ssh-add -l > /dev/null || ssh-add
```

# Window Manager settings<a id="sec-"></a>

## Sway exports<a id="sec-"></a>

Don't really remember why these were made Not using currently. Preserved for future tangle to bash\_login export WLR\_BACKENDS="headless"; export WLR\_LIBINPUT\_NO\_DEVICES=1;

## User Interface (GUI/CLI)<a id="sec-"></a>

If running from tty1 setup sway environment and start ui

```sh
_common_exports() {
    if [ -z "$XDG_RUNTIME_DIR" ]; then
        XDG_RUNTIME_DIR="/run/user/$(id -u)"
    fi
    QT_PLUGIN_PATH="/usr/lib/kde4/plugins/"
    QT_AUTO_SCREEN_SCALE_FACTOR=0
    QT_QPA_PLATFORMTHEME="qt5ct"
    _JAVA_AWT_WM_NONREPARENTING=1

    export XDG_RUNTIME_DIR
    export QT_PLUGIN_PATH
    export QT_AUTO_SCREEN_SCALE_FACTOR
    export QT_QPA_PLATFORMTHEME
    export _JAVA_AWT_WM_NONREPARENTING
}
_exports_for_sway () {
    # export DISPLAY=":0"
    # export WAYLAND_DISPLAY=wayland-0
    # export GDK_BACKEND=wayland,x11
    _common_exports

    XDG_SESSION_TYPE="wayland"
    SDL_VIDEODRIVER="wayland"
    SWAYROOT="${XDG_CONFIG_HOME:-${HOME}/.config}/sway"
    ECORE_EVAS_ENGINE="wayland_egl"
    ELM_DISPLAY="wl"
    ELM_ENGINE="wayland_egl"
    ELM_ACCEL="opengl"
    QT_QPA_PLATFORM="wayland-egl;xcb"
    QT_WAYLAND_FORCE_DPI=100
    QT_WAYLAND_DISABLE_WINDOWDECORATION=1
    MOZ_ENABLE_WAYLAND=1

    export XDG_SESSION_TYPE
    export SDL_VIDEODRIVER
    export SWAYROOT
    export ECORE_EVAS_ENGINE
    export ELM_DISPLAY
    export ELM_ENGINE
    export ELM_ACCEL
    export QT_QPA_PLATFORM
    export QT_WAYLAND_FORCE_DPI
    export QT_WAYLAND_DISABLE_WINDOWDECORATION
    export MOZ_ENABLE_WAYLAND
}

_exports_for_x11 () {
    _common_exports

    XDG_SESSION_TYPE="x11"
    SDL_VIDEODRIVER="x11"
    I3ROOT="${XDG_CONFIG_HOME:-${HOME}/.config}/i3"

    export XDG_SESSION_TYPE
    export SDL_VIDEODRIVER
    export I3ROOT

    unset ECORE_EVAS_ENGINE
    unset ELM_DISPLAY
    unset ELM_ENGINE
    unset ELM_ACCEL
    unset QT_QPA_PLATFORM
    unset QT_WAYLAND_FORCE_DPI
    unset QT_WAYLAND_DISABLE_WINDOWDECORATION
    unset MOZ_ENABLE_WAYLAND
}
_select_x11_manager() {
    echo "Window managers:"
    ls "/usr/share/xsessions"
    read x11wm && echo "${x11wm}" > "${HOME}/.xinitrc" && unset x11wm
}

if [ "$(tty)" = "/dev/tty1" ]; then
    if builtin command -v sway 2>&1 > /dev/null; then
        if sway --validate; then
            _exports_for_sway
            exec dbus-launch --sh-syntax --exit-with-session sway
        else
            echo "Error while validating sway configuration"
        fi
    else
        _exports_for_x11
        _select_x11_manager
        exec startx
    fi
elif [ "$(tty)" = "/dev/tty2" ]; then
    _exports_for_x11
    _select_x11_manager
    exec startx
elif [ "$TERM" = "linux" ]; then
    printf "\e]P0000000" #black
    printf "\e]P83f3f3f" #darkgrey
    printf "\e]P19f3f3f" #darkred
    printf "\e]P9ff9f9f" #red
    printf "\e]P23f9f3f" #darkgreen
    printf "\e]PAbfefbf" #green
    printf "\e]P3bf9f3f" #brown
    printf "\e]PB9fff9f" #yellow
    printf "\e]P45f5f9f" #darkblue
    printf "\e]PC9f9fff" #blue
    printf "\e]P59f3f9f" #darkmagenta
    printf "\e]PDff9fff" #magenta
    printf "\e]P63f9f9f" #darkcyan
    printf "\e]PE9fffff" #cyan
    printf "\e]P7afafaf" #lightgrey
    printf "\e]PFffffff" #white
    clear #for background artifacting
fi

```

# Calls<a id="sec-"></a>

## bash<a id="sec-"></a>

```bash
# netcheck source=.local/share/pspman/src/runcom/ui
if [ -f "${RUNCOMDIR:-${HOME}/.runcom}"/ui ]; then
    . "${RUNCOMDIR:-${HOME}/.runcom}"/ui
fi
```

## zsh<a id="sec-"></a>

```bash
# netcheck source=.local/share/pspman/src/runcom/ui
if [ -f "${RUNCOMDIR:-${HOME}/.runcom}"/ui ]; then
    . "${RUNCOMDIR:-${HOME}/.runcom}"/ui
fi
```
