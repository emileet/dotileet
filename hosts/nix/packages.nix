{ pkgs, pkgs-master, ... }:
with pkgs;
{
  home-manager.users.emileet.home.packages = [
    pkgs-master.xivlauncher
    pkgs-master.fflogs
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
