{ inputs, ... }:
(final: prev: {
  obs-vkcapture-kms = prev.callPackage ../include/vkcapture { inherit (inputs) src-vkcapture; };
  obs-distroav = prev.callPackage ../include/distroav { inherit (inputs) src-distroav; };
  obs-kvmfr = prev.callPackage ../include/kvmfr/obs { };

  vban = prev.callPackage ../include/vban { inherit (inputs) src-vban; };
  wave3-daemon = prev.callPackage ../include/wave3-daemon { };

  sf-mono-liga = prev.stdenvNoCC.mkDerivation {
    pname = "sf-mono-liga";
    version = "dev";
    src = inputs.font-sf-mono;
    dontConfigure = true;
    installPhase = ''
      mkdir -p $out/share/fonts/opentype
      cp -R $src/*.otf $out/share/fonts/opentype/
    '';
  };
})
