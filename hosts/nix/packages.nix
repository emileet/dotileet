{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    virt-manager
    liquidctl
    qjackctl
    openrgb
    mdadm
    vban
  ];

  users.users.emileet.packages = with pkgs; [
    (wrapOBS {
      plugins = with obs-studio-plugins; [
        (callPackage ../../pkgs/kvmfr-obs { })
        obs-ndi
      ];
    })
  ];

  services.udev.packages = with pkgs; [
    openrgb
  ];

  programs = {
    thunar.enable = true;
    nix-ld.enable = true;
    dconf.enable = true;
    mtr.enable = true;

    zsh = {
      shellAliases = {
        update = "sudo nixos-rebuild switch";
      };
      enable = true;
    };

    gnupg.agent = {
      enableSSHSupport = true;
      enable = true;
    };

    neovim = {
      defaultEditor = true;
      enable = true;
    };
  };
}
