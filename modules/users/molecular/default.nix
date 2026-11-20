{
  flake.aspects.user-molecular = {
    nixos = {pkgs, ...}: {
      users.users.molecular = {
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
