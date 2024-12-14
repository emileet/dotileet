{
  description = ".dotileet - emileet's nixos systems";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-be.url = "github:nixos/nixpkgs";

    impermanence.url = "github:nix-community/impermanence";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    font-sf-mono = {
      url = "github:shaunsingh/SFMono-Nerd-Font-Ligaturized";
      flake = false;
    };

    src-vkcapture = {
      url = "github:scaledteam/obs-vkcapture";
      flake = false;
    };

    src-kvmfr = {
      url = "git+https://github.com/gnif/LookingGlass?submodules=1";
      flake = false;
    };

    src-vban = {
      url = "git+https://github.com/quiniouben/vban?submodules=1";
      flake = false;
    };
  };

  outputs = args@{ self, nixpkgs, nixpkgs-be, impermanence, home-manager, font-sf-mono, src-vkcapture, src-kvmfr, src-vban }: {
    nixosConfigurations = (import ./hosts args);
  };
}
