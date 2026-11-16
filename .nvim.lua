vim.lsp.config("nixd", {
  settings = {
    nixd = {
      options = {
        nixos = {
          expr = '(builtins.getFlake (builtins.toString ./.)).nixosConfigurations.asti0s-laptop.options',
        },
        home_manager = {
          expr = '(builtins.getFlake (builtins.toString ./.)).nixosConfigurations.asti0s-laptop.options.home-manager.users.type.getSubOptions []',
        },
      },
    },
  },
})
