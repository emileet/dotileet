{ pkgs, ... }:
{
  users = {
    users.emileet = {
      hashedPasswordFile = "/nix/secrets/passwd/emileet";
      isNormalUser = true;
      shell = pkgs.zsh;
      extraGroups = [
        "libvirtd"
        "realtime"
        "gamemode"
        "docker"
        "audio"
        "wheel"
        "input"
      ];
    };
    mutableUsers = false;
  };
}
