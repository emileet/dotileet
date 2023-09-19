{ nixpkgs, impermanence, font-sf-mono, ... }:
let
  overlays = [
    (final: prev: {
      sf-mono-liga = prev.stdenvNoCC.mkDerivation rec {
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
  ];

  sharedModules = [
    { nixpkgs.overlays = overlays; }
    "${impermanence}/nixos.nix"
  ];

  lib = nixpkgs.lib;
in
{
  nix = lib.nixosSystem {
    system = "x86_64-linux";
    modules = sharedModules ++ [
      ./nix
    ];
  };
}
