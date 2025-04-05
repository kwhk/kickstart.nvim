return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function ()
    local harpoon = require("harpoon")
    harpoon:setup()
    vim.keymap.set("n", "<leader>oa", function() harpoon:list():add() end, { desc = 'Harp[o]on [A]dd'})
    vim.keymap.set("n", "<leader>om", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = 'Harp[o]on [M]enu' })
    vim.keymap.set("n", "<leader>oc", function() harpoon:list():clear() end, { desc = 'Harp[o]on [C]lear' })

    vim.keymap.set("n", "<leader>o<C-h>", function() harpoon:list():replace_at(1) end, { desc = 'Add to first Harpoon' })
    vim.keymap.set("n", "<leader>o<C-j>", function() harpoon:list():replace_at(2) end, { desc = 'Add to second Harpoon' })
    vim.keymap.set("n", "<leader>o<C-k>", function() harpoon:list():replace_at(3) end, { desc = 'Add to third Harpoon' })
    vim.keymap.set("n", "<leader>o<C-l>", function() harpoon:list():replace_at(4) end, { desc = 'Add to fourth Harpoon' })

    vim.keymap.set("n", "<C-h>", function() harpoon:list():select(1) end, { desc = 'Focus on first Harpoon' })
    vim.keymap.set("n", "<C-j>", function() harpoon:list():select(2) end, { desc = 'Focus on second Harpoon' })
    vim.keymap.set("n", "<C-k>", function() harpoon:list():select(3) end, { desc = 'Focus on third Harpoon' })
    vim.keymap.set("n", "<C-l>", function() harpoon:list():select(4) end, { desc = 'Focus on fourth Harpoon' })

    -- Toggle previous & next buffers stored within Harpoon list
    vim.keymap.set("n", "<leader>op", function() harpoon:list():prev() end, { desc = 'Harp[o]on [P]revious Buffer' })
    vim.keymap.set("n", "<leader>on", function() harpoon:list():next() end, { desc = 'Harp[o]on [N]ext Buffer' })
  end
}
