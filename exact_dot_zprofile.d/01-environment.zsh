# environment variables relevant for whole X-Session, not just shells

. /etc/zshenv

export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_CACHE_HOME="${HOME}/.cache"

# requires qt5ct (and settings there)
expr "$XDG_CURRENT_DESKTOP" : ".*KDE.*" 1>/dev/null || export QT_QPA_PLATFORMTHEME="qt5ct"

# set pinentry binary used
expr "$XDG_CURRENT_DESKTOP" : ".*KDE.*" 1>/dev/null && export PINENTRY_BINARY="/usr/bin/pinentry-qt"
expr "$XDG_CURRENT_DESKTOP" : ".*GNOME.*" 1>/dev/null && export PINENTRY_BINARY="/usr/bin/pinentry-gnome3"
[ -z "${PINENTRY_BINARY}" ] && export PINENTRY_BINARY='/usr/bin/pinentry-gtk-2'

# set SSH Variables
export SSH_AUTH_SOCK=${XDG_RUNTIME_DIR}/ssh-agent.socket
export SSH_ASKPASS=/usr/libexec/ssh/gnome-ssh-askpass

# use new freetype 2.7 default interpreter
export FREETYPE_PROPERTIES="truetype:interpreter-version=40"

export TMPDIR="/tmp/${USER}"

# Editors
export ALTERNATE_EDITOR=""

if command -v "nvim" >/dev/null; then
    export EDITOR="nvim"
    export GIT_EDITOR="nvim"
elif command -v "vim" >/dev/null; then
    export EDITOR="vim"
    export GIT_EDITOR="vim"
fi

export VISUAL='nvim'

# Real Misc
if command -v "bat" >/dev/null; then
    export MANPAGER="sh -c 'col -bx | bat -l man -p'"
    export MANROFFOPT="-c"
    export PAGER='bat'
else
    export PAGER='less'
fi

export PYGMENTIZE_STYLE="nord"

export PASSWORD_STORE_X_SELECTION="primary"
export PASSWORD_STORE_CLIP_TIME="60"
export PASSWORD_STORE_ENABLE_EXTENSIONS=true
# for openkeychain on android, hardened gpg config throws them away
export PASSWORD_STORE_GPG_OPTS='--no-throw-keyids'

# set GOPATH
export GOPATH="${HOME}/go"
# turn on Go Modules
export GO111MODULE=on

# virtualenv
export WORKON_HOME=$HOME/.cache/virtualenvs
export PROJECT_HOME=$HOME/projects

export LESS='-F -i -M -R -S -w -X -z-4'

# ls options
export TIME_STYLE=long-iso
export BLOCK_SIZE="'1"

export NOTMUCH_CONFIG=${XDG_CONFIG_HOME}/mail/notmuch-config

# Firefox (maybe only temporarily needed?)
# https://wiki.archlinux.org/index.php/Firefox#Hardware_video_acceleration
export MOZ_WEBRENDER=1
export MOZ_X11_EGL=1
