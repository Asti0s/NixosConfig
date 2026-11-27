{
  inputs,
  lib,
  ...
}: {
  flake.aspects = {aspects, ...}: {
    shell = {
      includes = with aspects; [
        starship
      ];

      nixos = {pkgs, ...}: let
        ezaArgs = "--git --icons --header";

        zsh-wrapped = inputs.nix-wrapper-modules.wrappers.zsh.wrap {
          inherit pkgs;

          zshAliases = {
            cat = lib.getExe pkgs.bat;
            find = lib.getExe pkgs.fd;
            fd = lib.getExe pkgs.fd;
            grep = lib.getExe pkgs.ripgrep;
            rg = lib.getExe pkgs.ripgrep;
            c = "clear";
            lg = lib.getExe pkgs.lazygit;
            gc = "${lib.getExe pkgs.git} commit";
            ga = "${lib.getExe pkgs.git} add";
            gp = "${lib.getExe pkgs.git} pull";
            gP = "${lib.getExe pkgs.git} push";
            l = "${lib.getExe pkgs.eza} -la ${ezaArgs}";
            ls = "${lib.getExe pkgs.eza} ${ezaArgs}";
            ll = "${lib.getExe pkgs.eza} -l ${ezaArgs}";
            la = "${lib.getExe pkgs.eza} -a ${ezaArgs}";
            lt = "${lib.getExe pkgs.eza} --tree ${ezaArgs}";
            lla = "${lib.getExe pkgs.eza} -la ${ezaArgs}";
          };

          zshrc.content = ''
            # --- History config ---
            HISTFILE="$HOME/.zsh_history"

            HISTSIZE="10000"
            SAVEHIST="10000"

            set_opts=(
              HIST_IGNORE_ALL_DUPS
              HIST_IGNORE_DUPS
              HIST_SAVE_NO_DUPS
              HIST_EXPIRE_DUPS_FIRST
              HIST_IGNORE_SPACE
              HIST_REDUCE_BLANKS
              HIST_VERIFY
              SHARE_HISTORY
              INC_APPEND_HISTORY
              EXTENDED_HISTORY
              APPEND_HISTORY
              HIST_NO_STORE
              HIST_FCNTL_LOCK
              autocd
            )
            for opt in "''${set_opts[@]}"; do
             setopt "$opt"
            done
            unset opt set_opts


            # --- zoxide config ---
            eval "$(${lib.getExe pkgs.zoxide} init zsh)"


            # --- fzf config ---
            export FZF_DEFAULT_COMMAND="${lib.getExe pkgs.fd} --type f --hidden --exclude .git"
            export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
            export FZF_ALT_C_COMMAND="${lib.getExe pkgs.fd} --type d --hidden --exclude .git"
            export FZF_DEFAULT_OPTS="--style full --height 50% --layout=reverse --border"
            export FZF_CTRL_T_OPTS="--preview '${lib.getExe pkgs.bat} --style=numbers --color=always --line-range :500 {}'"
            export FZF_ALT_C_OPTS="--preview '${lib.getExe pkgs.eza} --icons --tree --color=always {} | head -n 100'"
            eval "$(${lib.getExe pkgs.fzf} --zsh)"


            # --- starship config ---
            eval "$(starship init zsh)"
          '';
        };
      in {
        environment = {
          systemPackages = with pkgs; [
            eza
            bat
            git
            lazygit
            fd
            ripgrep
            zoxide
            fzf
            zsh-wrapped
          ];
          pathsToLink = ["/share/zsh"];
        };

        users.defaultUserShell = zsh-wrapped;
      };
    };
  };
}
