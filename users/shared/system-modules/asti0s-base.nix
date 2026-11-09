{pkgs, ...}: {
  users.users.asti0s = {
    isNormalUser = true;
    initialPassword = "changeme";
    shell = pkgs.zsh;
    uid = 1000;
    extraGroups = [
      "wheel"
      "docker"
      "networkmanager"
    ];
  };

  programs.zsh.enable = true;
  programs.nix-ld.enable = true;
}
