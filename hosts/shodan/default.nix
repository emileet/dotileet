{ pkgs, ... }:
{
  imports = [
    ./packages.nix
    ./persist.nix
    ./users.nix
    ./hardware
  ];

  programs = {
    steam.enable = true;
    zsh.shellAliases = {
      update = "sudo nixos-rebuild switch -j 3 --cores 12";
      bupdate = "sudo nixos-rebuild boot -j 3 --cores 12"; # pronounced boop-date
    };
  };

  services = {
    udev.extraRules = ''
      SUBSYSTEM=="input", ATTRS{idVendor}=="4f53", ATTRS{idProduct}=="514b", ENV{ID_INPUT_JOYSTICK}="" 
      KERNEL=="ntsync" MODE="0644"
    '';

    persistent-evdev = {
      devices = {
        persist-mouse0 = "usb-Glorious_Model_O_Wireless_000000000000-event-mouse";
        persist-keyboard0 = "usb-Qwertykeys_QK65_Hotswap-if02-event-kbd";
      };
      enable = true;
    };

    avahi = {
      enable = true;
      publish = {
        enable = true;
        userServices = true;
      };
    };

    openssh.enable = true;
    flatpak.enable = true;
    tumbler.enable = true;
    gvfs.enable = true;
  };

  systemd.user.services.openrgb-profile = {
    description = "load openrgb profile";
    wantedBy = [ "default.target" ];
    enable = true;
    serviceConfig = {
      ExecStart = "${pkgs.openrgb}/bin/openrgb -p shodan.orp";
      Type = "oneshot";
    };
  };

  networking.extraHosts = ''
    10.0.0.2 plsnobully.me git.plsnobully.me cdn.plsnobully.me
  '';

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  time.timeZone = "Australia/Melbourne";

  system.stateVersion = "26.05";
  networking.hostName = "shodan";
}
