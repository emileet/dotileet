{
  description = ".dotileet - emileet's nixos systems";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";

    impermanence = {
      url = "github:nix-community/impermanence";
      flake = false;
    };

    font-sf-mono = {
      url = "github:shaunsingh/SFMono-Nerd-Font-Ligaturized";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, impermanence, font-sf-mono }: {
    nixosConfigurations = (import ./hosts {
      inherit (nixpkgs) lib;
      inherit nixpkgs impermanence font-sf-mono;
    });
  };
}
