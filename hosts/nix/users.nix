{ pkgs, ... }:
{
  users = {
    users.emileet = {
      hashedPasswordFile = "/nix/secrets/passwd/emileet";
      extraGroups = [ "wheel" "libvirtd" "audio" "realtime" ];
      isNormalUser = true;
      shell = pkgs.zsh;
    };
    mutableUsers = false;
  };
}
