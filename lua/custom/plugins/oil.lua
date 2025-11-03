return {
  'stevearc/oil.nvim',
  ---@module 'oil'
  dependencies = {
    {
      'echasnovski/mini.icons',
      opts = {}
    }
  },
  config = function ()
    local oil = require('oil')
    oil.setup({
      keymaps = {
        -- Below are the default keybindings that exist within an Oil buffer
        ["g?"] = { "actions.show_help", mode = "n" },
        ["<CR>"] = "actions.select",
        ["<C-s>"] = { "actions.select", opts = { vertical = true } },
        -- Disable this as it clashes with Harpoon
        ["<C-h>"] = false,
        ["<C-t>"] = { "actions.select", opts = { tab = true } },
        ["<C-p>"] = "actions.preview",
        ["<C-c>"] = { "actions.close", mode = "n" },
        ["<C-l>"] = "actions.refresh",
        ["-"] = { "actions.parent", mode = "n" },
        ["_"] = { "actions.open_cwd", mode = "n" },
        ["`"] = { "actions.cd", mode = "n" },
        ["~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
        ["gs"] = { "actions.change_sort", mode = "n" },
        ["gx"] = "actions.open_external",
        ["g."] = { "actions.toggle_hidden", mode = "n" },
        ["g\\"] = { "actions.toggle_trash", mode = "n" },
        ["gp"] = {
          desc = 'Copy current directory path to clipboard',
          callback = function()
            local dir = oil.get_current_dir()
            vim.fn.setreg("+", dir)
          end
        }
      },
      win_options = {
        winbar = "%{v:lua.require('oil').get_current_dir()}",
      }
    })


    vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
  end,
  lazy = false,
}
