{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.programs;
in
{
  config = mkIf cfg.git.enable {
    programs.git = {
      package = pkgs.gitFull;
      settings = {
        user = {
          name = "Emily Maré (emileet)";
          email = "dev@emi.gay";
        };
        credential.helper = "${pkgs.gitFull}/bin/git-credential-libsecret";
        tag.forceSignAnnotated = true;
        protocol.file.allow = "user";
        init.defaultBranch = "main";
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
