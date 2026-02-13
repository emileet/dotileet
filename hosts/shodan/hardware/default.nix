{ config, pkgs, ... }:
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
    nvidia = with pkgs; {
      package = nvidia-patch.patch-nvenc (
        nvidia-patch.patch-fbc config.boot.kernelPackages.nvidiaPackages.stable
      );
      open = true;
    };
  };

  services = {
    udev.extraRules = ''
      SUBSYSTEM=="input", ATTRS{idVendor}=="4f53", ATTRS{idProduct}=="514b", ENV{ID_INPUT_JOYSTICK}="" 
      KERNEL=="ntsync" MODE="0644"
    '';

    persistent-evdev = {
      devices = {
        persist-mouse0 = "usb-Glorious_Model_O_Wireless_000000000000-event-mouse";
        persist-keyboard0 = "usb-Qwertykeys_QK65_Hotswap-if02-event-kbd";
      };
      enable = true;
    };
  };

  systemd.user.services.openrgb-profile = {
    description = "load openrgb profile";
    wantedBy = [ "default.target" ];
    enable = true;
    serviceConfig = {
      ExecStart = "${pkgs.openrgb}/bin/openrgb -p ${config.networking.hostName}.orp";
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

    kernelPackages = pkgs.linuxPackages_zen;
    kernelParams = [
      "video=DP-2:5120x1440@240"
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
      kernelModules = [ "nvidia" ];
    };

    blacklistedKernelModules = [
      "amdgpu"
      "nouveau"
    ];
    kernelModules = [
      "nvidia"
      "kvm-amd"
      "i2c-dev"
      "i2c-piix4"
    ];
    extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];

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
      fsType = "ext4";
    };

    "/home" = {
      device = "/dev/disk/by-label/HOME";
      fsType = "ext4";
    };

    "/storage" = {
      device = "/dev/disk/by-label/STORAGE";
      fsType = "ext4";
    };
  };
}
