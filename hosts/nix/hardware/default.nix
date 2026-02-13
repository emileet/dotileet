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
    graphics.enable = true;
    xone.enable = true;
    i2c.enable = true;
  };

  services = {
    udev.extraRules = ''
      SUBSYSTEM=="input", ATTRS{idVendor}=="4f53", ATTRS{idProduct}=="514b", ENV{ID_INPUT_JOYSTICK}="" 
      KERNEL=="ntsync" MODE="0644"
    '';

    persistent-evdev = {
      enable = true;
      devices = {
        persist-mouse0 = "usb-Glorious_Model_O_Wireless_000000000000-event-mouse";
        persist-keyboard0 = "usb-Qwertykeys_QK65_Hotswap-if02-event-kbd";
      };
    };
  };

  systemd.services.init-liquidctl = {
    description = "initialise liquidctl";
    wantedBy = [ "default.target" ];
    serviceConfig = {
      ExecStart = [
        "${pkgs.liquidctl}/bin/liquidctl -m kraken initialize"
        "${pkgs.liquidctl}/bin/liquidctl -m kraken set pump speed 20 80 30 80 40 90 50 100"
        "${pkgs.liquidctl}/bin/liquidctl -m kraken set fan speed 20 40 30 40 35 60 40 60 50 80 60 100"
      ];
      Type = "oneshot"; # like all banger yuris :')
    };
  };

  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        consoleMode = "2";
        editor = false;
        enable = true;
      };
    };

    swraid = {
      mdadmConf = "MAILADDR hi@emi.gay";
      enable = true;
    };

    kernelPackages = pkgs.linuxPackages_zen;
    kernelPatches = [
      {
        patch = /nix/patches/linux/linux-vmi-6.17.8.patch;
        name = "virtual machine introspection";
        extraConfig = ''
          EVDEV_MIRROR m
          LIVEPATCH y
        '';
      }
    ];

    kernelParams = [
      "video=DP-1:3440x1440@100"
      "vfio-pci.ids=10de:2486,10de:228b"
      "transparent_hugepage=never"
      "default_hugepagesz=1G"
      "hugepagesz=1G"
      "hugepages=16"
      "kvm_amd.intercept_rdtsc=0"
      "kvm.spoof_msr_tsc=0"
      "kvm_amd.avic=1"
      "kvm_amd.npt=1"
      "iommu=pt"
      "mitigations=off" # ohnoe :>
    ];

    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "nvme"
        "ahci"
        "usbhid"
        "usb_storage"
        "sd_mod"
        "sr_mod"
      ];
      kernelModules = [ "amdgpu" ];
    };

    blacklistedKernelModules = [
      "nvidia"
      "nouveau"
    ];
    kernelModules = [
      "amdgpu"
      "kvm-amd"
    ];
    extraModulePackages = [ ];

    binfmt.registrations.appimage = {
      wrapInterpreterInShell = false;
      interpreter = "${pkgs.appimage-run}/bin/appimage-run";
      recognitionType = "magic";
      offset = 0;
      mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
      magicOrExtension = ''\x7fELF....AI\x02'';
    };

    tmp.cleanOnBoot = true;
  };

  fileSystems = {
    "/" = {
      device = "none";
      fsType = "tmpfs";
      options = [
        "size=3G"
        "mode=755"
      ];
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
