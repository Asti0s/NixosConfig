{default_editor, ...}: {nvfModule, ...}: {
  imports = [nvfModule];

  programs.nvf = {
    enable = true;
    enableManpages = true;
    defaultEditor = default_editor;
    settings.vim = {
      viAlias = true;
      vimAlias = true;

      diagnostics = {
        enable = false;
        config = {
          update_in_insert = true;
          virtual_text = true;
          signs = true;
        };
      };

      # Extensions
      autocomplete.blink-cmp.enable = true;
      git.gitsigns.enable = true;
      statusline.lualine.enable = true;
      utility.guess-indent-nvim.enable = true;
      binds.whichKey.enable = true;
      telescope.enable = true;
      filetree.nvimTree.enable = true;

      # LSP & Languages
      lsp = {
        enable = true;
        formatOnSave = true;
        inlayHints.enable = true;
        lightbulb.enable = true;
      };
      languages = {
        enableTreesitter = true;
        enableFormat = true;
        enableExtraDiagnostics = true;
        nix.enable = true;
        bash.enable = true;
        lua.enable = true;
        markdown.enable = true;
      };

      # Keybinds
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
