{ ... }:
{
  imports = [
    ./nginx.nix
  ];

  virtualisation.docker.enable = true;
  services = {
    openssh.enable = true;
  };
}
