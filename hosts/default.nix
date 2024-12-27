{ nixpkgs, nixpkgs-master, impermanence, home-manager, font-sf-mono, src-vkcapture, src-kvmfr, src-vban, ... }:
let
  pkgs = (import ../pkgs { inherit nixpkgs-master font-sf-mono src-vkcapture src-kvmfr src-vban; });
  home = {
    home-manager.users.emileet = import ../home;
    home-manager.useGlobalPkgs = true;
  };

  sharedModules = (import ../modules) ++ [
    impermanence.nixosModule
    home-manager.nixosModule
    home
    pkgs
  ];

  lib = nixpkgs.lib;
in
{
  nix = lib.nixosSystem {
    system = "x86_64-linux";
    modules = [ ./nix ] ++ sharedModules;
  };
}
