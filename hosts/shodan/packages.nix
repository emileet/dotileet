{ pkgs, ... }:
with pkgs;
{
  home-manager.users.emileet.home.packages = [
    master.davinci-resolve-studio
    master.xivlauncher
    master.archon-lite
    pcsx2
    via
  ];

  environment.systemPackages = [
    gpu-screen-recorder-gtk
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
