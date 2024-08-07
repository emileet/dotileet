{ nixpkgs, nixpkgs-master, impermanence, home-manager, font-sf-mono, src-vkcapture, src-kvmfr, src-vban, src-ndi, ... }:
let
  pkgs = (import ../pkgs { inherit font-sf-mono src-vkcapture src-kvmfr src-vban src-ndi; });
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
  nix = lib.nixosSystem rec {
    system = "x86_64-linux";
    modules = [ ./nix ] ++ sharedModules;
    specialArgs = {
      pkgs-master = import nixpkgs-master {
        config.allowUnfree = true;
        inherit system;
      };
    };
  };
}
