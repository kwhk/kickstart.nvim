return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",         -- required
    "sindrets/diffview.nvim",        -- optional - Diff integration
    "nvim-telescope/telescope.nvim"
  },
  config = function()
    local neogit = require('neogit')

    neogit.setup {
      integrations = {
        diffview = true,
        telescope = true
      }
    }

    vim.keymap.set('n', '<leader>no', function() neogit.open({ kind = "replace" }) end, { desc = '[N]eogit: [o]pen window' })
    vim.keymap.set('n', '<leader>nd', function() neogit.open({ "diff", kind = "tab" }) end, { desc = '[N]eogit: Open [d]iff view' })
    vim.keymap.set('n', '<leader>nc', function() neogit.open({ "commit", kind = "replace" }) end, { desc = '[N]eogit: Open [c]ommit view' })
  end
}
