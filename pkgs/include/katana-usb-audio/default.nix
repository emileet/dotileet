{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.hardware.katana;
in
{
  options.hardware.katana = {
    enable = mkEnableOption "Whether to enable the SoundBlaster X Katana USB Audio Device";
  };

  config = mkIf cfg.enable {
    boot.extraModulePackages = with config.boot.kernelPackages; [
      (pkgs.callPackage ./kmod { inherit kernel; })
    ];

    boot.kernelModules = [ "katana_usb_audio" ];

    boot.extraModprobeConfig = ''
      softdep snd-usb-audio pre: katana_usb_audio
    '';
  };
}
