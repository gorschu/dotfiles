# System Setup with Ansible

Role-based Ansible playbook for traditional Fedora Workstation. Mirrors the blue-build Silverblue configuration exactly.

## Structure

```
system-ansible/
├── local.yml           # Main playbook
├── ansible.cfg         # Ansible configuration
├── inventory.ini       # Localhost inventory
└── roles/
    ├── base/           # Repositories, system utilities, CLI tools
    ├── multimedia/     # Codecs and hardware acceleration
    ├── desktop/        # GUI applications and Flatpaks
    └── hyprland/       # Hyprland window manager ecosystem
```

## Prerequisites

```bash
# Install Ansible
sudo dnf install -y ansible

# Install required Ansible collections
ansible-galaxy collection install community.general
```

## Usage

### Full system setup

```bash
cd system-ansible
ansible-playbook local.yml --ask-become-pass
```

### Run specific roles

```bash
# Only base (repos + system utilities + CLI tools)
ansible-playbook local.yml --tags base -K

# Base + multimedia codecs
ansible-playbook local.yml --tags base,multimedia -K

# Only desktop applications
ansible-playbook local.yml --tags desktop -K

# Only Hyprland ecosystem
ansible-playbook local.yml --tags hyprland -K
```

## Roles

### base
- RPM Fusion (free + nonfree)
- COPR repos (hyprland, wezterm, ghostty)
- Third-party repos (scootersoftware, zrepl)
- System utilities (gdisk, parted, btrbk, zrepl)
- CLI tools (fzf, ripgrep, bat, neovim, etc.)
- Networking tools

### multimedia
- Full ffmpeg (replaces ffmpeg-free)
- GStreamer freeworld plugins
- Hardware acceleration (mesa-freeworld, libva)

### desktop
- GUI applications (firefox, kitty, wezterm, ghostty, etc.)
- Flatpaks (Chrome, Vivaldi, VueScan, Solaar, Shortwave)

### hyprland
- Hyprland window manager
- Wayland ecosystem (waybar, mako, fuzzel, etc.)
- Hyprland plugins and utilities

## Workflow

On a fresh Fedora Workstation install:

```bash
# 1. Bootstrap (installs 1Password + chezmoi)
bash <(curl -fsSL https://raw.githubusercontent.com/gorschu/dotfiles/main/bootstrap.sh)

# 2. Sign in to 1Password
op signin  # or use GUI

# 3. Apply dotfiles
chezmoi init --apply https://github.com/gorschu/dotfiles

# 4. Run system setup
cd ~/.local/share/chezmoi/system-ansible
ansible-playbook local.yml -K
```

## Notes

- All roles are idempotent - safe to run multiple times
- Tags allow granular control of what gets installed
- User-space configuration (services, dotfiles) is handled by chezmoi
- Mirrors the blue-build Silverblue image exactly
