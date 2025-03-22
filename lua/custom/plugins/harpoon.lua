return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    config = function ()
        local harpoon = require("harpoon")
        harpoon:setup()
	vim.keymap.set("n", "<leader>ha", function() harpoon:list():add() end, { desc = '[H]arpoon [A]dd'})
	vim.keymap.set("n", "<leader>hm", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = '[H]arpoon [M]enu' })

	vim.keymap.set("n", "<C-h>", function() harpoon:list():select(1) end, { desc = 'Focus on first Harpoon' })
	vim.keymap.set("n", "<C-j>", function() harpoon:list():select(2) end, { desc = 'Focus on second Harpoon' })
	vim.keymap.set("n", "<C-k>", function() harpoon:list():select(3) end, { desc = 'Focus on third Harpoon' })
	vim.keymap.set("n", "<C-l>", function() harpoon:list():select(4) end, { desc = 'Focus on fourth Harpoon' })

	-- Toggle previous & next buffers stored within Harpoon list
	vim.keymap.set("n", "<leader>hp", function() harpoon:list():prev() end, { desc = '[H]arpoon [P]revious Buffer' })
	vim.keymap.set("n", "<leader>hn", function() harpoon:list():next() end, { desc = '[H]arpoon [N]ext Buffer' })
    end
}
