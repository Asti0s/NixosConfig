{
  config,
  lib,
  pkgs,
  ...
}:

{
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "26.05";
  users.users.asti0s.shell = pkgs.zsh;

  wsl = {
    enable = true;
    defaultUser = "asti0s";
  };

  programs = {
    zsh.enable = true;
    nix-ld.enable = true;
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.asti0s = import ./home.nix;
  };
}
