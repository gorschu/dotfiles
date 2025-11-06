# only run when on an interactive terminal
if [[ $- != *i* ]]; then
  return
fi

# https://sw.kovidgoyal.net/kitty/shell-integration/#shell-integration
# we need this manually since we first jump into bash as login-shell, then switch
if test -n "$KITTY_INSTALLATION_DIR"; then
    export KITTY_SHELL_INTEGRATION="enabled"
    autoload -Uz -- "$KITTY_INSTALLATION_DIR"/shell-integration/zsh/kitty-integration
    kitty-integration
    unfunction kitty-integration
fi
