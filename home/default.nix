{ lib, pkgs, osConfig, ... }:
{
  imports = (import ./services);
  home.packages = import ../pkgs/user.nix lib pkgs osConfig;
  home.stateVersion = "25.05";
}
