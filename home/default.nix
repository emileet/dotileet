{ lib, config, ... }:
with lib;
{
  imports = (import ./services);
  home.stateVersion = "23.11";
}
