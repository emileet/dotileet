lib: pkgs: osConfig:
with lib;
with pkgs;
let
  graphical = osConfig.services.xserver.enable;
in
mkMerge [
  (mkIf graphical [
    qt6Packages.qt6ct
    lxappearance
    libnotify
    flameshot
    shotwell
    deskflow
    wezterm
    dunst
    slack
    vlc
    master.spicetify-cli
    master.vscode.fhs
    master.vesktop
  ])
  ([
    hyfetch
    bottom
    nixfmt
    direnv
    p7zip
    unzip
    file
    tldr
    eza
    git
    nil
  ])
]
