{ pkgs, ... }:
with pkgs;
{
  home-manager.users.emileet.home.packages = [
    master.xivlauncher
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
