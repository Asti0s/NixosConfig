{inputs, ...}: {
  imports = [
    ../shared/system-modules/asti0s-base.nix
    ../shared/system-modules/sway.nix
  ];

  home-manager = {
    sharedModules = [
      inputs.nvf.homeModules.nvf
    ];
    useGlobalPkgs = true;
    useUserPackages = true;
    users.asti0s = import ./home.nix;
  };
}
