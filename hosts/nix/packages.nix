{ pkgs, ... }:
with pkgs;
{
  home-manager.users.emileet.home.packages = [
    lunar-client
    xivlauncher
    (wrapOBS {
      plugins = with obs-studio-plugins; [
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
