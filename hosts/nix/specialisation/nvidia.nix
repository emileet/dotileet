{
  config,
  pkgs,
  lib,
  ...
}:
{
  specialisation = {
    nvidia.configuration = with lib; {
      hardware = {
        nvidia = with pkgs; {
          package = nvidia-patch.auto-patch config.boot.kernelPackages.nvidiaPackages.beta;
          open = true;
        };
      };

      environment.variables = {
        __GL_SYNC_DISPLAY_DEVICE = "DP-2";
        __GL_SYNC_TO_VBLANK = 0;
        CLUTTER_DEFAULT_FPS = 240;
      };

      services.xserver = {
        displayManager = {
          setupCommands = lib.mkForce ''
            MONITOR1='DP-2'
            ${pkgs.xrandr}/bin/xrandr --output $MONITOR1 --mode 3440x1440 --rate 100 --primary
          '';
        };
        videoDrivers = [ "nvidia" ];
        deviceSection = lib.mkForce ''
          Option "NoFlip" "true"
        '';
        dpi = 96;
      };

      boot = {
        extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];
        kernelParams = [
          "vfio-pci.ids=1002:73af,1002:ab28,1002:73a6,1002:73a4"
        ];
        blacklistedKernelModules = [
          "amdgpu"
        ];
      };
    };
  };
}
