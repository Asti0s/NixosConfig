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
  };

  outputs = { self, nixpkgs, nixos-wsl, home-manager, ... }: {
    nixosConfigurations.imm_wsl = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        nixos-wsl.nixosModules.default
        home-manager.nixosModules.home-manager
        ({ pkgs, ... }: {
          nixpkgs.config.allowUnfree = true;
          system.stateVersion = "26.05";
          users.users.asti0s.shell = pkgs.zsh;

          wsl = {
            enable = true;
            defaultUser = "asti0s";
          };

          programs = {
            zsh.enable = true;
            nix-ld.enable = true;
          };

          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.asti0s = import ./home.nix;
          };
        })
      ];
    };
  };
}
