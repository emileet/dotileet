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
      update = "sudo nixos-rebuild switch -j 4 --cores 16";
      bupdate = "sudo nixos-rebuild boot -j 4 --cores 16"; # pronounced boop-date
    };
  };

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
    user = {
      services = {
        vncserver = {
          description = "remote desktop service (vnc)";
          wantedBy = [ "graphical-session.target" ];
          partOf = [ "graphical-session.target" ];
          serviceConfig = {
            ExecStart = "${pkgs.tigervnc}/bin/x0vncserver -rfbauth /nix/secrets/vnc/emileet";
            Restart = "always";
            RestartSec = 3;
          };
        };
      };
    };
  };

  networking.extraHosts = ''
    10.0.0.2 plsnobully.me git.plsnobully.me cdn.plsnobully.me
  '';

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  time.timeZone = "Australia/Melbourne";

  system.stateVersion = "23.11";
  networking.hostName = "nix";
}
