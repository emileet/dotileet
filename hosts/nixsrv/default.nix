{ ... }:
{
  imports = [
    ./packages.nix
    ./persist.nix
    ./users.nix
    ./hardware
    ./serve
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

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  time.timeZone = "Australia/Melbourne";

  system.stateVersion = "26.05";
  networking.hostName = "nixsrv";
}
