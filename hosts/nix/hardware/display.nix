{ pkgs, ... }:
{
  services.gnome.gnome-keyring.enable = true;

  services.xserver = {
    desktopManager.xterm.enable = false;
    windowManager.i3 = {
      extraSessionCommands = ''
        eval $(gnome-keyring-daemon --daemonize)
        export SSH_AUTH_SOCK
      '';
      package = pkgs.i3-gaps;
      enable = true;
    };

    displayManager = {
      defaultSession = "none+i3";
      lightdm = {
        greeters.mini = {
          extraConfig = ''
            [greeter]
            show-password-label = false
            password-input-width = 28
            [greeter-theme]
            background-color = "#000000"
            window-color = "#1e1e2e"
            border-color = "#11111b"
            border-width = 1px
            password-background-color = "#313244"
            password-border-color = "#11111b"
            password-border-width = 1px
            password-color = "#cdd6f4"
            error-color = "#f38ba8"
            text-color = "#cdd6f4"
          '';
          user = "emileet";
          enable = true;
        };
        background = "/storage/pictures/wallpapers/nightsky-2560.jpg";
        enable = true;
      };
      setupCommands = ''
        LEFT='DisplayPort-1'
        RIGHT='DisplayPort-0'
        ${pkgs.xorg.xrandr}/bin/xrandr --output $LEFT --mode 2560x1440 --rate 165 --primary --output $RIGHT --mode 2560x1440 --rate 165 --right-of $LEFT
      '';
    };

    videoDrivers = [ "amdgpu" ];
    deviceSection = ''
      Option "TearFree" "true"
    '';

    libinput.enable = false;
    layout = "us";

    autorun = true;
    enable = true;
  };
}
