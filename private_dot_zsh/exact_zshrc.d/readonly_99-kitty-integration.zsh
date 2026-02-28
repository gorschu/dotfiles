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
    alias ssh="kitty +kitten ssh"

    # Inside tmux, OSC 7 hits tmux's PTY and never reaches Kitty.
    # Wrap it in DCS passthrough so Kitty can track cwd for new_*_with_cwd.
    if [[ -n "$TMUX" ]]; then
        _kitty_tmux_report_pwd() {
            printf '\ePtmux;\e\e]7;kitty-shell-cwd://%s%s\a\e\\' "$HOST" "$PWD"
        }
        add-zsh-hook chpwd _kitty_tmux_report_pwd
        add-zsh-hook precmd _kitty_tmux_report_pwd
    fi
fi
