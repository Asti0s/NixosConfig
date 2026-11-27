{
  inputs,
  config,
  ...
}: {
  flake.aspects = {aspects, ...}: {
    vm = {
      includes = with aspects; [
        nix-store-optimization
        swap
        asti0s
      ];

      nixos = {
        system.stateVersion = "26.05";
        nixpkgs.hostPlatform = "x86_64-linux";
      };
    };
  };

  flake.nixosConfigurations.vm = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      config.flake.modules.nixos.vm
    ];
  };
}
