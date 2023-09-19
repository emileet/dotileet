{ pkgs, ... }:
{
  hardware.pulseaudio.enable = false;
  sound.enable = true;

  services.pipewire = {
    pulse.enable = true;
    jack.enable = true;
    alsa = {
      support32Bit = true;
      enable = true;
    };

    enable = true;
  };
}
