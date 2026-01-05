{ ... }:
{
  services = {
    pulseaudio.enable = false;

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
        ip = "10.0.0.5";
        port = 6980;
        enable = true;
      };
      receptor = {
        stream = "Microphone";
        ip = "10.0.0.5";
        port = 6981;
        enable = true;
      };
      enable = true;
    };
  };
}
