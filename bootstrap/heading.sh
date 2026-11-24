#!/bin/sh
# Shared by bootstrap and chezmoi scripts, including the first apply.
heading="==> chezmoi · $1"
printf '\n' >&2

if [ -t 2 ] && [ -z "${NO_COLOR:-}" ] && [ "${TERM:-}" != dumb ]; then
    gum=$(command -v gum)
    if [ -z "$gum" ]; then
        brew_env="${XDG_CONFIG_HOME:-$HOME/.config}/homebrew/env"
        if [ -z "${HOMEBREW_PREFIX:-}" ] && [ -r "$brew_env" ]; then
            # shellcheck disable=SC1090
            . "$brew_env"
        fi
        gum=${HOMEBREW_PREFIX:+"${HOMEBREW_PREFIX}/bin/gum"}
    fi
    # Catppuccin Mocha base on mauve.
    if [ -x "$gum" ] && "$gum" style --bold --foreground '#1e1e2e' \
        --background '#cba6f7' --padding '0 1' "$heading" >&2; then
        printf '\n' >&2
        exit 0
    fi
fi

printf '%s\n\n' "$heading" >&2
