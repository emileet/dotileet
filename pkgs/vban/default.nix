{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.sound.vban;
in
{
  options.sound.vban = {
    enable = mkEnableOption "Vban";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      (pkgs.callPackage ./package.nix { inherit pkgs; })
    ];
  };
}
