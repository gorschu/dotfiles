{ pkgs }:

rec {
  # Build a wrapper package that runs each executable through a nixGL command.
  # Uses symlinkJoin so share/, lib/, etc. (including .desktop files and icons)
  # carry through to the wrapper output, preserving launcher integration.
  #
  # nixGLBin: absolute path to the nixGL wrapper binary, e.g.
  #           "${pkgs.nixgl.nixGLIntel}/bin/nixGLIntel"
  # pkg:      the package to wrap
  nixGLWrapWith = nixGLBin: pkg: pkgs.symlinkJoin {
    name = "${pkg.name}-nixgl";
    paths = [ pkg ];
    # Inherit meta from the wrapped package so consumers like lib.getExe
    # work correctly. Pin mainProgram to the original pname so getExe
    # doesn't fall back to the wrapper's name (which has the -nixgl suffix).
    meta = pkg.meta // {
      mainProgram = pkg.meta.mainProgram or pkg.pname;
    };
    postBuild = ''
      # Wrap bin/* so exec goes through nixGL.
      for bin in "$out"/bin/*; do
        [ -L "$bin" ] || continue
        target=$(readlink -f "$bin")
        rm "$bin"
        printf '#!/bin/sh\nexec ${nixGLBin} "%s" "$@"\n' "$target" > "$bin"
        chmod +x "$bin"
      done

      # Rewrite original-pkg references in systemd unit, dbus service, and
      # .desktop files so they exec the wrapper. Without this, KDE / dbus
      # activation skips nixGL and the GUI app crashes on missing libGL.
      for d in share/systemd/user share/dbus-1/services share/applications; do
        [ -d "$out/$d" ] || continue
        for f in "$out/$d"/*; do
          [ -L "$f" ] || continue
          target=$(readlink -f "$f")
          rm "$f"
          sed "s|${pkg}|$out|g" "$target" > "$f"
        done
      done
    '';
  };

  # Default wrapper for Mesa GPUs (AMD + Intel iGPU/dGPU on Linux).
  # For Nvidia hosts, use nixGLWrapWith "${pkgs.nixgl.auto.nixGLNvidia}/bin/nixGLNvidia".
  nixGLWrap = nixGLWrapWith "${pkgs.nixgl.nixGLIntel}/bin/nixGLIntel";

  # Fetch a prebuilt Iosevka variant TTC bundle from the upstream releases.
  # Avoids the ~30 min source build that pkgs.iosevka requires.
  #
  # variant: upstream package name, e.g. "Iosevka", "IosevkaTerm",
  #          "IosevkaSlab", "IosevkaAile", "IosevkaCurly", "IosevkaEtoile".
  # pkgPrefix: upstream asset prefix. Base families ship as "PkgTTC-",
  #            Term-like variants (Term, TermSlab, TermCurly) ship as
  #            "PkgTTC-SGr-" because they use spaced-glyph rendering.
  # version: release tag without the leading "v"
  # hash:    sha256 of the unpacked zip. Set to pkgs.lib.fakeHash on first
  #          use; nix will print the real hash, paste it back.
  iosevkaVariant = {
    variant,
    pkgPrefix ? "PkgTTC-",
    version,
    hash,
  }: pkgs.stdenvNoCC.mkDerivation {
    pname = "iosevka-${pkgs.lib.toLower variant}";
    inherit version;
    src = pkgs.fetchzip {
      url = "https://github.com/be5invis/Iosevka/releases/download/v${version}/${pkgPrefix}${variant}-${version}.zip";
      inherit hash;
      stripRoot = false;
    };
    installPhase = ''
      runHook preInstall
      install -Dm644 *.ttc -t $out/share/fonts/truetype
      runHook postInstall
    '';
    meta = {
      description = "Iosevka ${variant} — prebuilt upstream TTC bundle";
      homepage = "https://github.com/be5invis/Iosevka";
      license = pkgs.lib.licenses.ofl;
      platforms = pkgs.lib.platforms.all;
    };
  };
}
