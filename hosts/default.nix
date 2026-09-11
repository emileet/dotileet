{ inputs, ... }:
let
  registry.nix.registry.nixpkgs.flake = inputs.nixpkgs;

  home.home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users.emileet = import ../home;
    useGlobalPkgs = true;
  };

  pkgs = (import ../pkgs { inherit inputs; });

  sharedModules = (import ../modules) ++ [
    inputs.nix-index-database.nixosModules.nix-index
    inputs.impermanence.nixosModules.impermanence
    inputs.home-manager.nixosModules.home-manager
    inputs.silent-sddm.nixosModules.default
    registry
    home
    pkgs
  ];

  mkHost =
    hostPath:
    inputs.nixpkgs.lib.nixosSystem {
      modules = sharedModules ++ [ hostPath ];
    };
in
{
  nix = mkHost ./nix;
  nixsrv = mkHost ./nixsrv;
  shodan = mkHost ./shodan;
}
