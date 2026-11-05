# My dotfiles, managed by [chezmoi](https://github.com/twpayne/chezmoi)

Companion repository for my workstations living at [ansible-workstations-fedora](https://github.com/gorschu/ansible-workstations-fedora).

## What we try to achieve

- be as distribution/OS-agnostic as practical. Chezmoi manages dotfiles and Homebrew bundles;
  the companion Ansible repository manages Fedora system packages, and
  [mise](https://mise.jdx.dev/) provides repository tooling.
- be as declarative as possible. This can't be nix nor home-manager, but on the bright side -
  we don't have to be as straight as nix and can keep our day job.

## Joplin terminal client

`Brewfile.pim` installs `joplin-cli` and `todoman` on hosts with `has_pim`.
It replaces `Brewfile.mail`; chezmoi removes the obsolete generated file.
On personal Linux machines with `has_pim`,
the Joplin script runs after Homebrew when its configuration changes. It imports
only the server connection settings into the CLI's default profile. Initial sync
and E2EE unlocking remain manual:

```sh
joplin sync
joplin e2ee decrypt
```

Use the second command only if the account uses E2EE, with the existing master
password. Keep the CLI profile separate from the desktop profile.

Edit the everyday sync account privately with
`chezmoi edit-encrypted secrets/joplin.toml.asc` from the source checkout.
The encrypted file contains `accounts.personal` with `url`, `email`, and
`password`; the master password and Joplin database are not managed by chezmoi.
The script decrypts at execution time and passes JSON through stdin, keeping
credentials out of rendered scripts and process arguments. Empty credentials
or a URL without HTTPS stop configuration before Joplin runs.
