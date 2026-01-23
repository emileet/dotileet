{ ... }:
{
  powerManagement.cpuFreqGovernor = "performance";
  nixpkgs.hostPlatform = "x86_64-linux";

  networking = {
    networkmanager.enable = true;

    interfaces = {
      enp1s0.useDHCP = true;
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
      systemd-boot = {
        consoleMode = "2";
        editor = false;
        enable = true;
      };
    };

    initrd = {
      availableKernelModules = [
        "virtio_pci"
        "virtio_blk"
        "ata_piix"
        "uhci_hcd"
        "sr_mod"
      ];
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

    "/vmshare" = {
      device = "share";
      fsType = "virtiofs";
    };
  };
}
