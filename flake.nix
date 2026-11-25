{
  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    flake-compat = {
      url = "github:NixOS/flake-compat";
      flake = false;
    };
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "flake-compat";
      };
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvf = {
      url = "github:NotAShelf/nvf";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "flake-compat";
      };
    };
    colmena = {
      url = "github:nix-community/colmena";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dendritic = {
      url = "github:Asti0s/NixosConfig/dendritic";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        sops-nix.follows = "sops-nix";
        colmena.follows = "colmena";
      };
    };
  };
  outputs = inputs: {
    nixosConfigurations = {
      asti0s-terminal-wsl = inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
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
          inherit inputs;
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

      homelab = {config, ...}: {
        system.stateVersion = "26.05";
        networking.hostName = "homelab";
        imports = [
          "${inputs.nixpkgs}/nixos/modules/virtualisation/incus-virtual-machine.nix"
          inputs.sops-nix.nixosModules.sops
        ];

        sops = {
          defaultSopsFile = ./secrets/servers.json;
          defaultSopsFormat = "json";
          secrets = {
            "cloudflared-credentials" = {};
          };
        };

        deployment = {
          targetHost = "10.235.145.3";
          targetUser = "root";
        };

        # Cloudflare tunnel
        services.cloudflared = {
          enable = true;

          tunnels."1b14b0e6-4d70-471a-a49f-b588a9e3261f" = {
            credentialsFile = config.sops.secrets.cloudflared-credentials.path;
            default = "http_status:404";
          };
        };

        # SSH config
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

        # Networking
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
      };
    };
  };
}
