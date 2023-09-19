{ pkgs, ... }:
let
  userPackages = import ./packages/user.nix pkgs;
in
{
  users = {
    # don't think this is necessary since we already have an ephemeral root
    mutableUsers = false;

    users.emileet = {
      hashedPasswordFile = "/nix/secrets/passwd/emileet";
      extraGroups = [ "wheel" "libvirtd" "audio" "realtime" ];
      isNormalUser = true;

      packages = userPackages;
      shell = pkgs.zsh;
    };
  };
}
