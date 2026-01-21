{ lib, config, ... }:
with lib;
let
  cfg = config.services.openssh;
in
{
  config = mkIf cfg.enable {
    services.openssh = {
      extraConfig = ''
        AuthenticationMethods publickey,keyboard-interactive
      '';
      settings = {
        PasswordAuthentication = false;
      };
      ports = [ 2269 ];
    };

    security.pam.services = {
      sshd = {
        googleAuthenticator.enable = true;
        unixAuth = mkForce true;
      };
    };
  };
}
