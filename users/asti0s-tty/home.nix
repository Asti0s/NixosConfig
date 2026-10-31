{
  pkgs,
  ...
}:

{
  imports = [
    (import ../shared/home-modules/shell.nix {
      add_tmux = true;
      add_eza = true;
      add_fzf = true;
      add_zoxide = true;
      add_bat = true;
      add_starship = true;
    })
    ../shared/home-modules/proton-pass-cli.nix
    ../shared/home-modules/micro.nix
    ../shared/home-modules/git.nix
    ../shared/home-modules/pi-agent.nix
  ];

  home = {
    stateVersion = "26.05";

    packages = with pkgs; [
      nodejs
      gh
      wget
      tree
      nixfmt
      dnsutils
      openssl
    ];
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
