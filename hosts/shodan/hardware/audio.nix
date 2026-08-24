{ ... }:
{
  services = {
    vban = {
      emitter = {
        ip = "10.0.0.67";
        enable = true;
      };
      enable = true;
    };
    pipewire.enable = true;
  };
  hardware.wave3 = {
    startMuted = true;
    startGain = 46;
    enable = true;
  };
}
