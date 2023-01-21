# Ensure path arrays do not contain duplicates.
typeset -gU cdpath fpath mailpath path

# Set the the list of directories that cd searches.
# cdpath=(
#   $cdpath
# )

# Set the list of directories that Zsh searches for programs.
path=(
    ${HOME}/.local/bin
    ${HOME}/.cargo/bin
    ${HOME}/bin
    ${HOME}/bin/**
    ${HOME}/go/bin
    ${path}
    /usr/local/{bin,sbin}
)
# ... then remove those that are either dead links (-/) or do not
# exist at all (N) and apply that to all in array (^) source:
# http://stackoverflow.com/a/9352979/1469693
path=($^path(-/N))

# ruby is ... kind of annoying
if which ruby >/dev/null && which gem >/dev/null; then
    PATH="$(ruby -e "puts Gem.user_dir")/bin:$PATH"
fi

# pyenv
[[ -d $HOME/.pyenv ]] && PATH="$HOME/.pyenv/bin:$PATH"

# inject path into systemctl user session so things like emacs have it available
systemctl --user import-environment PATH
