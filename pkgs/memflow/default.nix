{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.virtualisation.memflow;
in
{
  options.virtualisation.memflow = {
    enable = mkEnableOption "Memflow";
    group = mkOption {
      type = types.str;
      default = "root";
      description = "Group of the memflow device.";
    };
    mode = mkOption {
      type = types.str;
      default = "0600";
      description = "Mode of the memflow device.";
    };
  };

  config = mkIf cfg.enable {
    boot.extraModulePackages = with config.boot.kernelPackages; [
      (pkgs.callPackage ./kmod { inherit kernel; })
    ];

    boot.kernelModules = [ "memflow" ];

    services.udev.extraRules = optionals cfg.enable ''
      KERNEL=="memflow" SUBSYSTEM=="misc" GROUP="${cfg.group}" MODE="${cfg.mode}"
    '';
  };
}
