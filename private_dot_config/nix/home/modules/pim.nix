{ pkgs, ... }:

{
  home.packages = with pkgs; [
    khal
    khard
    todoman
  ];

  services.vdirsyncer = {
    enable = true;
    frequency = "*:0/15";          # every 15 minutes
  };

  # Carry over the brew-managed quirks:
  # - ConditionPathExists so the unit no-ops without a config.
  # - ExecStartPre runs discover before every sync. Idempotent when the
  #   cache exists; populates it on first run.
  systemd.user.services.vdirsyncer = {
    Unit.ConditionPathExists = "%h/.config/vdirsyncer/config";
    Service.ExecStartPre = [
      "${pkgs.vdirsyncer}/bin/vdirsyncer -v ERROR discover tasks_fastmail calendar_fastmail contacts_fastmail"
    ];
  };
}
