{
  pkgs,
  ...
}:

{
  imports = [
    (import ./shell.nix {
      add_tmux = true;
      add_eza = true;
      add_fzf = true;
      add_zoxide = true;
      add_bat = true;
      add_starship = true;
    })
    ./proton-pass-cli.nix
    (import ./micro.nix { default_editor = false; })
    (import ./git.nix {
      name = "Asti0s";
      email = "contact@astios.dev";
    })
    ./pi-agent.nix
    (import ./nvim.nix { default_editor = true; })
  ];

  home = {
    stateVersion = "26.05";

    packages = with pkgs; [
      nodejs
      gh
      wget
      tree
      nixfmt
      nixd
      dnsutils
      openssl
    ];
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
