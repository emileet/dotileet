{
  description = ".dotileet - emileet's nixos systems";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs";
    nixpkgs-stable.url = "github:nixos/nixpkgs/ea30586ee015f37f38783006a9bc9e4aa64d7d61"; # not the stable branch, but a commit that's stable enough for me

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

    src-distroav = {
      url = "github:DistroAV/DistroAV";
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

    src-ndi = {
      url = "https://downloads.ndi.tv/SDK/NDI_SDK_Linux/Install_NDI_SDK_v6_Linux.tar.gz";
      flake = false;
    };
  };

  outputs =
    args@{
      self,
      nixpkgs,
      nixpkgs-master,
      nixpkgs-stable,
      impermanence,
      home-manager,
      font-sf-mono,
      src-vkcapture,
      src-distroav,
      src-kvmfr,
      src-vban,
      src-ndi,
    }:
    {
      nixosConfigurations = (import ./hosts args);
    };
}
