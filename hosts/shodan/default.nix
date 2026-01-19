{ ... }:
{
  imports = [
    ./packages.nix
    ./persist.nix
    ./users.nix
    ./hardware
  ];

  programs = {
    steam.enable = true;
    zsh.shellAliases = {
      update = "sudo nixos-rebuild switch -j 3 --cores 12";
      bupdate = "sudo nixos-rebuild boot -j 3 --cores 12"; # pronounced boop-date
    };
  };

  services = {
    avahi = {
      enable = true;
      publish = {
        enable = true;
        userServices = true;
      };
    };

    openssh.enable = true;
    flatpak.enable = true;
    tumbler.enable = true;
    gvfs.enable = true;
  };

  networking.extraHosts = ''
    10.0.0.2 plsnobully.me git.plsnobully.me cdn.plsnobully.me
  '';

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  time.timeZone = "Australia/Melbourne";

  system.stateVersion = "26.05";
  networking.hostName = "shodan";
}
