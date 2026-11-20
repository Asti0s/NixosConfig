{
  inputs,
  config,
  ...
}: {
  flake.nixosConfigurations.vps-deploy = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      config.flake.modules.nixos.user-deploy
      {
        system.stateVersion = "26.05";
        nixpkgs.hostPlatform = "x86_64-linux";
      }
    ];
  };
}
