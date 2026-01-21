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
        "ollama"
        "audio"
        "wheel"
        "input"
        "i2c"
      ];
    };
    mutableUsers = false;
  };
}
