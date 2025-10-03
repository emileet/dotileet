{
  lib,
  pkgs,
  config,
  osConfig,
  ...
}:
with lib;
let
  i3Enabled = osConfig.services.xserver.windowManager.i3.enable;
  hostName = osConfig.networking.hostName;
  cfg = config.xsession.windowManager.i3;
in
{
  options.xsession.windowManager.i3 = {
    wallpaper = mkOption {
      type = types.str;
      default = "";
      description = "wallpaper path";
    };
  };

  config = mkIf i3Enabled {
    home.packages = with pkgs; [ autotiling ];

    services = {
      polybar.enable = true;
      picom.enable = true;
    };

    xsession.windowManager.i3 = {
      enable = true;
      config =
        let
          ws1 = "1:一";
          ws2 = "2:二";
          ws3 = "3:三";
          ws4 = "4:四";
          ws5 = "5:五";
          ws6 = "6:六";
          ws7 = "7:七";
          ws8 = "8:八";
          ws9 = "9:九";
          ws10 = "10:十";
        in
        {
          startup = [
            (mkIf osConfig.services.flatpak.enable {
              command = "systemctl --user import-environment PATH && systemctl --user restart xdg-desktop-portal";
              notification = false;
              always = true;
            })
            (mkIf (cfg.wallpaper != "") {
              command = "${pkgs.feh}/bin/feh --bg-fill ${cfg.wallpaper}";
              notification = false;
              always = false;
            })
            {
              command = "systemctl --user restart polybar";
              notification = false;
              always = false;
            }
            {
              command = "deskflow-core server -c /etc/deskflow-server.conf";
              notification = false;
              always = false;
            }
            {
              command = "flameshot &";
              notification = false;
              always = true;
            }
            {
              command = "autotiling";
              notification = false;
              always = true;
            }
          ];

          assigns = {
            #"${ws1}" = [{ class = "looking-glass-client"; }];
          };

          window = {
            commands = [
              {
                command = "floating enable, move container to workspace ${ws1}, move position center";
                criteria.class = "vmileet";
              }
              {
                command = "floating enable, move container to workspace ${ws2}, move position center";
                criteria.class = "Lunar Client.*";
              }
              {
                command = "move container to workspace ${ws1}";
                criteria.class = "ffxiv_dx11.exe";
              }
              {
                command = "move container to workspace ${ws10}";
                criteria.class = "conhost.exe"; # discord rich presence on wine
              }
              {
                command = "floating enable";
                criteria.class = "looking-glass-client";
              }
              {
                command = "border pixel 0";
                criteria.class = "^.*";
              }
            ];
            border = 0;
          };

          keybindings =
            let
              modifier = cfg.config.modifier;
            in
            {
              "${modifier}+d" =
                ''exec --no-startup-id ${pkgs.rofi}/bin/rofi -modi drun -show drun -display-drun "run" -config ~/.config/rofi/config'';
              "${modifier}+Shift+p" = "exec --no-startup-id sh ~/.config/i3/scripts/toggle-service.sh picom";
              "${modifier}+Return" = "exec --no-startup-id wezterm";

              "${modifier}+Shift+e" =
                ''exec "i3-nagbar -t warning -m 'Do you really want to exit i3? This will end your X session.' -B 'Yes, exit i3' 'i3-msg exit'"'';
              "${modifier}+Shift+r" = "restart";
              "${modifier}+Shift+c" = "reload";
              "${modifier}+Shift+q" = "kill";

              "${modifier}+Shift+space" = "floating toggle";
              "${modifier}+Shift+f" = "fullscreen toggle";
              "${modifier}+space" = "focus mode_toggle";
              "${modifier}+r" = ''mode "resize"'';
              "${modifier}+a" = "focus parent";

              "${modifier}+Right" = "focus right";
              "${modifier}+Left" = "focus left";
              "${modifier}+Down" = "focus down";
              "${modifier}+Up" = "focus up";

              "${modifier}+Shift+Right" = "move right";
              "${modifier}+Shift+Left" = "move left";
              "${modifier}+Shift+Down" = "move down";
              "${modifier}+Shift+Up" = "move up";

              "${modifier}+e" = "layout toggle split";
              "${modifier}+s" = "layout stacking";
              "${modifier}+w" = "layout tabbed";

              "${modifier}+h" = "split h";
              "${modifier}+v" = "split v";

              "${modifier}+1" = "workspace number ${ws1}";
              "${modifier}+2" = "workspace number ${ws2}";
              "${modifier}+3" = "workspace number ${ws3}";
              "${modifier}+4" = "workspace number ${ws4}";
              "${modifier}+5" = "workspace number ${ws5}";
              "${modifier}+6" = "workspace number ${ws6}";
              "${modifier}+7" = "workspace number ${ws7}";
              "${modifier}+8" = "workspace number ${ws8}";
              "${modifier}+9" = "workspace number ${ws9}";
              "${modifier}+0" = "workspace number ${ws10}";

              "${modifier}+Shift+1" = "move container to workspace ${ws1}";
              "${modifier}+Shift+2" = "move container to workspace ${ws2}";
              "${modifier}+Shift+3" = "move container to workspace ${ws3}";
              "${modifier}+Shift+4" = "move container to workspace ${ws4}";
              "${modifier}+Shift+5" = "move container to workspace ${ws5}";
              "${modifier}+Shift+6" = "move container to workspace ${ws6}";
              "${modifier}+Shift+7" = "move container to workspace ${ws7}";
              "${modifier}+Shift+8" = "move container to workspace ${ws8}";
              "${modifier}+Shift+9" = "move container to workspace ${ws9}";
              "${modifier}+Shift+0" = "move container to workspace ${ws10}";

              "${modifier}+Shift+l" = ''mode "layouts"'';
              "${modifier}+Shift+o" = ''mode "sizes"'';
              "${modifier}+Shift+g" = ''mode "gaps"'';

              "Shift+Print" = "exec --no-startup-id flameshot gui -c";
              "Print" = "exec --no-startup-id flameshot screen -c";
            };

          modes = {
            resize = {
              "Left" = "resize shrink width 10 px or 10 ppt";
              "Down" = "resize grow height 10 px or 10 ppt";
              "Up" = "resize shrink height 10 px or 10 ppt";
              "Right" = "resize grow width 10 px or 10 ppt";
              "Shift+Left" = "resize shrink width 1 px";
              "Shift+Down" = "resize grow height 1 px";
              "Shift+Up" = "resize shrink height 1 px";
              "Shift+Right" = "resize grow width 1 px";
              "Escape" = "mode default";
              "Return" = "mode default";
            };
            layouts = {
              "1" = "mode default, append_layout ~/.i3/workspace-1.json";
              "2" = "mode default, append_layout ~/.i3/workspace-2.json";
              "3" = "mode default, append_layout ~/.i3/workspace-3.json";
              "4" = "mode default, append_layout ~/.i3/workspace-4.json";
              "5" = "mode default, append_layout ~/.i3/workspace-5.json";
              "6" = "mode default, append_layout ~/.i3/workspace-6.json";
              "7" = "mode default, append_layout ~/.i3/workspace-7.json";
              "8" = "mode default, append_layout ~/.i3/workspace-8.json";
              "9" = "mode default, append_layout ~/.i3/workspace-9.json";
              "0" = "mode default, append_layout ~/.i3/workspace-10.json";
              "Escape" = "mode default";
              "Return" = "mode default";
            };
            sizes = {
              "1" = "mode default, floating enable, resize set 5120 1390, move position center";
              "2" = "mode default, floating enable, resize set 1920 1080, move position center";
              "3" = "mode default, floating enable, resize set 1600 900, move position center";
              "4" = "mode default, floating enable, resize set 1280 720, move position center";
              "Escape" = "mode default";
              "Return" = "mode default";
            };
            gaps = {
              "0" =
                "mode default, gaps inner all set 0, gaps outer all set 0, gaps bottom all set 25, gaps top all set 25";
              "1" = "mode default, gaps inner all set 25, gaps outer all set 40";
              "Escape" = "mode default";
              "Return" = "mode default";
            };
          };

          colors = {
            focusedInactive = {
              border = "#100d1f99";
              background = "#100d1f99";
              text = "#ffffff";
              indicator = "";
              childBorder = "";
            };

            focused = {
              border = "#100d1f99";
              background = "#100d1f99";
              text = "#ffffff";
              indicator = "";
              childBorder = "";
            };

            unfocused = {
              border = "#100d1f50";
              background = "#100d1f50";
              text = "#ffffff";
              indicator = "";
              childBorder = "";
            };

            placeholder = {
              border = "#100d1f50";
              background = "#100d1f50";
              text = "#ffffff";
              indicator = "";
              childBorder = "";
            };

            urgent = {
              border = "#100d1f50";
              background = "#100d1f50";
              text = "#ffffff";
              indicator = "#900000";
              childBorder = "#900000";
            };

            background = "#100d1f00";
          };

          fonts = {
            names = [ "Liga SFMono Nerd Font" ];
            style = "Regular";
            size = 9.0;
          };

          gaps = {
            inner = 25;
            outer = 40;
          };

          modifier = "Mod4";
          bars = [ ];
        };
    };

    home.file."${config.xdg.configHome}/i3/scripts" = {
      source = ./scripts;
      recursive = true;
    };

    systemd.user.services.polkit-gnome-authentication-agent-1 = {
      Unit = {
        Description = "polkit-gnome-authentication-agent-1";
        After = [ "graphical-session-pre.target" ];
        PartOf = [ "graphical-session.target" ];
      };

      Service = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        TimeoutStopSec = 10;
        RestartSec = 1;
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
