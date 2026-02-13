{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfgLibvirt = config.virtualisation.libvirtd;
  cfgNvidia = config.hardware.nvidia;
  cfg = config.programs.obs-studio;
in
{
  config = mkIf cfg.enable {
    programs.obs-studio =
      with pkgs;
      {
        plugins = [
          obs-vkcapture-kms
          obs-distroav
        ]
        ++ optional cfgLibvirt.enable [
          obs-kvmfr
        ];
      }
      // mkIf cfgNvidia.enabled {
        package = (
          obs-studio.override {
            cudaSupport = true;
          }
        );
      };
  };
}
