{ pkgs, mylib, ... }:

let
  iosevkaVersion = "34.6.1";
in
{
  home.packages = (with pkgs; [
    adwaita-fonts
    dejavu_fonts
    ibm-plex                       # covers ibm-plex-sans + ibm-plex-mono
    jetbrains-mono
    libertinus
    monaspace                      # covers monaspace-frozen + monaspace-var
    source-code-pro
    source-sans
    source-serif
    nerd-fonts.symbols-only
  ]) ++ [
    # Prebuilt Iosevka variants from upstream releases.
    # Add more (IosevkaSlab, IosevkaCurly, IosevkaAile, etc.) by repeating
    # the call with the right `variant` and a fresh hash.
    (mylib.iosevkaVariant {
      variant = "Iosevka";
      version = iosevkaVersion;
      hash = "sha256-BYWPAUY1EeDdbNzgl/ZGBO50TVUFS3XLmMvC/FQfG5U=";
    })
    (mylib.iosevkaVariant {
      variant = "IosevkaTerm";
      pkgPrefix = "PkgTTC-SGr-";
      version = iosevkaVersion;
      hash = "sha256-OxjV41rXMzp9PSTQeBrQIg71lyIgVGGsogbvDN+l8i0=";
    })
  ];
}
