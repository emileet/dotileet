{ inputs, ... }:
let
  revVersion = input: "rev-${input.shortRev or (builtins.substring 0 7 input.rev)}";
in
(final: prev: {
  obs-kvmfr = prev.callPackage ../include/kvmfr/obs { };
  obs-distroav = prev.callPackage ../include/distroav {
    version = revVersion inputs.src-distroav;
    inherit (inputs) src-distroav;
  };

  wave3-daemon = prev.callPackage ../include/wave3-daemon { };
  vban = prev.callPackage ../include/vban {
    version = revVersion inputs.src-vban;
    inherit (inputs) src-vban;
  };

  sf-mono-liga = prev.stdenvNoCC.mkDerivation {
    version = revVersion inputs.font-sf-mono;
    pname = "sf-mono-liga";
    src = inputs.font-sf-mono;
    dontConfigure = true;
    installPhase = ''
      mkdir -p $out/share/fonts/opentype
      cp -R $src/*.otf $out/share/fonts/opentype/
    '';
  };
})
