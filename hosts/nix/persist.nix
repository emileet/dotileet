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
        "/etc/barrier.conf"
        "/etc/machine-id"
      ];
    };
    "/nix/persist/virt" = {
      hideMounts = true;
      directories = [
        "/var/lib/libvirt/qemu/networks"
        "/etc/libvirt/hooks/qemu.d"
      ];
      files = [
        "/var/lib/libvirt/qemu/Windows11.xml"
      ];
    };
  };
}
