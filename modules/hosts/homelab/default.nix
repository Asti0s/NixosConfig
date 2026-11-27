{
  inputs,
  config,
  ...
}: {
  flake = {
    aspects = {aspects, ...}: {
      homelab = {
        includes = with aspects; [
          nix-store-optimization
          swap
        ];

        nixos = {pkgs, ...}: {
          imports = [
            inputs.disko.nixosModules.disko
            inputs.lanzaboote.nixosModules.lanzaboote
            ./_hardware-configuration.nix
          ];

          system.stateVersion = "26.05";
          nixpkgs.hostPlatform = "x86_64-linux";

          environment.systemPackages = with pkgs; [
            cryptsetup
            sbctl
            dnsutils
            curl
          ];

          services = {
            fwupd.enable = true;
            resolved.enable = false;
            openssh.enable = true;
            dnscrypt-proxy = {
              enable = true;
              settings = {
                listen_addresses = ["127.0.0.1:53"];
                ipv4_servers = true;
                ipv6_servers = false;
                server_names = ["cloudflare"];
                ignore_system_dns = true;
              };
            };
          };

          networking = {
            hostName = "homelab";
            useDHCP = false;
            defaultGateway = "192.168.1.1";
            nameservers = ["127.0.0.1"];
            interfaces.enp2s0.ipv4.addresses = [
              {
                address = "192.168.1.28";
                prefixLength = 24;
              }
            ];
          };

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
                          mountOptions = ["compress=zstd" "noatime"];
                        };
                        "@nix" = {
                          mountpoint = "/nix";
                          mountOptions = ["compress=zstd" "noatime"];
                        };
                      };
                    };
                  };
                };
              };
            };
          };

          console = {
            earlySetup = true;
            keyMap = "fr";
          };

          boot = {
            loader = {
              systemd-boot = {
                enable = false;
                configurationLimit = 4;
              };
              efi.canTouchEfiVariables = true;
            };
            lanzaboote = {
              enable = true;
              pkiBundle = "/var/lib/sbctl";
              autoGenerateKeys.enable = true;
              autoEnrollKeys = {
                enable = true;
                autoReboot = true;
              };
            };
            initrd.luks.devices.crypted.crypttabExtraOpts = ["tpm2-device=auto"];
          };

          users.users.root = {
            hashedPassword = "$y$j9T$RZT7anTOhICo/0B0cwaeO.$YZO3E.8EdW7XpT3Wfh.eEPIvzVEY4FNf/UdyjkHM7m6";
            openssh.authorizedKeys.keys = [
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEjBEog3bjL+9Fj1ytvkDL/bZc8uFoPM0cfV0EQNUn8A admin@homelab"
            ];
          };
        };
      };

      colmenaHive = inputs.colmena.lib.makeHive {
        meta = {
          name = "homelab";
          description = "Homelab server";
          nixpkgs = import inputs.nixpkgs {
            system = "x86_64-linux";
            overlays = [];
          };
        };

        homelab = {
          deployment = {
            targetHost = "192.168.1.28";
            targetUser = "root";
          };

          imports = [
            config.flake.modules.nixos.homelab
          ];
        };
      };

      nixosConfigurations.homelab = inputs.nixpkgs.lib.nixosSystem {
        modules = [
          config.flake.modules.nixos.homelab
        ];
      };
    };
  };
}
