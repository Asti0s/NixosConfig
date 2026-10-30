{
  add_tmux,
  add_eza,
  add_zoxide,
  add_fzf,
  add_bat,
  add_p10k,
  ...
}:

{
  lib,
  config,
  pkgs,
  ...
}:

{
  home = {
    packages =
      with pkgs;
      lib.mkMerge [
        (lib.mkIf add_p10k [ zsh-powerlevel10k ])
        (lib.mkIf add_bat [ bat ])
      ];

    file.".p10k.zsh".source = lib.mkIf add_p10k (
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/NixosConfig/config/p10k.zsh"
    );
  };

  programs.zoxide.enable = add_zoxide;
  programs.fzf.enable = add_fzf;
  programs.eza = {
    enable = add_eza;
    enableZshIntegration = true;
    git = true;
  };

  programs.tmux = lib.mkIf add_tmux {
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

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    autocd = true;

    shellAliases = lib.mkIf add_bat {
      cat = "bat --paging=never";
    };

    # history options: https://github.com/nix-community/home-manager/blob/master/modules/programs/zsh/history.nix
    history = {
      append = true;
      ignoreAllDups = true;
      findNoDups = true;
      ignoreSpace = true;
      expireDuplicatesFirst = true;
      extended = true;
      share = true;
    };

    initContent = lib.mkMerge [
      (lib.mkBefore ''
        # ---- Up/Down prefix search (CSI form) ----
        bindkey '^[[A' history-search-backward
        bindkey '^[[B' history-search-forward

        # ---- Word jumping with Ctrl+Left/Right (xterm CSI form) ----
        bindkey '^[[1;5C' forward-word
        bindkey '^[[1;5D' backward-word
      '')

      (lib.mkIf add_p10k (
        lib.mkAfter ''
          # ---- p10k theme + settings ----
          if [[ "$TERM" != "linux" ]]; then
            source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
            [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
          else
            PROMPT='%n@%m %~ %# '
          fi
        ''
      ))

      (lib.mkIf add_tmux (
        lib.mkAfter ''
          # ---- tmux-specific keybinds (SS3 forms) ----
          bindkey '^[OA' history-search-backward
          bindkey '^[OB' history-search-forward
          bindkey '^[Oc' forward-word
          bindkey '^[Od' backward-word

          # ---- Auto-attach tmux on login (must run at the END of init) ----
          if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
            tmux attach-session -t default || tmux new-session -s default
          fi
        ''
      ))
    ];
  };
}
