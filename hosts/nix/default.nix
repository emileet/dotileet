{ pkgs, ... }:
{
  imports = [
    ./users.nix
    ./hardware
    ./packages
  ];

  environment.persistence = {
    "/nix/persist/system" = {
      hideMounts = true;
      directories = [
        "/etc/NetworkManager"
        "/etc/nixos"
        "/etc/ssh"
        "/var/log"
        "/var/tmp"
        "/tmp"
      ];
      files = [
        "/etc/barrier.conf"
      ];
    };
    "/nix/persist/virt" = {
      hideMounts = true;
      directories = [
        "/var/lib/libvirt/qemu/networks"
        "/etc/libvirt/hooks/qemu.d"
      ];
      files = [
        "/var/lib/libvirt/qemu/Windows11.xml"
      ];
    };
  };

  services.openssh = {
    settings = {
      KbdInteractiveAuthentication = false;
      PasswordAuthentication = false;
    };
    ports = [ 2269 ];
    enable = true;
  };

  services.persistent-evdev = {
    devices = {
      persist-mouse0 = "usb-Glorious_Model_O_Wireless_000000000000-event-mouse";
      persist-keyboard0 = "usb-Qwertykeys_QK65_Hotswap-if02-event-kbd";
    };
    enable = true;
  };

  virtualisation = {
    libvirtd = {
      qemu = {
        verbatimConfig = ''
          cgroup_device_acl = [
            "/dev/null", "/dev/full", "/dev/zero", 
            "/dev/random", "/dev/urandom",
            "/dev/ptmx", "/dev/kvm", "/dev/kqemu",
            "/dev/rtc","/dev/hpet",
            "/dev/input/by-id/uinput-persist-keyboard0",
            "/dev/input/by-id/uinput-persist-mouse0"
          ]
        '';
      };
      enable = true;
    };
    docker.enable = true;
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  time.timeZone = "Australia/Melbourne";

  system.stateVersion = "23.11";
  networking.hostName = "nix";
}
