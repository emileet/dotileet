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
    programs.zsh.oh-my-zsh = {
      plugins = [
        "copyfile"
        "copypath"
        "encode64"
        "extract"
        "git"
        "cp"
      ];
      theme = "agnoster";
      enable = true;
    };
  };
}
