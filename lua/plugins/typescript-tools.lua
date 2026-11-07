return {
  "pmizio/typescript-tools.nvim",
  dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  ft = "typescript",
  opts = {
    settings = {
      expose_as_code_action = "all"
    }
  },
}
