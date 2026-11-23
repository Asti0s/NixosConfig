{
  flake.aspects = {aspects, ...}: {
    user-asti0s = {
      includes = [
        (aspects.mkPiAgent {
          tinyfishKeyFile = "/run/secrets/TINYFISH_API_KEY";
          exaKeyFile = "/run/secrets/EXA_API_KEY";
          openrouterKeyFile = "/run/secrets/OPENROUTER_API_KEY";
        })
        (aspects.mkSecrets {
          defaultSopsFile = ./secrets/secrets.json;
          secrets = {
            PROTON_PASS_PERSONAL_ACCESS_TOKEN.owner = "asti0s";
            OPENROUTER_API_KEY.owner = "asti0s";
            TINYFISH_API_KEY.owner = "asti0s";
            EXA_API_KEY.owner = "asti0s";
          };
        })
      ];
      nixos = {
        sops.age.keyFile = "/var/lib/sops-nix/key.txt";
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
