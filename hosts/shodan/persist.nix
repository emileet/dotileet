{ ... }:
{
  environment.persistence = {
    "/nix/persist/system" = {
      hideMounts = true;
      directories = [
        "/etc/NetworkManager"
        "/etc/nixos"
        "/var/lib/flatpak"
        "/var/lib/docker"
        "/var/lib/nixos"
        "/var/log"
        "/var/tmp"
        "/tmp"
      ];
      files = [
        "/etc/machine-id"
      ];
    };
  };
}
