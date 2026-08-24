{
  "wireplumber.components" = [
    {
      name = "wavedevicefix.lua";
      type = "script/lua";
      provides = "custom.wave3fix";
    }
  ];
  "wireplumber.profiles" = {
    main = {
      "custom.wave3fix" = "required";
    };
  };
  "monitor.alsa.rules" = [
    {
      matches = [
        {
          "node.name" = "~alsa_output.usb-Elgato_Systems_Elgato_Wave_3_*";
        }
      ];
      actions = {
        update-props = {
          "node.disabled" = true;
        };
      };
    }
    {
      matches = [
        {
          "node.name" = "~alsa_input.usb-Elgato_Systems_Elgato_Wave_3_*";
        }
      ];
      actions = {
        update-props = {
          "node.name" = "wave3-source";
          "node.description" = "Wave:3 Microphone";
          "node.nick" = "Wave:3 Mic";
          "priority.session" = 2000;
          "priority.driver" = 2000;
          "audio.rate" = 48000;
          "node.pause-on-idle" = false;
          "session.suspend-timeout-seconds" = 0;
        };
      };
    }
    {
      matches = [
        {
          "node.name" = "~alsa_card.usb-Elgato_Systems_Elgato_Wave_3_*";
        }
      ];
      actions = {
        update-props = {
          "device.description" = "Elgato Wave:3";
          "device.nick" = "Wave:3";
        };
      };
    }
  ];
}
