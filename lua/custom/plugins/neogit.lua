return {
  'NeogitOrg/neogit',
  dependencies = {
    'nvim-lua/plenary.nvim', -- required
    'sindrets/diffview.nvim', -- optional - Diff integration
    'nvim-telescope/telescope.nvim',
  },
  config = function()
    local neogit = require 'neogit'

    neogit.setup {
      integrations = {
        diffview = true,
        telescope = true,
      },
    }

    vim.keymap.set('n', '<leader>on', function()
      neogit.open { kind = 'replace' }
    end, { desc = '[N]eogit' })
  end,
}
