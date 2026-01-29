{ ... }:
{
  imports = [
    ./packages.nix
    ./persist.nix
    ./users.nix
    ./hardware
    ./services
  ];

  programs = {
    zsh.shellAliases = {
      update = "nh os switch -j 3 --cores 8";
      bupdate = "nh os boot -j 3 --cores 8"; # pronounced boop-date
    };
  };

  virtualisation = {
    docker.enable = true;
  };

  services = {
    openssh.enable = true;
  };

  networking = {
    extraHosts = ''
      10.0.0.11 pod.plsnobully.me
    '';

    interfaces.enp1s0.useDHCP = true;
    networkmanager.enable = true;
    hostName = "nixsrv";
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  time.timeZone = "Australia/Melbourne";
  system.stateVersion = "26.05";
}
