{ pkgs, pkgs-be, ... }:
with pkgs;
{
  home-manager.users.emileet.home.packages = [
    pkgs-be.xivlauncher
    pkgs-be.fflogs
    (wrapOBS {
      plugins = with obs-studio-plugins; [
        obs-vkcapture-kms
        obs-kvmfr
        obs-ndi
      ];
    })
  ];

  environment.systemPackages = [
    pavucontrol
    liquidctl
    qjackctl
    openrgb
    mdadm
    vban
  ];

  services.udev.packages = [
    openrgb
  ];
}
