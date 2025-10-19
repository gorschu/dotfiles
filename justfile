# Justfile for dotfiles management and system setup
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

# Run full Ansible system setup
ansible-setup:
    #!/bin/bash
    HOSTNAME=$(chezmoi data --format=json | jq -r '.chezmoi.hostname')
    cd system-ansible && ansible-playbook local.yml \
      --vault-password-file <(op read "op://Ansible/Workstations/password") \
      --extra-vars @vault.yml \
      --extra-vars "hostname=$HOSTNAME" \
      --ask-become-pass

# Run Ansible with specific tags (e.g., just ansible-tags base,multimedia)
ansible-tags TAGS:
    #!/bin/bash
    HOSTNAME=$(chezmoi data --format=json | jq -r '.chezmoi.hostname')
    cd system-ansible && ansible-playbook local.yml \
      --vault-password-file <(op read "op://Ansible/Workstations/password") \
      --extra-vars @vault.yml \
      --extra-vars "hostname=$HOSTNAME" \
      --tags {{TAGS}} \
      --ask-become-pass

# Lint Ansible playbook
ansible-lint:
    cd system-ansible && ansible-lint

# Check Ansible syntax
ansible-check:
    cd system-ansible && ansible-playbook local.yml --syntax-check

# Run Ansible in check mode (dry-run)
ansible-dry-run:
    #!/bin/bash
    HOSTNAME=$(chezmoi data --format=json | jq -r '.chezmoi.hostname')
    cd system-ansible && ansible-playbook local.yml \
      --vault-password-file <(op read "op://Ansible/Workstations/password") \
      --extra-vars @vault.yml \
      --extra-vars "hostname=$HOSTNAME" \
      --check \
      --ask-become-pass

# Install Ansible and required collections
ansible-install:
    sudo dnf install -y ansible
    ansible-galaxy collection install -r system-ansible/requirements.yml

# Bootstrap fresh system (1Password + chezmoi)
bootstrap:
    ./bootstrap.sh

# Full fresh system setup (bootstrap → apply → ansible)
setup-all:
    @echo "This will run the full setup. Make sure you've:"
    @echo "  1. Signed in to 1Password first"
    @echo "  2. Installed Ansible (run: just ansible-install)"
    @echo ""
    @read -p "Continue? (y/N) " -n 1 -r && echo && [[ $$REPLY =~ ^[Yy]$ ]] || exit 1
    @echo "Applying dotfiles..."
    ./apply.sh
    @echo ""
    @echo "Running Ansible system setup..."
    cd system-ansible && ansible-playbook local.yml --ask-become-pass

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
