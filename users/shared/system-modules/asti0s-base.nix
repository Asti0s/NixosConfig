{ pkgs, ... }:

{
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

  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
    fonts.monospace = {
      name = "JetBrainsMono Nerd Font";
      package = pkgs.nerd-fonts.jetbrains-mono;
    };
  };

  programs.zsh.enable = true;
  programs.nix-ld.enable = true;
}
