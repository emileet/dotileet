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
      update = "nh os switch -j 3 --cores 12";
      bupdate = "nh os boot -j 3 --cores 12"; # pronounced boop-date
    };
  };

  virtualisation.docker.enable = true;
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
    ollama.enable = true;
    gvfs.enable = true;
  };

  networking = {
    bridges."br0".interfaces = [ "enp11s0" ];
    interfaces = {
      enp11s0.useDHCP = true;
      br0.useDHCP = true;
    };

    extraHosts = ''
      10.0.0.11 plsnobully.me git.plsnobully.me
    '';

    networkmanager.enable = true;
    firewall.enable = false;
    hostName = "shodan";
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  time.timeZone = "Australia/Melbourne";
  system.stateVersion = "26.05";
}
