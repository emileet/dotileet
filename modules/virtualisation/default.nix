{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.virtualisation;
in
{
  config = mkIf cfg.libvirtd.enable {
    virtualisation = {
      kvmfr = {
        shm = {
          group = "libvirtd";
          mode = "0660";
          enable = true;
        };
        enable = true;
      };
      memflow = {
        group = "libvirtd";
        mode = "0660";
        enable = true;
      };
    };
    boot = {
      initrd.kernelModules = [
        "vfio"
        "vfio_pci"
        "vfio_iommu_type1"
      ];
      kernelModules = [
        "vfio"
        "vfio_pci"
        "vfio_iommu_type1"
      ];
    };
    environment = {
      systemPackages = with pkgs; [ virt-manager ];
      persistence."/nix/persist/virt" = {
        hideMounts = true;
        directories = [
          "/etc/libvirt/hooks/qemu.d"
          "/var/lib/libvirt/qemu"
        ];
      };
    };
  };
}
