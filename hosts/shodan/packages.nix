{ pkgs, ... }:
with pkgs;
{
  home-manager.users.emileet.home.packages = [
    master.xivlauncher
    master.fflogs
    (wrapOBS {
      plugins = with obs-studio-plugins; [
        obs-vkcapture-kms
        obs-distroav
      ];
    })
  ];

  environment.systemPackages = [
    pavucontrol
    cifs-utils
    qjackctl
    openrgb
    vban
  ];

  services.udev.packages = [
    openrgb
  ];
}
