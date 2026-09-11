{
  lib,
  pkgs,
  osConfig,
  ...
}:
with pkgs;
with lib;
let
  graphical = osConfig.programs.hyprland.enable || osConfig.services.xserver.enable;
in
{
  home = {
    sessionVariables.NIXPKGS_ALLOW_UNFREE = 1;
    packages = mkMerge [
      (mkIf graphical [
        qt6Packages.qt6ct
        moonlight-qt
        easyeffects
        qbittorrent
        libnotify
        flameshot
        shotwell
        wezterm
        dunst
        rofi
        vlc
        master.spicetify-cli
        master.vscode.fhs
        master.vesktop
      ])
      [
        ripgrep
        hyfetch
        bottom
        nixfmt
        direnv
        p7zip
        unzip
        file
        tldr
        git
        nil
        jq
      ]
    ];
  };
}
