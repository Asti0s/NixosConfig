{inputs, ...}: {
  imports = [
    ../shared/system-modules/asti0s-base.nix
  ];

  home-manager = {
    sharedModules = [
      inputs.nvf.homeModules.default
    ];
    useGlobalPkgs = true;
    useUserPackages = true;
    users.asti0s = import ./home.nix;
  };
}
