{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.services.ollama;
in
{
  config = mkIf cfg.enable {
    services = {
      open-webui.enable = false;
      ollama = {
        package = pkgs.ollama-cuda;
        home = "/storage/var/lib/ollama";
      };
    };
    environment.persistence."/nix/persist/system".directories = [
      "/var/lib/private/open-webui"
    ];
  };
}
