{ pkgs, ... }:
with pkgs;
{
  home-manager.users.emileet.home.packages = [
    (wrapOBS {
      plugins = with obs-studio-plugins; [
        (callPackage ../../pkgs/kvmfr-obs { })
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
