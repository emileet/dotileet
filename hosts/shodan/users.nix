{ pkgs, ... }:
{
  users = {
    users.emileet = {
      hashedPasswordFile = "/nix/secrets/passwd/emileet";
      isNormalUser = true;
      shell = pkgs.zsh;
      extraGroups = [
        "realtime"
        "gamemode"
        "audio"
        "wheel"
        "input"
      ];
    };
    mutableUsers = false;
  };
}
