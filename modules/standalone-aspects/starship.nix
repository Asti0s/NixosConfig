{inputs, ...}: {
  flake.aspects.starship = {
    nixos = {pkgs, ...}: let
      starship-wrapped = inputs.nix-wrapper-modules.wrappers.starship.wrap {
        inherit pkgs;
        preset = [
          "nerd-font-symbols"
        ];
      };
    in {
      environment.systemPackages = [
        starship-wrapped
      ];
    };
  };
}
