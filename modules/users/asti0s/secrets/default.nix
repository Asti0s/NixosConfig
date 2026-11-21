{inputs, ...}: {
  flake.aspects.asti0s-secrets.nixos = {
    imports = [
      inputs.sops-nix.nixosModules.sops
    ];
    sops = {
      age.keyFile = "/var/lib/sops-nix/key.txt";
      defaultSopsFile = ./secrets.json;
      defaultSopsFormat = "json";
      secrets = {
        PROTON_PASS_PERSONAL_ACCESS_TOKEN.owner = "asti0s";
        OPENROUTER_API_KEY.owner = "asti0s";
        TINYFISH_API_KEY.owner = "asti0s";
        EXA_API_KEY.owner = "asti0s";
      };
    };
  };
}
