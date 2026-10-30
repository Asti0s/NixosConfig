{
  config,
  pkgs,
  ...
}:

{
  home = {
    packages = with pkgs; [
      pi-coding-agent
    ];

    file = {
      ".pi/agent/settings.json".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/NixosConfig/config/pi/settings.json";
      ".pi/agent/AGENTS.md".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/NixosConfig/config/pi/AGENTS.md";
    };

    # Necessary for OSC52 clipboard support in tmux and PI
    sessionVariables.PI_CLIPBOARD_OSC52 = "1";
  };
}
