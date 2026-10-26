{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-wsl, home-manager, ... }: {
    nixosConfigurations.imm_wsl = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        nixos-wsl.nixosModules.default
        home-manager.nixosModules.home-manager
        {
          system.stateVersion = "26.05";
          wsl.enable = true;
          wsl.defaultUser = "asti0s";

          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.asti0s = import ./home.nix;
          };
        }
      ];
    };
  };
}
