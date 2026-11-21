{
  inputs,
  config,
  ...
}: let
  homelabModules = [
    config.flake.modules.nixos.user-admin
    config.flake.modules.nixos.user-deploy
    {
      system.stateVersion = "26.05";
      nixpkgs.hostPlatform = "x86_64-linux";
      networking.hostName = "homelab";

      # ONLY FOR THE FIRST DEPLOYMENT - needed by colmena to create the deploy user
      # users.users.root.openssh.authorizedKeys.keys = [
      #   "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEjBEog3bjL+9Fj1ytvkDL/bZc8uFoPM0cfV0EQNUn8A admin@homelab"
      # ];

      services.openssh = {
        enable = true;
        settings = {
          PermitRootLogin = "no";
          PasswordAuthentication = false;
        };
      };
    }
  ];
in {
  flake.nixosConfigurations.homelab-deploy = inputs.nixpkgs.lib.nixosSystem {
    modules = homelabModules;
  };

  flake.colmenaHive = inputs.colmena.lib.makeHive {
    meta.nixpkgs = import inputs.nixpkgs {
      system = "x86_64-linux";
      overlays = [];
    };

    homelab = {
      imports =
        [
          "${inputs.nixpkgs}/nixos/modules/virtualisation/incus-virtual-machine.nix"
        ]
        ++ homelabModules;

      deployment = {
        targetHost = "10.235.145.3";
        targetUser = "deploy";
      };

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
          };
        };
      };
    };
  };
}
