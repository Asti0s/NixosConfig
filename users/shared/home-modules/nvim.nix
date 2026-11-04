{default_editor, ...}: {nvfModule, ...}: {
  imports = [nvfModule];

  programs.nvf = {
    enable = true;
    enableManpages = true;
    defaultEditor = default_editor;
    settings.vim = {
      viAlias = true;
      vimAlias = true;
      autocomplete.blink-cmp.enable = true;
      git.gitsigns.enable = true;
      statusline.lualine.enable = true;
      utility.guess-indent-nvim.enable = true;
      diagnostics = {
        enable = true;
        config = {
          update_in_insert = true;
          severity_sort = true;
          virtual_text = true;
          signs = true;
        };
      };
      binds = {
        whichKey.enable = true;
      };
      ui.borders.enable = true;
      lsp = {
        enable = true;
        formatOnSave = true;
        inlayHints.enable = true;
        servers.nixd.settings.nixd = {
          formatting.command = ["alejandra"];
          nixpkgs.expr = "import (builtins.getFlake (toString ./.)).inputs.nixpkgs { }";
          options = {
            nixos.expr = ''
              (let
                res = builtins.tryEval
                  (builtins.getFlake (toString ./.)).nixosConfigurations.asti0s-laptop.options;
              in
                if res.success then res.value
                else (import <nixpkgs/nixos> { }).options)
            '';
            home_manager.expr = ''
              (let
                res = builtins.tryEval
                  (builtins.getFlake (toString ./.)).nixosConfigurations.asti0s-laptop
                  .options.home-manager.users.type.getSubOptions [ ];
              in
                if res.success then res.value
                else { })
            '';
          };
        };
      };
      languages = {
        enableTreesitter = true;
        enableFormat = true;
        enableExtraDiagnostics = true;
        nix = {
          enable = true;
          lsp.servers = ["nixd"];
        };
        bash.enable = true;
        lua.enable = true;
      };
      keymaps = [
        {
          mode = "i";
          key = "<C-h>";
          action = "<Left>";
          desc = "Move left in insert mode";
        }
        {
          mode = "i";
          key = "<C-j>";
          action = "<Down>";
          desc = "Move down in insert mode";
        }
        {
          mode = "i";
          key = "<C-k>";
          action = "<Up>";
          desc = "Move up in insert mode";
        }
        {
          mode = "i";
          key = "<C-l>";
          action = "<Right>";
          desc = "Move right in insert mode";
        }
      ];
    };
  };
}
