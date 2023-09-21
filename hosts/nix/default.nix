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
    user.services.polkit-gnome-authentication-agent-1 = {
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

  xdg.portal = {
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    enable = true;
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  time.timeZone = "Australia/Melbourne";

  system.stateVersion = "23.11";
  networking.hostName = "nix";
}
