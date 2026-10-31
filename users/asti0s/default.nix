{
  pkgs,
  ...
}:

{
  console.keyMap = "fr";
  services.xserver.xkb.layout = "fr";
  hardware.graphics.enable = true;

  users.users.asti0s = {
    isNormalUser = true;
    initialPassword = "changeme";
    shell = pkgs.zsh;
    uid = 1000;
    extraGroups = [
      "wheel"
      "docker"
      "networkmanager"
    ];
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.asti0s = import ./home.nix;
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  programs.zsh.enable = true;

  programs.sway = {
    enable = true;
    package = pkgs.swayfx;
    wrapperFeatures.gtk = true;
  };

  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
    fonts.monospace = {
      name = "JetBrainsMono Nerd Font";
      package = pkgs.nerd-fonts.jetbrains-mono;
    };
  };
}
