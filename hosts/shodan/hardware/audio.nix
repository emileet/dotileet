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
    pipewire = {
      wireplumber = {
        extraScripts."wavedevicefix.lua" = builtins.readFile ./wave3/wavedevicefix.lua;
        extraConfig."51-wave3" = import ./wave3;
      };
      enable = true;
    };
  };
}
