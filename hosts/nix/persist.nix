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
        "/etc/machine-id"
      ];
    };
    "/nix/persist/virt" = {
      hideMounts = true;
      directories = [
        "/etc/libvirt/hooks/qemu.d"
        "/var/lib/libvirt/qemu"
      ];
    };
  };
}
