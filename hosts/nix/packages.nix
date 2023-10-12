{ pkgs, ... }:
with pkgs;
{
  home-manager.users.emileet.home.packages = [
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
