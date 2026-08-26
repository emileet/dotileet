{ inputs, ... }:
let
  home = {
    home-manager.users.emileet = import ../home;
    home-manager.useGlobalPkgs = true;
  };

  pkgs = (import ../pkgs { inherit inputs; });

  sharedModules = (import ../modules) ++ [
    inputs.nix-index-database.nixosModules.nix-index
    inputs.impermanence.nixosModules.impermanence
    inputs.home-manager.nixosModules.home-manager
    inputs.silent-sddm.nixosModules.default
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
