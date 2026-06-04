{ pkgs, ... }:

{
  home.packages = with pkgs; [
    isync                          # mbsync
    msmtp
    neomutt
    notmuch
    par
    poppler-utils
    urlscan
    w3m
  ];
}
