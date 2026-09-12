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
  config = mkIf cfg.git.enable {
    home.file."${config.xdg.configHome}/git/template/HEAD".text = "ref: refs/heads/main";
    programs.git = {
      settings = {
        init = {
          templateDir = "${config.xdg.configHome}/git/template";
          defaultBranch = "main";
        };
        user = {
          name = "Emily Maré (emileet)";
          email = "dev@emi.gay";
        };
        protocol.file.allow = "always";
        tag.forceSignAnnotated = true;
        credential.helper = "store";
        commit.gpgSign = true;
        gpg.program = "gpg";
      };
      signing = {
        key = "9DE77C114F9382C2F14B7708AED39E56DD0D6863";
        signByDefault = true;
      };
      includes = import ./includes.nix;
      lfs.enable = true;
    };
  };
}
