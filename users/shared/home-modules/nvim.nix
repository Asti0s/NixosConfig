{default_editor, ...}: {
  programs.nvf = {
    enable = true;
    enableManpages = true;
    defaultEditor = default_editor;
    settings.vim = {
      viAlias = true;
      vimAlias = true;
      vendoredKeymaps.enable = false;

      luaConfigPre = ''
        vim.o.exrc = true;
      '';

      # ---------------------------------------
      # Languages diagnostics, display & utils
      # ---------------------------------------

      formatter.conform-nvim.enable = true;

      treesitter = {
        enable = true;
        autotagHtml = true;
        highlight.enable = true;
        indent.enable = true;
        textobjects.enable = true;
      };

      diagnostics = {
        enable = true;
        config = {
          update_in_insert = true;
          virtual_text = true;
          signs = true;
          severity_sort = true;
          underline = true;
        };
        nvim-lint = {
          enable = true;
          lint_after_save = true;
        };
      };

      lsp = {
        enable = true;
        formatOnSave = true;
        inlayHints.enable = true;
        lightbulb.enable = true;
        mappings = {
          hover = "K";
          goToDefinition = "gd";
          renameSymbol = "<leader>rn";
          codeAction = "<leader>ca";
        };
        servers.nixd.settings.nixd.formatting.command = ["alejandra"];
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
        markdown.enable = true;
        json.enable = true;
        rust.enable = true;
        toml.enable = true;
        yaml.enable = true;
      };

      # ---------------------------------------
      # Editor customization
      # ---------------------------------------

      options = {
        wildmenu = false;
        wildoptions = "";
      };

      autocomplete.blink-cmp = {
        enable = true;
        friendly-snippets.enable = true;
        setupOpts = {
          signature.enabled = true;
          cmdline = {
            enabled = true;
            keymap.preset = "inherit";
            completion.menu.auto_show = true;
          };
          keymap = {
            "<C-space>" = ["show"];
            "<C-n>" = ["select_next" "fallback_to_mappings"];
            "<C-p>" = ["select_prev" "fallback_to_mappings"];
            "<C-y>" = ["select_and_accept" "fallback"];
            "<C-e>" = ["hide" "fallback"];
            "<Tab>" = ["snippet_forward" "fallback"];
            "<S-Tab>" = ["snippet_backward" "fallback"];
          };
        };
      };

      # git-conflict.enable = true;
      telescope = {
        enable = true;
        mappings = {
          lspReferences = "gr";
          findFiles = "<leader>ff";
          liveGrep = "<leader>fg";
        };
      };

      utility.motion.flash-nvim = {
        enable = true;
        mappings.jump = "s";
      };

      comments.comment-nvim = {
        enable = true;
        mappings = {
          toggleCurrentLine = "gcc";
          toggleOpLeaderLine = "gc";
        };
      };

      binds.whichKey.enable = true;
      statusline.lualine.enable = true;
      autopairs.nvim-autopairs.enable = true;
      ui.colorizer.enable = true;
      visuals.fidget-nvim.enable = true;
      git.gitsigns.enable = true;
      utility.guess-indent-nvim.enable = true;

      # notify.nvim-notify.enable = true;
      # tabline.nvimBufferline.enable = true;
      # notes.todo-comments.enable = true;
      # filetree.nvimTree.enable = true;

      theme = {
        enable = true;
        name = "gruvbox";
        style = "dark";
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
