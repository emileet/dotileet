{ ... }:
{
  services = {
    pipewire.enable = true;
    vban = {
      emitter = {
        ip = "10.0.0.67";
        enable = true;
      };
      enable = true;
    };
  };
  hardware = {
    katana.enable = true;
    wave3 = {
      startMuted = true;
      startGain = 46;
      enable = true;
    };
  };
}
