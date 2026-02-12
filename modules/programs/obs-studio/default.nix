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
      package = mkIf cfgNvidia.enabled (
        obs-studio.override {
          cudaSupport = true;
        }
      );
      plugins = [
        obs-vkcapture-kms
        obs-distroav
      ]
      ++ optional cfgLibvirt.enable [
        obs-kvmfr
      ];
    };
  };
}
