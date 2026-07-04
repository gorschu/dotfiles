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
    @bash -euo pipefail -c ' \
      source ./bootstrap/00-bootstrap-lib.sh; \
      os="$(detect_os)"; \
      script="./bootstrap/00-bootstrap-${os}.sh"; \
      if [[ ! -x "$script" ]]; then \
        echo "ERROR: Unsupported OS: $os ($script not found or not executable)" >&2; \
        exit 1; \
      fi; \
      exec "$script" \
    '

pre-commit-install:
    prek install --hook-type commit-msg
    prek install

# Run pre-commit hooks manually
pre-commit:
    prek run --all-files

# Sync SSH public keys from 1Password
sync-ssh-keys:
    chezmoi execute-template < \
      ~/.local/share/chezmoi/.chezmoiscripts/run_after_00-sync-ssh-keys-from-1password.sh.tmpl | bash

# vim: set ft=just :
