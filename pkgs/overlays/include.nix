font-sf-mono: src-vban: src-vkcapture:
(final: prev: {
  vban = prev.callPackage ../include/vban { inherit src-vban; };
  obs-vkcapture-kms = prev.callPackage ../include/vkcapture { inherit src-vkcapture; };
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
