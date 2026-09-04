{
  ...
}:
{
  imports = [
    ./specialisation
    ./packages.nix
    ./persist.nix
    ./secret.nix
    ./users.nix
    ./hardware
  ];

  programs = {
    gpu-screen-recorder.enable = true;
    obs-studio.enable = true;
    hyprland.enable = true;
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

    llama-cpp.enable = true;
    openssh.enable = true;
    flatpak.enable = true;
    tumbler.enable = true;
    monado.enable = true;
    gvfs.enable = true;
  };

  networking = {
    bridges."br0".interfaces = [ "enp11s0" ];
    interfaces = {
      enp11s0.useDHCP = true;
      br0.useDHCP = true;
    };

    networkmanager.enable = true;
    hostName = "shodan";
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  time.timeZone = "Australia/Melbourne";
  system.stateVersion = "26.11";
}
