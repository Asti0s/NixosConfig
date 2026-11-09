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
    colmena = {
      url = "github:nix-community/colmena";
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
    colmenaHive = inputs.colmena.lib.makeHive {
      meta = {
        nixpkgs = import inputs.nixpkgs {
          system = "x86_64-linux";
          overlays = [];
        };
      };

      homelab = {
        networking.hostName = "homelab";
        system.stateVersion = "26.05";
        imports = [
          "${inputs.nixpkgs}/nixos/modules/virtualisation/incus-virtual-machine.nix"
        ];

        services.openssh = {
          enable = true;
          settings = {
            PermitRootLogin = "prohibit-password";
            PasswordAuthentication = false;
          };
        };

        users.users.root.openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK5knAwQ3/B54DnoT2xlWhyRhUKAwPkg0W924Hcfsg82"
        ];

        networking = {
          dhcpcd.enable = false;
          useDHCP = false;
          useHostResolvConf = false;
        };

        systemd.network = {
          enable = true;
          networks."50-enp5s0" = {
            matchConfig.Name = "enp5s0";
            networkConfig = {
              DHCP = "ipv4";
              IPv6AcceptRA = true;
            };
            linkConfig.RequiredForOnline = "routable";
          };
        };

        deployment = {
          targetHost = "10.235.145.3";
          targetUser = "root";
        };
      };
    };
  };
}
