{ pkgs, ... }:

{
  # Atuin: HM owns ~/.config/atuin/config.toml and the systemd user daemon.
  # Shell integration is still done by chezmoi (.zshrc.d/92-atuin-init.zsh),
  # so all enable*Integration options stay off here to avoid double-binding.
  programs.atuin = {
    enable = true;
    daemon.enable = true;
    enableBashIntegration = false;
    enableFishIntegration = false;
    enableNushellIntegration = false;
    enableZshIntegration = false;
    settings = {
      auto_sync = true;
      update_check = true;
      sync_frequency = "10m";
      search_mode = "daemon-fuzzy";
      workspaces = true;
      style = "auto";
      inline_height = 35;
      show_preview = true;
      show_help = true;
      secrets_filter = true;
      enter_accept = true;
      keymap_mode = "vim-insert";
      sync.records = true;
      search.filters = [ "workspace" "global" "host" "session" "directory" ];
      tmux.enabled = true;
    };
  };

  home.packages = with pkgs; [
    bat
    bat-extras.batdiff
    bat-extras.batgrep
    bat-extras.batman
    bat-extras.batpipe
    bat-extras.batwatch
    bat-extras.prettybat
    btop
    clipboard-jh                   # brew: clipboard
    dust
    eza
    fastfetch
    fd
    fzf
    gdu
    lazydocker
    pandoc
    rclone
    renameutils
    restic
    ripgrep
    starship
    trash-cli
    tmux
    topgrade
    vivid
    yazi
    zellij
    zoxide
  ];
}
