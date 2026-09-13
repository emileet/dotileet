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
    zsh.shellAliases = {
      bupdate = "nh os boot -j 3 --cores 12"; # pronounced boop-date
      update = "nh os switch -j 3 --cores 12";
    };
    gpu-screen-recorder.enable = true;
    obs-studio.enable = true;
    hyprland.enable = true;
    steam.enable = true;
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
    hostBridge = {
      interface = "enp11s0";
      enable = true;
    };
    networkmanager.enable = true;
    hostName = "shodan";
  };
}
