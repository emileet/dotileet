{ pkgs, ... }:
{
  imports = [
    ./packages.nix
    ./persist.nix
    ./users.nix
    ./hardware
  ];

  programs = {
    obs-studio.enable = true;
    steam.enable = true;
    zsh.shellAliases = {
      update = "nh os switch -j 3 --cores 18";
      bupdate = "nh os boot -j 3 --cores 18"; # pronounced boop-date
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

  systemd.user.services.vncserver = {
    description = "remote desktop service (vnc)";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.tigervnc}/bin/x0vncserver -rfbauth /nix/secrets/vnc/emileet";
      Restart = "always";
      RestartSec = 3;
    };
  };

  networking = {
    bridges."br0".interfaces = [ "enp69s0" ];
    interfaces = {
      enp69s0.useDHCP = true;
      br0.useDHCP = true;
    };

    extraHosts = ''
      10.0.0.11 plsnobully.me git.plsnobully.me
    '';

    networkmanager.enable = true;
    firewall.enable = false;
    hostName = "nix";
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  time.timeZone = "Australia/Melbourne";
  system.stateVersion = "26.05";
}
