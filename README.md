# My dotfiles, managed by [chezmoi](https://github.com/twpayne/chezmoi)

Companion repository for my workstations living at [ansible-workstations-fedora](https://github.com/gorschu/ansible-workstations-fedora).

## What we try to achieve

- be as distribution/OS-agnostic as practical. Chezmoi manages dotfiles and Homebrew bundles;
  the companion Ansible repository manages Fedora system packages, and
  [mise](https://mise.jdx.dev/) provides repository tooling and global userland tools.
  During `chezmoi apply`, the Homebrew bundle installs mise and uv first, then
  a separate script installs missing tools declared in `~/.config/mise/config.toml`.
- be as declarative as possible. This can't be nix nor home-manager, but on the bright side -
  we don't have to be as straight as nix and can keep our day job.
