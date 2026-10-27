{
  lib,
  config,
  pkgs,
  ...
}:

{
  home = {
    stateVersion = "26.05";

    packages = with pkgs; [
      proton-pass-cli
      zsh-powerlevel10k
      pi-coding-agent
      nodejs
      wget
      tree
      gh
      nixfmt
      bat
      openssl
    ];

    file.".p10k.zsh".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/NixosConfig/config/p10k.zsh";
    file.".pi/agent/settings.json".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/NixosConfig/config/pi/settings.json";
    file.".pi/agent/AGENTS.md".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/NixosConfig/config/pi/AGENTS.md";

    sessionVariables = {
      SSH_AUTH_SOCK = "$HOME/.ssh/proton-pass-agent.sock";
      EDITOR = "micro";
      VISUAL = "micro";

      # Necessary for OSC52 clipboard support in tmux and PI
      PI_CLIPBOARD_OSC52 = "1";
    };
  };

  programs.zoxide.enable = true;

  programs.micro = {
    enable = true;
    settings = {
      "colorscheme" = "gruvbox";
      "mkparents" = true;
      "softwrap" = true;
      "tabsize" = 4;
    };
  };

  programs.fzf.enable = true;

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    git = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.tmux = {
    enable = true;
    terminal = "tmux-256color";
    extraConfig = ''
      set -ga terminal-overrides ",*:Tc"

      # https://pi.dev/docs/latest/tmux
      set -g extended-keys on
      set -g extended-keys-format csi-u

      # Necessary for OSC52 clipboard support in tmux and PI
      set -s set-clipboard on

      # Scroll the terminal instead of the history
      set -g mouse on
      bind -n WheelUpPane if -F '#{alternate_on}' 'send-keys -M' 'copy-mode -e'
      bind -n WheelDownPane if -F '#{alternate_on}' 'send-keys -M'
    '';
  };

  programs.git = {
    enable = true;
    settings.user = {
      name = "Asti0s";
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
      cat = "bat --paging=never";
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
      # ------------------------------------------------------------------------
      # Load p10k theme + my p10k settings
      # ------------------------------------------------------------------------
      if [[ "$TERM" != "linux" ]]; then
        source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
        [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
      else
        PROMPT='%n@%m %~ %# '
      fi
      # ------------------------------------------------------------------------

      # ------------------------------------------------------------------------
      # Up/Down search history for entries starting with the current prefix
      # ------------------------------------------------------------------------
      # CSI form (outside tmux)
      bindkey '^[[A' history-search-backward
      bindkey '^[[B' history-search-forward
      # SS3 form (inside tmux)
      bindkey '^[OA' history-search-backward
      bindkey '^[OB' history-search-forward
      # ------------------------------------------------------------------------

      # ------------------------------------------------------------------------
      # Word jumping with Ctrl+Left/Right (xterm + tmux SS3 variants)
      # ------------------------------------------------------------------------
      # CSI form (outside tmux)
      bindkey '^[[1;5C' forward-word
      bindkey '^[[1;5D' backward-word
      # SS3 form (inside tmux)
      bindkey '^[Oc' forward-word
      bindkey '^[Od' backward-word
      # ------------------------------------------------------------------------

      # ------------------------------------------------------------------------
      # Load tmux
      # ------------------------------------------------------------------------
      if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
        tmux attach-session -t default || tmux new-session -s default
      fi
      # ------------------------------------------------------------------------
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
