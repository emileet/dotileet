{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    virt-manager
    liquidctl
    qjackctl
    mdadm
  ];

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
}
