{ lib, config, pkgs, ... }:

{
  home = {
    stateVersion = "26.05";

    packages = with pkgs; [
      proton-pass-cli
      zsh-powerlevel10k
      meslo-lgs-nf
      pi-coding-agent
      nodejs
      wget
      tree
      gh
    ];

    file.".p10k.zsh".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/NixosConfig/config/p10k.zsh";
    file.".pi/agent/settings.json".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/NixosConfig/config/pi/settings.json";
    file.".pi/agent/AGENTS.md".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/NixosConfig/config/pi/AGENTS.md";

    sessionVariables.SSH_AUTH_SOCK = "$HOME/.ssh/proton-pass-agent.sock";
  };

  programs.git = {
    enable = true;
    settings.user = {
      name  = "Asti0s";
      email = "contact@astios.dev";
    };
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    autocd = true;

    shellAliases = {
      ll = "ls -l";
    };

    # history options: https://github.com/nix-community/home-manager/blob/master/modules/programs/zsh/history.nix
    history = {
      append = true;
      path = "$HOME/.zsh_history";
      ignoreAllDups = true;
      findNoDups = true;
      ignoreSpace = true;
      expireDuplicatesFirst = true;
      extended = true;
      share = true;
    };

    initContent = lib.mkBefore ''
      # Load p10k theme + my p10k settings
      if [[ "$TERM" != "linux" ]]; then
        source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
        [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
      else
        PROMPT='%n@%m %~ %# '
      fi
    '';
  };

  systemd.user.services.proton-pass-ssh-agent = {
    Unit.Description = "Proton Pass SSH agent";
    Service = {
      ExecStart = "${pkgs.proton-pass-cli}/bin/pass-cli ssh-agent start --socket-path %h/.ssh/proton-pass-agent.sock";
      Restart = "on-failure";
      RestartSec = 5;
    };
    Install.WantedBy = [ "default.target" ];
  };
}
