{ ... }:
{
  hardware.pulseaudio.enable = false;
  sound.enable = true;

  services = {
    pipewire = {
      alsa = {
        support32Bit = true;
        enable = true;
      };
      pulse.enable = true;
      jack.enable = true;
      enable = true;
    };

    vban = {
      emitter = {
        stream = "Audio";
        ip = "10.0.0.3";
        port = 6980;
        enable = true;
      };
      receptor = {
        stream = "Microphone";
        ip = "10.0.0.3";
        port = 6981;
        enable = true;
      };
      enable = true;
    };
  };
}
