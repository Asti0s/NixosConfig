{
  imports = [
    ../shared/home-modules/asti0s-base.nix
    ../shared/home-modules/sway.nix
    ../shared/home-modules/waybar.nix
  ];

  gtk = {
    enable = true;
    font = {
      name = "Inter";
      size = 10;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "qtct";
  };

  xdg.configFile."qt5ct/qt5ct.conf".text = ''
    [Fonts]
    general="Inter,10,-1,5,50,0,0,0,0,0"
    fixed="JetBrainsMono Nerd Font,10,-1,5,50,0,0,0,0,0"
  '';
  xdg.configFile."qt6ct/qt6ct.conf".text = ''
    [Fonts]
    general="Inter,10,-1,5,50,0,0,0,0,0"
    fixed="JetBrainsMono Nerd Font,10,-1,5,50,0,0,0,0,0"
  '';
}
