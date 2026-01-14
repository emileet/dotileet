{
  lib,
  pkgs,
  osConfig,
  ...
}:
{
  imports = (import ./programs) ++ (import ./services);
  home.packages = import ../pkgs/user.nix lib pkgs osConfig;
  home.stateVersion = "26.05";
}
