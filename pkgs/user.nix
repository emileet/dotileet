lib: pkgs: osConfig:
with lib; with pkgs;
let
  graphical = osConfig.services.xserver.enable;
in
mkMerge [
  (mkIf graphical [
    spicetify-cli
    lxappearance
    vscode.fhs
    libnotify
    flameshot
    obsidian
    shotwell
    discord
    wezterm
    barrier
    qt6ct
    dunst
    slack
    gimp
  ])
  ([
    rnix-lsp
    hyfetch
    bottom
    tldr
    eza
    git
  ])
]
