return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function ()
    local harpoon = require("harpoon")
    harpoon:setup()
    vim.keymap.set("n", "<leader>oha", function() harpoon:list():add() end, { desc = '[A]dd Harpoon'})
    vim.keymap.set("n", "<leader>ohm", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = '[M]enu' })
    vim.keymap.set("n", "<leader>ohc", function() harpoon:list():clear() end, { desc = '[C]lear Harpoons' })

    vim.keymap.set("n", "<leader>oh<C-h>", function() harpoon:list():replace_at(1) end, { desc = 'Add to first Harpoon' })
    vim.keymap.set("n", "<leader>oh<C-j>", function() harpoon:list():replace_at(2) end, { desc = 'Add to second Harpoon' })
    vim.keymap.set("n", "<leader>oh<C-k>", function() harpoon:list():replace_at(3) end, { desc = 'Add to third Harpoon' })
    vim.keymap.set("n", "<leader>oh<C-l>", function() harpoon:list():replace_at(4) end, { desc = 'Add to fourth Harpoon' })

    vim.keymap.set("n", "<C-h>", function() harpoon:list():select(1) end, { desc = 'Focus on first Harpoon' })
    vim.keymap.set("n", "<C-j>", function() harpoon:list():select(2) end, { desc = 'Focus on second Harpoon' })
    vim.keymap.set("n", "<C-k>", function() harpoon:list():select(3) end, { desc = 'Focus on third Harpoon' })
    vim.keymap.set("n", "<C-l>", function() harpoon:list():select(4) end, { desc = 'Focus on fourth Harpoon' })

    -- Toggle previous & next buffers stored within Harpoon list
    vim.keymap.set("n", "<leader>ohp", function() harpoon:list():prev() end, { desc = '[P]revious Harpoon' })
    vim.keymap.set("n", "<leader>ohn", function() harpoon:list():next() end, { desc = '[N]ext Harpoon' })
  end
}
