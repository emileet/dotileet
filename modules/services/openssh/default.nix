{ lib, config, ... }:
with lib;
let
  cfg = config.services.openssh;
in
{
  config = mkIf cfg.enable {
    services.openssh = {
      settings = {
        KbdInteractiveAuthentication = false;
        PasswordAuthentication = false;
      };
      ports = [ 2269 ];
    };
  };
}
