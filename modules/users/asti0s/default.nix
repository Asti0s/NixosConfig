{
  inputs,
  config,
  ...
}: let
  flakeConfig = config;
in {
  flake.aspects = {aspects, ...}: {
    asti0s = {
      includes = with aspects; [
        pi-agent
      ];

      nixos = {config, ...}: {
        imports = [
          inputs.home-manager.nixosModules.home-manager
        ];

        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          backupFileExtension = "hm-bak";
          users.asti0s = flakeConfig.flake.modules.homeManager.asti0s;
        };

        pi-agent = {
          openrouterApiKeyFile = config.home-manager.users.asti0s.sops.secrets.OPENROUTER_API_KEY.path;
          tinyfishApiKeyFile = config.home-manager.users.asti0s.sops.secrets.TINYFISH_API_KEY.path;
          exaApiKeyFile = config.home-manager.users.asti0s.sops.secrets.EXA_API_KEY.path;
        };

        users.users.asti0s = {
          isNormalUser = true;
          initialPassword = "changeme";
          uid = 1000;
          home = "/home/asti0s";
          extraGroups = [
            "wheel"
            "networkmanager"
          ];
        };
      };

      homeManager = {pkgs, ...}: {
        imports = [
          inputs.sops-nix.homeManagerModules.sops
        ];

        home.stateVersion = "26.05";

        sops = {
          age = {
            keyFile = "/home/asti0s/.config/sops/age/keys.txt";
            plugins = [pkgs.age];
          };
          defaultSopsFormat = "json";
          defaultSopsFile = ./secrets/secrets.json;
          secrets = {
            OPENROUTER_API_KEY = {};
            TINYFISH_API_KEY = {};
            EXA_API_KEY = {};
          };
        };
      };
    };
  };
}
