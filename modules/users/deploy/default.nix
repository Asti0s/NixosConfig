{
  flake.aspects.user-deploy = {
    nixos = {pkgs, ...}: {
      users.users.deploy = {
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
