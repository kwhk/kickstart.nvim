return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",         -- required
    "sindrets/diffview.nvim",        -- optional - Diff integration
    "nvim-telescope/telescope.nvim"
  },
  config = function()
    local neogit = require('neogit')

    vim.keymap.set('n', '<leader>no', function() neogit.open({ kind = "floating" }) end, { desc = '[N]eogit: [o]pen floating window' })
    vim.keymap.set('n', '<leader>nd', function() neogit.open({ kind = "tab" }) end, { desc = '[N]eogit: Open [d]iff' })
  end
}
