# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists. The default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#   umask 022

# ---------------------------------------------------------------------------- #
#   Lokalne funkcje dla ułatwienia życia
# ---------------------------------------------------------------------------- #

# Dodawanie katalogu do ścieżki uruchomieniowej PATH
add_to_path () {
    if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
        PATH="${PATH:+"$PATH:"}$1"
    fi
}

# Implementowanie zewnętrznego kodu, jeśli istnieje
include () {
  [[ -f "$1" ]] && source "$1"
}

# Konwersja formatu (np. 1M) na wartość w bajtach
to_bytes() { numfmt --from=auto $1; }

# Rozpakowanie dowolnego pliku
ex () {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xjf $1   ;;
            *.tar.gz)    tar xzf $1   ;;
            *.bz2)       bunzip2 $1   ;;
            *.rar)       unrar x $1   ;;
            *.gz)        gunzip $1    ;;
            *.tar)       tar xf $1    ;;
            *.tbz2)      tar xjf $1   ;;
            *.tgz)       tar xzf $1   ;;
            *.zip)       unzip $1     ;;
            *.Z)         uncompress $1;;
            *.7z)        7z x $1      ;;
            *)           echo "'$1' nie może być rozpakowany używając ex()" ;;
        esac
    else
        echo "'$1' nie jest prawidłowym plikiem"
    fi
}

# FUNKCJA: Dokumentacja z kolorową składnią
# https://wiki.archlinux.org/index.php/Man_page
man () {
    env LESS_TERMCAP_mb=$'\E[01;31m' \
    LESS_TERMCAP_md=$'\E[01;38;5;74m' \
    LESS_TERMCAP_me=$'\E[0m' \
    LESS_TERMCAP_se=$'\E[0m' \
    LESS_TERMCAP_so=$'\E[38;5;246m' \
    LESS_TERMCAP_ue=$'\E[0m' \
    LESS_TERMCAP_us=$'\E[04;38;5;146m' \
    man "$@"
}


# ---------------------------------------------------------------------------- #
#   Inicjalizacja
# ---------------------------------------------------------------------------- #

# Zacznij od załadowania istniejących już skryptów uruchomieniowych
include /etc/bashrc
include "$HOME"/.bashrc
include "$XDG_CONFIG_HOME"/bash/rc

# Klasyczne ścieżki dla plików wykonywalnych
add_to_path "$HOME"/bin
add_to_path "$HOME"/.local/bin


# ---------------------------------------------------------------------------- #
#   Standard XDG
# ---------------------------------------------------------------------------- #
# Dokumentacja: http://standards.freedesktop.org/basedir-spec/basedir-spec-latest.html

if [[ -z "$XDG_DATA_HOME" ]]; then export XDG_DATA_HOME="$HOME/.local/share"; fi
if [[ -z "$XDG_BIN_HOME" ]]; then export XDG_BIN_HOME="$HOME/.local/bin"; fi
if [[ -z "$XDG_CONFIG_HOME" ]]; then export XDG_CONFIG_HOME="$HOME/.config"; fi
if [[ -z "$XDG_CACHE_HOME" ]]; then export XDG_CACHE_HOME="$HOME/.cache"; fi
if [[ -z "$XDG_STATE_HOME" ]]; then export XDG_STATE_HOME="$HOME/.local/state"; fi
if [[ -z "$XDG_DATA_DIRS" ]]; then export XDG_DATA_DIRS="/usr/local/share:/usr/share"; fi

# Przykladowe sytuacje, gdzie brak definicji mnie ujebal:
# - Sterownik NVIDII tworzy katalog ~/.nv gdy XDG_CACHE_HOME nie jest okreslony.
# - Rustup instaluje się w katalogu domowym, gdy XDG_DATA_HOME nie jest okreslony.


# ---------------------------------------------------------------------------- #
#   Nvidia OpenGL
# ---------------------------------------------------------------------------- #
# Dokumentacja: https://download.nvidia.com/XFree86/Linux-x86_64/470.63.01/README/openglenvvariables.html

# OpenGL Shader Disk Cache
export __GL_SHADER_DISK_CACHE=1
export __GL_SHADER_DISK_CACHE_PATH="$XDG_CACHE_HOME"/nvidia/GLCache

export __GL_SHADER_DISK_CACHE_SKIP_CLEANUP=1 # Wyłączanie automatycznego czyszczenia cache
# Źródło: https://forums.developer.nvidia.com/t/opengl-shader-disk-cache-max-size-garbage-collection/60056
# Cytaty od pracownika NVIDII:
#   - The shader cache size is a (soft) maximum of 128MB.
#   - __GL_SHADER_DISK_CACHE_SKIP_CLEANUP=1 should remove all limitations to
#     shader cache size and that should work on most currently released drivers.

