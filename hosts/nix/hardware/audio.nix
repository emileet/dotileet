{ ... }:
{
  hardware.pulseaudio.enable = false;
  sound = {
    vban.enable = true;
    enable = true;
  };

  services.pipewire = {
    alsa = {
      support32Bit = true;
      enable = true;
    };
    pulse.enable = true;
    jack.enable = true;
    enable = true;
  };
}
