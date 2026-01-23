# Justfile for dotfiles management
# Run `just` or `just --list` to see available commands

default:
    @just --list

diff:
    chezmoi diff

update:
    chezmoi update

update-externals:
    chezmoi apply ~/.externals

list-managed:
    chezmoi managed

state:
    chezmoi status

# Bootstrap fresh system (1Password + chezmoi)
bootstrap:
    ./bootstrap.sh

pre-commit-install:
    prek install --hook-type commit-msg
    prek install

# Run pre-commit hooks manually
pre-commit:
    prek run --all-files

# Sync SSH public keys from 1Password
sync-ssh-keys:
    ~/.local/share/chezmoi/.chezmoiscripts/run_onchange_before_sync-ssh-keys-from-1password.sh.tmpl

# vim: set ft=just :
