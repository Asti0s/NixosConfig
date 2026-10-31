{
  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      nixos-wsl,
      home-manager,
      stylix,
      ...
    }:
    {
      nixosConfigurations = {
        asti0s-tty-wsl = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            nixos-wsl.nixosModules.default
            home-manager.nixosModules.home-manager
            stylix.nixosModules.stylix
            ./base.nix
            ./hosts/wsl.nix
            ./users/asti0s-tty
          ];
        };
        asti0s-laptop = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            home-manager.nixosModules.home-manager
            stylix.nixosModules.stylix
            ./base.nix
            ./hosts/laptop.nix
            ./users/asti0s
          ];
        };
      };
    };
}
