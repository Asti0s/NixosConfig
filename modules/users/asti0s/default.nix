{
  flake.aspects = {aspects, ...}: {
    user-asti0s = {
      includes = [aspects.pi-agent aspects.asti0s-secrets];
      nixos = {
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
