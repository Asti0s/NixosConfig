{inputs, ...}: {
  flake.aspects = {aspects, ...}: {
    asti0s = {
      includes = [
        aspects.pi-agent
      ];
      nixos = {config, ...}: {
        imports = [
          inputs.sops-nix.nixosModules.sops
        ];

        sops = {
          age.keyFile = "/var/lib/sops-nix/key";
          secrets = {
            OPENROUTER_API_KEY = {
              sopsFile = ./secrets/secrets.json;
              owner = "asti0s";
            };
            TINYFISH_API_KEY = {
              sopsFile = ./secrets/secrets.json;
              owner = "asti0s";
            };
            EXA_API_KEY = {
              sopsFile = ./secrets/secrets.json;
              owner = "asti0s";
            };
          };
        };

        pi-agent = {
          openrouterApiKeyFile = config.sops.secrets.OPENROUTER_API_KEY.path;
          tinyfishApiKeyFile = config.sops.secrets.TINYFISH_API_KEY.path;
          exaApiKeyFile = config.sops.secrets.EXA_API_KEY.path;
        };

        users.users.asti0s = {
          isNormalUser = true;
          initialPassword = "changeme";
          uid = 1000;
          extraGroups = [
            "wheel"
            "networkmanager"
          ];
        };
      };
    };
  };
}
