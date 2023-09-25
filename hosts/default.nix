{ nixpkgs, impermanence, font-sf-mono, ... }:
let
  pkgs = (import ../pkgs { inherit font-sf-mono; });
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
