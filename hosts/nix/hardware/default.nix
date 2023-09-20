{ pkgs, ... }:
{
  imports = [
    ./display.nix
    ./audio.nix
  ];

  powerManagement.cpuFreqGovernor = "performance";
  nixpkgs.hostPlatform = "x86_64-linux";

  hardware = {
    enableRedistributableFirmware = true;
    cpu.amd.updateMicrocode = true;
    opengl.enable = true;
  };

  networking = {
    networkmanager.enable = true;
    interfaces = {
      enp69s0.useDHCP = true;
      br0.useDHCP = true;
    };
    bridges = {
      "br0" = {
        interfaces = [ "enp69s0" ];
      };
    };
    firewall = {
      # allowedTCPPorts = [ ... ];
      # allowedUDPPorts = [ ... ];
      enable = false;
    };
  };

  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
    };

    swraid = {
      mdadmConf = "MAILADDR hi@emi.gay";
      enable = true;
    };

    kernelPackages = pkgs.linuxPackages_zen;
    kernelPatches = [{
      patch = /nix/patches/linux/linux-vmi.6.5.3.patch;
      name = "virtual machine introspection";
      extraConfig = ''
        EVDEV_MIRROR y
        LIVEPATCH y
      '';
    }];

    kernelParams = [
      "video=DisplayPort-0:2560x1440@165"
      "video=DisplayPort-1:2560x1440@165"
      "vfio-pci.ids=10de:2486,10de:228b"
      "transparent_hugepage=never"
      "default_hugepagesz=1G"
      "hugepagesz=1G"
      "hugepages=16"
      "kvm.report_ignored_msrs=0"
      "kvm.ignore_msrs=1"
      "kvm_amd.intercept_rdtsc=0"
      "kvm.spoof_msr_tsc=0"
      "kvm_amd.avic=1"
      "kvm_amd.npt=1"
      "iommu=pt"
      "mitigations=off" # ohnoe :>
    ];

    initrd = {
      availableKernelModules = [ "xhci_pci" "nvme" "ahci" "usbhid" "usb_storage" "sd_mod" "sr_mod" ];
      kernelModules = [ "amdgpu" "vfio" "vfio_pci" "vfio_iommu_type1" ];
    };

    kernelModules = [ "amdgpu" "kvm-amd" "vfio" "vfio_pci" "vfio_iommu_type1" ];
    blacklistedKernelModules = [ "nvidia" "nouveau" ];
    extraModulePackages = [ ];

    tmp.cleanOnBoot = true;
  };

  fileSystems = {
    "/" = {
      device = "none";
      fsType = "tmpfs";
      options = [ "size=3G" "mode=755" ];
    };

    "/boot" = {
      device = "/dev/disk/by-label/NIXBOOT";
      fsType = "vfat";
    };

    "/nix" = {
      device = "/dev/disk/by-label/NIX";
      fsType = "btrfs";
    };

    "/home" = {
      device = "/dev/disk/by-label/HOME";
      fsType = "btrfs";
    };

    "/storage" = {
      device = "/dev/disk/by-label/RAID0";
      fsType = "ext4";
    };
  };
}