# Threaded Optimizations
export __GL_THREADED_OPTIMIZATIONS=1
# "might cause a decrease of performance in applications that heavily
#  rely on synchronous OpenGL calls such as glGet*"

# G-SYNC
export __GL_VRR_ALLOWED=1
export __GL_SYNC_TO_VBLANK=1

# Unofficial GLX protocol
export __GL_ALLOW_UNOFFICIAL_PROTOCOL=1 # Zezwala na protokoły w wersji Alpha

# OpenGL yield behavior
export __GL_YIELD="NOTHING" # Znaczny wzrost FPSów podczas testów, ale może powodować problemy


# ---------------------------------------------------------------------------- #
#   Nvidia CUDA
# ---------------------------------------------------------------------------- #
# Dokumentacja: https://docs.nvidia.com/cuda/cuda-c-programming-guide/index.html#env-vars

#export CUDA_CACHE_DISABLE=1 # Wyłącza cache CUDA
export CUDA_CACHE_MAXSIZE=$(to_bytes 2Gi) # Domyślnie: 256 Mi, Max: 4Gi
export CUDA_CACHE_PATH="$XDG_CACHE_HOME"/nvidia/ComputeCache # Domyślnie: ~/.nv/ComputeCache

#nvidia-settings --config="$XDG_CONFIG_HOME"/nvidia/settings


# ---------------------------------------------------------------------------- #
#   Aliasy
# ---------------------------------------------------------------------------- #

alias ll='ls --almost-all --color --format=verbose --human-readable --literal --time-style=long-iso'
alias ls='ls --color=auto -A'
alias grep='grep --color=auto'
alias fgrep="fgrep --color=auto"
alias egrep="egrep --color=auto"
alias less="less -R"
alias ..='cd ..'


# ---------------------------------------------------------------------------- #
#   Rust
# ---------------------------------------------------------------------------- #

# Rustup
export RUSTUP_HOME="$XDG_DATA_HOME"/rustup

# Cargo
export CARGO_HOME="$XDG_DATA_HOME"/cargo
export CARGO_BIN_DIR="$XDG_BIN_HOME"
export CARGO_CACHE_DIR="$XDG_CACHE_HOME"/cargo
export CARGO_CONFIG_DIR="$XDG_CONFIG_HOME"/cargo
add_to_path "$CARGO_HOME"/bin


# ---------------------------------------------------------------------------- #
#   JavaScript
# ---------------------------------------------------------------------------- #

# Deno
export DENO_INSTALL="/home/tiritto/.deno"
add_to_path "$DENO_INSTALL"/bin


# ---------------------------------------------------------------------------- #
#   Standard XDG - Wymuszanie użycia prawidłowych ścieżek
# ---------------------------------------------------------------------------- #

# Pliki GnuPG
export GNUPGHOME="$XDG_DATA_HOME"/gnupg

# Lokalizacja historii (Bash)
#export HISTFILE="$XDG_CACHE_HOME"/bash/history
export HISTFILE="$XDG_STATE_HOME"/bash/history # Rekomendowane przez Arch wiki

# Java / OpenJDK
export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="$XDG_CONFIG_HOME"/java

# KDE
export KDEHOME="$XDG_CONFIG_HOME"/kde

# FFMPEG
export FFMPEG_DATADIR="$XDG_CONFIG_HOME"/ffmpeg

# Docker
export DOCKER_CONFIG="$XDG_CONFIG_HOME"/docker

# Anaconda (Python)
export CONDARC="$XDG_CONFIG_HOME/conda/condarc"

# wget (wymaga dodatkowego aliasu, aby działał prawidłowo)
export WGETRC="$XDG_CONFIG_HOME/wgetrc"
alias wget="wget --hsts-file=$XDG_CACHE_HOME/wget-hsts"

# Visual Studio Code
export VSCODE_PORTABLE="$XDG_DATA_HOME"/vscode


# ---------------------------------------------------------------------------- #
#   Pozostałe
# ---------------------------------------------------------------------------- #

# Style graficzne dla środowisk Qt
#export QT_STYLE_OVERRIDE=kvantum # Nie potrzebne podczas używania qt5ct
export QT_QPA_PLATFORMTHEME=qt5ct

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# Wyłączenie Telemetrii .NET
export DOTNET_CLI_TELEMETRY_OPTOUT=1
