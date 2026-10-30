{
  pkgs,
  ...
}:

{
  imports = [
    (import ./modules/shell.nix {
      add_tmux = true;
      add_eza = true;
      add_fzf = true;
      add_zoxide = true;
      add_bat = true;
      add_p10k = true;
    })
    ./modules/proton-pass-cli.nix
    ./modules/micro.nix
    ./modules/git.nix
    ./modules/pi-agent.nix
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
