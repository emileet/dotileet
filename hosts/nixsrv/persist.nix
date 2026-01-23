{ ... }:
{
  environment.persistence = {
    "/nix/persist/system" = {
      hideMounts = true;
      directories = [
        "/etc/NetworkManager"
        "/var/lib/docker"
        "/var/lib/nixos"
        "/var/lib/acme"
        "/var/log"
        "/var/tmp"
        "/tmp"
      ];
      files = [
        "/etc/machine-id"
      ];
    };
    "/vmshare/persist" = {
      hideMounts = true;
      directories = [
        "/etc/nixos"
      ];
    };
  };
}
