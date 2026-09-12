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
  config = mkIf cfg.direnv.enable {
    programs.direnv = {
      enableGitIntegration = cfg.git.enable;
      enableZshIntegration = cfg.zsh.enable;
    };
  };
}
