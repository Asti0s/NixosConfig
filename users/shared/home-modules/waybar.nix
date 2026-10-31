{ ... }:

{
  programs.waybar = {
    enable = true;
    systemd.enable = true;

    settings.mainBar = {
      layer = "top";
      position = "top";
      height = 32;

      margin-left = 10;
      margin-right = 10;
      margin-top = 10;

      modules-left = [
        "sway/workspaces"
        "sway/mode"
      ];
      modules-center = [
        "clock"
      ];
      modules-right = [
        "cpu"
        "memory"
        "disk"
        "battery"
      ];

      sway.workspaces = {
        disable-scroll = true;
        all-outputs = true;
      };

      clock = {
        format = "{:%a %d/%m %H:%M}";
        tooltip-format = "<big>{:%A %d %B %Y}</big>\n<tt><small>{calendar}</small></tt>";
      };

      cpu = {
        format = "CPU {usage}%";
        tooltip-format = "{avg_frequency} GHz";
        interval = 2;
      };

      memory = {
        format = "RAM {percentage}%";
        tooltip-format = "{used:0.1f}G / {total:0.1f}G";
        interval = 2;
      };

      disk = {
        format = "DISK {percentage_used}%";
        tooltip-format = "{used} / {total} on {path}";
        interval = 30;
      };

      battery = {
        states = {
          warning = 20;
          critical = 10;
        };
        format = "BAT {capacity}%";
        format-charging = "BAT {capacity}%+";
        format-time = "{H}h{M:02d}";
      };
    };

    style = ''
      * {
        border-radius: 2;
        font-family: "JetBrainsMono Nerd Font", monospace;
        font-size: 13px;
        min-height: 0;
      }

      window#waybar {
        border: none;
      }

      window#waybar {
        background: @base00;
        border: 1px solid @base03;
      }

      #clock,
      #cpu,
      #memory,
      #disk,
      #battery,
      #mode,
      #workspaces button {
        background: @base00;
        border: 1px solid @base02;
        padding: 0 5px;
        margin: 5px 5px 5px 5px;
      }

      #workspaces button.urgent {
        color: @base08;
      }

      #battery.warning {
        color: @base0A;
      }

      #battery.critical {
        color: @base08;
      }
    '';
  };
}
