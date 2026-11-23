{inputs, ...}: {
  flake.aspects = {aspects, ...}: {
    mkSecrets = {
      defaultSopsFile,
      defaultSopsFormat ? "json",
      secrets,
    }: {
      nixos = {
        imports = [
          inputs.sops-nix.nixosModules.sops
        ];
        sops = {
          inherit defaultSopsFile defaultSopsFormat;
          inherit secrets;
        };
      };
    };
  };
}
