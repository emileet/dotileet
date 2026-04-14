{
  pkgs,
  ...
}:
{
  specialisation = {
    # dual boot windows without running it on bare metal (hot swapping the gpu between host and vm is possible but a pain)
    vfio.configuration = {
      virtualisation = {
        libvirtd.qemu.verbatimConfig = ''
          cgroup_device_acl = [
            "/dev/null", "/dev/full", "/dev/zero", "/dev/random", "/dev/urandom",
            "/dev/ptmx", "/dev/kvm", "/dev/kqemu", "/dev/rtc", "/dev/hpet",
            "/dev/input/by-id/uinput-persist-keyboard0",
            "/dev/input/by-id/uinput-persist-mouse0",
            "/dev/kvmfr0"
          ]
        '';
        libvirtd.enable = true;
        memflow.enable = true;
        kvmfr.enable = true;
      };

      systemd = {
        services.cpu-affinity = {
          description = "set cpu affinity for vfio";
          wantedBy = [ "multi-user.target" ];
          after = [ "multi-user.target" ];
          script = ''
            systemctl set-property --runtime -- user.slice AllowedCPUs=0-7,16-23
            systemctl set-property --runtime -- system.slice AllowedCPUs=0-7,16-23
            systemctl set-property --runtime -- init.scope AllowedCPUs=0-7,16-23
          '';
          serviceConfig = {
            Type = "oneshot";
          };
        };
      };

      services.xserver = {
        displayManager = {
          setupCommands = ''
            MONITOR='DP-1'
            ${pkgs.xrandr}/bin/xrandr --output $MONITOR --primary --mode 5120x1440 --rate 240
          '';
        };
      };

      boot = {
        kernelParams = [
          "video=DP-1:5120x1440@240"
          "vfio-pci.ids=10de:2c02,10de:22e9"
          "transparent_hugepage=never"
          "default_hugepagesz=1G"
          "hugepagesz=1G"
          "hugepages=16"
          "nohz_full=8-15,24-31"
          "isolcpus=8-15,24-31"
        ];
        initrd = {
          kernelModules = [
            "amdgpu"
          ];
        };
        kernelModules = [
          "amdgpu"
        ];
        blacklistedKernelModules = [
          "nouveau"
          "nvidia"
        ];
      };

      swapDevices = [
        {
          device = "/nix/swapfile";
          size = 16384;
        }
      ];
    };
  };
}
