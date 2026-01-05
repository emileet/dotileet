{ pkgs, ... }:
with pkgs;
{
  home-manager.users.emileet.home.packages = [
    master.xivlauncher
    master.fflogs
    (lutris.override {
      extraPkgs = pkgs: [
        wineWowPackages.stable
        gamemode
        mangohud
      ];
    })
    (wrapOBS {
      plugins = with obs-studio-plugins; [
        obs-vkcapture-kms
        obs-distroav
      ];
    })
  ];

  environment.systemPackages = [
    pavucontrol
    qjackctl
    openrgb
    vban
  ];

  services.udev.packages = [
    openrgb
  ];
}
