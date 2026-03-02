{
  config,
  pkgs,
  lib,
  ...
}:
{
  specialisation = {
    vfio.configuration = with lib; {
      services = {
        cockpit = {
          allowed-origins = [
            "https://localhost:${toString config.services.cockpit.port}"
            "https://10.0.0.10:${toString config.services.cockpit.port}"
          ];
          plugins = with pkgs; [ cockpit-machines ];
          enable = true;
        };
        xserver = {
          windowManager.i3.enable = mkForce false;
          enable = mkForce false;
        };
        flatpak.enable = mkForce false;
      };

      virtualisation = {
        libvirtd.qemu.verbatimConfig = ''
          cgroup_device_acl = [
            "/dev/null", "/dev/full", "/dev/zero", "/dev/random", "/dev/urandom",
            "/dev/ptmx", "/dev/kvm", "/dev/kqemu", "/dev/rtc", "/dev/hpet",
            "/dev/input/by-id/uinput-persist-keyboard0",
            "/dev/input/by-id/uinput-persist-mouse0"
          ]
        '';
        libvirtd.enable = true;
      };

      boot = {
        kernelParams = [
          "vfio-pci.ids=10de:2c02,10de:22e9"
          "transparent_hugepage=never"
          "default_hugepagesz=1G"
          "hugepagesz=1G"
          "hugepages=16"
        ];
        blacklistedKernelModules = [
          "nvidia"
        ];
      };
    };
  };
}
