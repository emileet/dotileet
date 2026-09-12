{
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.programs;
in
{
  config = mkIf cfg.eza.enable {
    programs.eza = {
      enableZshIntegration = cfg.zsh.enable;
      extraOptions = [
        "--group-directories-first"
        "--header"
        "--group"
        "--long"
      ];
      colors = "auto";
      icons = "auto";
    };
  };
}
