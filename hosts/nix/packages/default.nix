{ pkgs, ... }:
let
  system = import ./system.nix pkgs;
  fonts = import ./fonts.nix pkgs;
in
{
  environment.systemPackages = system;
  fonts.packages = fonts;

  services = {
    flatpak.enable = true;
    tumbler.enable = true;
    gvfs.enable = true;
  };

  programs = {
    thunar.enable = true;
    nix-ld.enable = true;
    dconf.enable = true;
    mtr.enable = true;

    zsh = {
      shellAliases = {
        update = "sudo nixos-rebuild switch";
      };
      enable = true;
    };

    gnupg.agent = {
      enableSSHSupport = true;
      enable = true;
    };

    neovim = {
      defaultEditor = true;
      enable = true;
    };
  };

  xdg.portal = {
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    enable = true;
  };

  nixpkgs.config = {
    packageOverrides = pkgs: {
      polybar = (pkgs.polybar.override {
        githubSupport = true;
        pulseSupport = true;
        i3Support = true;
      });

      catppuccin-gtk = (
        pkgs.catppuccin-gtk.override {
          accents = [ "pink" "lavender" ];
          tweaks = [ "rimless" ];
          variant = "mocha";
          size = "compact";
        }
      );
    };

    allowUnfree = true;
  };
}
