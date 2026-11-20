{
  flake.aspects.user-asti0s = {
    nixos = {pkgs, ...}: {
      users.users.asti0s = {
        isNormalUser = true;
        initialPassword = "changeme";
        uid = 1000;
        extraGroups = [
          "wheel"
          "networkmanager"
        ];
      };

      environment.systemPackages = with pkgs; [git hello];
    };
  };
}
