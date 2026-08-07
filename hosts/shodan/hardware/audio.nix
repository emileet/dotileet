{ ... }:
{
  services = {
    pipewire.enable = true;
    vban = {
      emitter = {
        stream = "Audio";
        ip = "10.0.0.5";
        port = 6980;
        enable = true;
      };
      receptor = {
        backend = "pulseaudio";
        stream = "Microphone";
        ip = "10.0.0.5";
        port = 6980;
        enable = true;
      };
      enable = true;
    };
  };
}
