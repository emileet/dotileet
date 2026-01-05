{ ... }:
{
  environment.persistence = {
    "/nix/persist/system" = {
      hideMounts = true;
      directories = [
        "/etc/NetworkManager"
        "/etc/nixos"
        "/etc/ssh"
        "/var/lib/flatpak"
        "/var/lib/nixos"
        "/var/log"
        "/var/tmp"
        "/tmp"
      ];
      files = [
        "/etc/deskflow-server.conf"
        "/etc/machine-id"
      ];
    };
  };
}
