{ pkgs, ... }:
{
  users = {
    mutableUsers = false;
    users.emileet = {
      hashedPasswordFile = "/nix/secrets/passwd/emileet";
      isNormalUser = true;
      shell = pkgs.zsh;
    };
  };
}
