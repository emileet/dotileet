{ ... }:
{
  imports = [ ../pkgs/user.nix ] ++ (import ./programs) ++ (import ./services);
  home.stateVersion = "26.11";
}
