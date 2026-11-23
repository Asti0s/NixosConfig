{lib, ...}: {
  flake.aspects = {aspects, ...}: {
    mkPiAgent = {
      tinyfishKeyFile,
      exaKeyFile,
      openrouterKeyFile,
    }: {
      nixos = {
        lib,
        config,
        pkgs,
        ...
      }: {
        imports = [
          ./_pi-bolt.nix
          ./_settings.nix
          ./_append-system.nix
          (import ./_models.nix {inherit openrouterKeyFile;})
          (import ./_web-search.nix {
            inherit tinyfishKeyFile exaKeyFile;
          })
        ];

        options.piAgent.files = {
          models = lib.mkOption {type = lib.types.path;};
          settings = lib.mkOption {type = lib.types.path;};
          webSearch = lib.mkOption {type = lib.types.path;};
          appendSystem = lib.mkOption {type = lib.types.path;};
        };

        config = {
          nixpkgs.overlays = [
            (final: _: {
              pi-wrapped = final.writeShellScriptBin "pi" ''
                agentDir="$HOME/.pi/agent"
                mkdir -p "$agentDir"
                ln -sf ${config.piAgent.files.models} "$agentDir/models.json"
                ln -sf ${config.piAgent.files.settings} "$agentDir/settings.json"
                ln -sf ${config.piAgent.files.webSearch} "$agentDir/web-search.json"
                ln -sf ${config.piAgent.files.appendSystem} "$agentDir/APPEND_SYSTEM.md"
                export PI_SKIP_VERSION_CHECK=1
                export PIBOLT_NO_AUTO_UPDATE=1
                exec ${final.pi-bolt}/bin/pi "$@"
              '';
            })
          ];

          environment.systemPackages = [pkgs.pi-wrapped];
        };
      };
    };
  };
}
