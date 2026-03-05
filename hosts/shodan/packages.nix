{ pkgs, ... }:
with pkgs;
{
  home-manager.users.emileet.home.packages = [
    davinci-resolve-studio
    master.xivlauncher
    master.fflogs
    pcsx2
    rpcs3
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
