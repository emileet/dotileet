{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.programs.zsh;
in
{
  config = mkIf cfg.enable {
    programs = {
      zsh = {
        shellAliases = {
          ela = "eza -lagh --icons --group-directories-first";
          el = "eza -lgh --icons --group-directories-first";
        };
      };
    };
  };
}
