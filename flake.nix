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
    nvf = {
      url = "github:NotAShelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: {
    nixosConfigurations = {
      asti0s-terminal-wsl = inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {
          nvfModule = inputs.nvf.homeManagerModules.default;
        };
        modules = [
          inputs.nixos-wsl.nixosModules.default
          inputs.home-manager.nixosModules.home-manager
          ./hosts/wsl.nix
          ./users/asti0s-terminal
        ];
      };
      asti0s-laptop = inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {
          nvfModule = inputs.nvf.homeManagerModules.default;
        };
        modules = [
          inputs.home-manager.nixosModules.home-manager
          ./hosts/laptop.nix
          ./users/asti0s
        ];
      };
    };
  };
}
