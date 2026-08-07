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
      wireplumber.enable = true;
      pulse.enable = true;
      jack.enable = true;
      alsa = {
        support32Bit = true;
        enable = true;
      };
      extraConfig.pipewire."99-quantum" = {
        "context.properties" = {
          "default.clock.allowed-rates" = [ 48000 ];
          "default.clock.min-quantum" = 1024;
          "default.clock.max-quantum" = 1024;
          "default.clock.quantum" = 128;
          "default.clock.rate" = 48000;
        };
      };
      extraConfig.pipewire-pulse."99-pulse-latency" = {
        "pulse.properties" = {
          "pulse.min.quantum" = "128/48000";
          "pulse.min.frag" = "128/48000";
          "pulse.min.req" = "128/48000";
        };
        "stream.properties" = {
          "node.latency" = "128/48000";
        };
      };
    };
  };
}
