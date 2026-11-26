{
  inputs,
  config,
  ...
}: {
  flake.aspects.homelab = {
    nixos = {...}: {
      imports = [
        inputs.disko.nixosModules.disko
        ./_hardware-configuration.nix
      ];

      system.stateVersion = "26.05";
      nixpkgs.hostPlatform = "x86_64-linux";
      networking.hostName = "homelab";

      disko.devices.disk.main = {
        device = "/dev/disk/by-id/ata-Micron_1100_MTFDDAK256TBN_172617EF6673";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "1G";
              type = "ef00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "crypted";
                settings.allowDiscards = true;
                content = {
                  type = "btrfs";
                  extraArgs = ["-f"];
                  subvolumes = {
                    "@" = {
                      mountpoint = "/";
                    };
                    "@nix" = {
                      mountpoint = "/nix";
                    };
                  };
                };
              };
            };
          };
        };
      };

      console.earlySetup = true;
      console.keyMap = "fr";

      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      services.openssh.enable = true;
      users.users.root = {
        hashedPassword = "$y$j9T$RZT7anTOhICo/0B0cwaeO.$YZO3E.8EdW7XpT3Wfh.eEPIvzVEY4FNf/UdyjkHM7m6";
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEjBEog3bjL+9Fj1ytvkDL/bZc8uFoPM0cfV0EQNUn8A admin@homelab"
        ];
      };
    };
  };

  flake.nixosConfigurations.homelab = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      config.flake.modules.nixos.homelab
    ];
  };
}
