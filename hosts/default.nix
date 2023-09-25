{ nixpkgs, impermanence, font-sf-mono, src-kvmfr, src-vban, src-ndi, ... }:
let
  pkgs = (import ../pkgs { inherit font-sf-mono src-kvmfr src-vban src-ndi; });
  lib = nixpkgs.lib;
  sharedModules = [
    "${impermanence}/nixos.nix"
    pkgs
  ];
in
{
  nix = lib.nixosSystem {
    system = "x86_64-linux";
    modules = sharedModules ++ [
      ./nix
    ];
  };
}
