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
  config = mkIf cfg.zsh.enable {
    programs.eza = {
      enableZshIntegration = true;
      extraOptions = [
        "--group-directories-first"
        "--header"
        "--group"
        "--long"
      ];
      colors = "auto";
      icons = "auto";
      enable = true;
    };
  };
}
