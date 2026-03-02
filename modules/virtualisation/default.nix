{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  cfg = config.virtualisation;
in
{
  config = mkIf cfg.libvirtd.enable {
    virtualisation = {
      libvirtd = {
        qemu.vhostUserPackages = with pkgs; [ virtiofsd ];
        dbus.enable = true;
      };
      kvmfr = {
        shm = {
          group = "libvirtd";
          mode = "0660";
          enable = true;
        };
        enable = false;
      };
      memflow = {
        group = "libvirtd";
        mode = "0660";
        enable = false;
      };
    };
    boot = {
      kernelParams = [
        "kvm_amd.avic=1"
        "kvm_amd.npt=1"
        "iommu=pt"
      ];
      initrd.kernelModules = [
        "vfio"
        "vfio_pci"
        "vfio_iommu_type1"
      ];
      kernelModules = [
        "kvm-amd"
        "vfio"
        "vfio_pci"
        "vfio_iommu_type1"
      ];
    };
    users.users.emileet.extraGroups = [ "libvirtd" ];
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
