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
    gnupg.agent = {
      enableSSHSupport = true;
      enable = true;
    };

    neovim = {
      defaultEditor = true;
      enable = true;
    };

    firefox.enable = true;
    thunar.enable = true;
    nix-ld.enable = true;
    dconf.enable = true;
    mtr.enable = true;
  };
}
