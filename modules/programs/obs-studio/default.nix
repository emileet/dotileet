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
    programs.obs-studio = with pkgs; {
      package = (
        obs-studio.override {
          cudaSupport = cfgNvidia.enabled;
        }
      );
      plugins = mkMerge [
        (mkIf cfgLibvirt.enable [ obs-kvmfr ])
        [
          obs-vkcapture-kms
          obs-distroav
        ]
      ];
    };
  };
}
