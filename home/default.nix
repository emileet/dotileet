{ ... }:
{
  home.stateVersion = "26.11";
  xdg.enable = true;
  imports = [
    ../pkgs/user.nix
    ./scripts
    ./theme
  ]
  ++ (import ./programs)
  ++ (import ./services);
}
