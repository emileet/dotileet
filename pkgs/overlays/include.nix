font-sf-mono: src-vban: src-vkcapture: src-distroav:
(final: prev: {
  vban = prev.callPackage ../include/vban { inherit src-vban; };
  obs-vkcapture-kms = prev.callPackage ../include/vkcapture { inherit src-vkcapture; };
  obs-distroav = prev.callPackage ../include/distroav { inherit src-distroav; };
  obs-kvmfr = prev.callPackage ../include/kvmfr/obs { };
  sf-mono-liga = prev.stdenvNoCC.mkDerivation {
    pname = "sf-mono-liga";
    version = "dev";
    src = font-sf-mono;
    dontConfigure = true;
    installPhase = ''
      mkdir -p $out/share/fonts/opentype
      cp -R $src/*.otf $out/share/fonts/opentype/
    '';
  };
})
