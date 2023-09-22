{ pkgs, ... }:
{
  imports = [
    ./packages.nix
    ./persist.nix
    ./users.nix
    ./hardware
  ];

  virtualisation = {
    libvirtd = {
      qemu = {
        verbatimConfig = ''
          cgroup_device_acl = [
            "/dev/null", "/dev/full", "/dev/zero", 
            "/dev/random", "/dev/urandom",
            "/dev/ptmx", "/dev/kvm", "/dev/kqemu",
            "/dev/rtc","/dev/hpet", "/dev/kvmfr0",
            "/dev/input/by-id/uinput-persist-keyboard0",
            "/dev/input/by-id/uinput-persist-mouse0"
          ]
        '';
      };
      enable = true;
    };

    kvmfr = {
      shm = {
        group = "libvirtd";
        user = "emileet";
        enable = true;
      };
      enable = true;
    };

    docker.enable = true;
  };

  services = {
    persistent-evdev = {
      devices = {
        persist-mouse0 = "usb-Glorious_Model_O_Wireless_000000000000-event-mouse";
        persist-keyboard0 = "usb-Qwertykeys_QK65_Hotswap-if02-event-kbd";
      };
      enable = true;
    };

    openssh = {
      settings = {
        KbdInteractiveAuthentication = false;
        PasswordAuthentication = false;
      };
      ports = [ 2269 ];
      enable = true;
    };

    flatpak.enable = true;
    tumbler.enable = true;
    gvfs.enable = true;
  };

  systemd = {
    services = {
      init-liquidctl = {
        description = "initialise liquidctl";
        wantedBy = [ "default.target" ];
        serviceConfig = {
          Type = "oneshot"; # like all banger yuris :')
          ExecStart = [
            "${pkgs.liquidctl}/bin/liquidctl -m kraken initialize"
            "${pkgs.liquidctl}/bin/liquidctl -m kraken set pump speed 20 80 30 80 40 90 50 100"
            "${pkgs.liquidctl}/bin/liquidctl -m kraken set fan speed 20 40 30 40 35 60 40 60 50 80 60 100"
          ];
        };
      };
    };
    user.services = {
      polkit-gnome-authentication-agent-1 = {
        description = "polkit-gnome-authentication-agent-1";
        wantedBy = [ "graphical-session.target" ];
        wants = [ "graphical-session.target" ];
        after = [ "graphical-session.target" ];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
          Restart = "on-failure";
          TimeoutStopSec = 10;
          RestartSec = 1;
        };
      };
    };
  };

  xdg.portal = {
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    enable = true;
  };

  networking.extraHosts = ''
    10.0.0.2 plsnobully.me git.plsnobully.me cdn.plsnobully.me
  '';

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  time.timeZone = "Australia/Melbourne";

  system.stateVersion = "23.11";
  networking.hostName = "nix";
}
