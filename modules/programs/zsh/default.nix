{ lib, config, ... }:
with lib;
let
  cfg = config.programs.zsh;
in
{
  config = mkIf cfg.enable {
    programs = {
      zsh = {
        shellAliases = {
          a2c = ", aria2c --max-connection-per-server=16 --min-split-size=1M --split=16 --max-concurrent-downloads=5 --file-allocation=falloc --summary-interval=1 --human-readable=true";
          la = "eza -lagh --icons --group-directories-first";
          ls = "eza -lgh --icons --group-directories-first";
        };
      };
    };
  };
}
