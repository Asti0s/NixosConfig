{ pkgs, ... }:

{
  wayland.windowManager.sway = {
    enable = true;
    checkConfig = false;
    wrapperFeatures.gtk = true;
    systemd.enable = true;

    package = pkgs.swayfx; # For rounded windows

    config = rec {
      modifier = "Mod4";
      terminal = "foot";
      menu = "fuzzel";

      input."type:keyboard" = {
        xkb_layout = "fr";
      };

      gaps = {
        inner = 10;
        outer = 0;
      };

      window.border = 1;
      window.titlebar = false;
      floating.border = 1;
      floating.titlebar = false;

      keybindings = pkgs.lib.mkOptionDefault {
        "${modifier}+t" = "exec ${terminal}";
        "${modifier}+a" = "exec ${menu}";
        "--locked XF86AudioRaiseVolume" = "exec wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+";
        "--locked XF86AudioLowerVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
        "--locked XF86AudioMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        "--locked XF86MonBrightnessUp" = "exec brightnessctl set 5%+";
        "--locked XF86MonBrightnessDown" = "exec brightnessctl set 5%-";
      };

      startup = [
        { command = "mako"; }
      ];

      bars = [ ];
    };

    extraConfig = ''
      corner_radius 2
    '';
  };

  programs.foot.enable = true;
  programs.fuzzel.enable = true;
  services.mako.enable = true;

  home.packages = with pkgs; [
    wl-clipboard
    brightnessctl
  ];
}
