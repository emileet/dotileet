{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
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
  }
  // optionalAttrs (config.specialisation != { }) {
    nvidia = with pkgs; {
      package = nvidia-patch.auto-patch config.boot.kernelPackages.nvidiaPackages.beta;
      open = true;
    };
  };

  services = {
    udev.extraRules = ''
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="4f53", ATTRS{idProduct}=="514b", OWNER="1000", GROUP="100", MODE="0666"
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
    kernelPatches = [
      {
        patch = /nix/patches/linux/linux-vmi-7.0.3.patch;
        name = "virtual machine introspection";
        extraConfig = ''
          EVDEV_MIRROR m
          LIVEPATCH y
          PREEMPT y
        '';
      }
    ];
    kernelParams = [
      "kvm_amd.intercept_rdtsc=1"
      "mitigations=off" # ohnoe :>
    ]
    ++ optionals (config.specialisation != { }) [
      "video=HDMI-1:5120x1440@240"
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
    }
    // optionalAttrs (config.specialisation != { }) {
      kernelModules = [ "nvidia" ];
    };

    blacklistedKernelModules = optionals (config.specialisation != { }) [
      "nouveau"
      "amdgpu"
    ];
    kernelModules = [
      "i2c-dev"
      "i2c-piix4"
    ]
    ++ optionals (config.specialisation != { }) [
      "nvidia"
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
