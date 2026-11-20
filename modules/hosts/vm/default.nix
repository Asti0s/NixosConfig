{
  inputs,
  config,
  ...
}: {
  flake.nixosConfigurations.vm-asti0s = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      config.flake.modules.nixos.user-asti0s
      {
        system.stateVersion = "26.05";
        nixpkgs.hostPlatform = "x86_64-linux";
      }
    ];
  };

  flake.nixosConfigurations.vm-molecular = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      config.flake.modules.nixos.user-molecular
      {
        system.stateVersion = "26.05";
        nixpkgs.hostPlatform = "x86_64-linux";
      }
    ];
  };
}
