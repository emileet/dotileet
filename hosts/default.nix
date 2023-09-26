{ nixpkgs, impermanence, font-sf-mono, src-kvmfr, src-vban, src-ndi, ... }:
let
  pkgs = (import ../pkgs { inherit font-sf-mono src-kvmfr src-vban src-ndi; });

  sharedModules = (import ../modules) ++ [
    "${impermanence}/nixos.nix"
    pkgs
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
