{
  flake.aspects.nix-store-optimization = {
    nixos = {
      nix = {
        optimise.automatic = true;
        gc = {
          automatic = true;
          dates = "weekly";
          options = "--delete-older-than 7d";
        };
      };
    };
  };
}
