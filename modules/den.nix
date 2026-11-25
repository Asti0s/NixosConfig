{
  inputs,
  den,
  lib,
  ...
}: {
  imports = [inputs.den.flakeModule];

  den = {
    default.nixos.system.stateVersion = "26.11";
    reservedKeys = ["settings"];
    schema.host.imports = [
      {
        options.settings = lib.mkOption {
          type = import ./_settings-type.nix {inherit den lib;};
          default = {};
          description = "Per-aspect typed settings";
        };
      }
    ];
  };
}
