{
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.services.pipewire;
in
{
  config = mkIf cfg.enable {
    security.rtkit.enable = true;
    services.pipewire = {
      pulse.enable = true;
      jack.enable = true;
      alsa = {
        support32Bit = true;
        enable = true;
      };
      wireplumber = {
        enable = true;
        extraConfig."10-disable-suspension" = {
          "monitor.alsa.rules" = [
            {
              matches = [ { "node.name" = "~alsa_output.*"; } ];
              actions = {
                update-props = {
                  "session.suspend-timeout-seconds" = 0;
                };
              };
            }
          ];
        };
      };
      extraConfig.pipewire."99-quantum" = {
        "context.properties" = {
          "default.clock.allowed-rates" = [ 48000 ];
          "default.clock.max-quantum" = 4096;
          "default.clock.min-quantum" = 512;
          "default.clock.quantum" = 1024;
          "default.clock.rate" = 48000;
        };
      };
      extraConfig.pipewire-pulse."99-pulse-latency" = {
        "pulse.properties" = {
          "pulse.min.quantum" = "512/48000";
          "pulse.min.frag" = "512/48000";
          "pulse.min.req" = "512/48000";
        };
        "stream.properties" = {
          "node.latency" = "1024/48000";
        };
      };
    };
  };
}
