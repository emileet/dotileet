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
        "audio"
        "wheel"
      ];
    };
    mutableUsers = false;
  };
}
