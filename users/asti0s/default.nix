{
  nvfModule,
  ...
}:

{
  imports = [
    ../shared/system-modules/asti0s-base.nix
    ../shared/system-modules/sway.nix
  ];

  home-manager = {
    extraSpecialArgs = {
      inherit nvfModule;
    };
    useGlobalPkgs = true;
    useUserPackages = true;
    users.asti0s = import ./home.nix;
  };
}
