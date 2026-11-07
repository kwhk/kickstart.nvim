-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

return {
  -- NOTE: Yes, you can install new plugins here!
  'mfussenegger/nvim-dap',
  -- NOTE: And you can specify dependencies as well
  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',

    -- Required dependency for nvim-dap-ui
    'nvim-neotest/nvim-nio',

    -- Installs the debug adapters for you
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- Adds virtual text
    'theHamsta/nvim-dap-virtual-text'
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('mason-nvim-dap').setup {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_installation = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
      },
    }

    -- Set keybindings for dap
    vim.keymap.set("n", "<F1>", dap.continue, { desc = "Debug: Start/Continue" })
    vim.keymap.set("n", "<F2>", dap.step_into, { desc = "Debug: Step Into" })
    vim.keymap.set("n", "<F3>", dap.step_over, { desc = "Debug: Step Over" })
    vim.keymap.set("n", "<F4>", dap.step_out, { desc = "Debug: Step Out" })
    vim.keymap.set("n", "<F5>", dap.step_back, { desc = "Debug: Step Back" })
    -- -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
    -- vim.keymap.set("n", "<F7>", dap.toggle, { desc = "Debug: See last session result" })
    vim.keymap.set("n", "<F10>", dap.restart, { desc = "Debug: Restart" })
    vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "[D]ebug: Toggle [b]reakpoint" })
    vim.keymap.set("n", "<leader>dB", dap.set_breakpoint, { desc = "[D]ebug: Set [B]reakpoint" })
    vim.keymap.set("n", "<leader>do", dapui.toggle, { desc = "[D]ebug: Toggle UI [O]pen" })
    -- Eval var under cursor
    vim.keymap.set("n", "<space>?", function()
      dapui.eval(nil, { enter = true })
    end)

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup {
      -- Set icons to characters that are more likely to work in every terminal.
      --    Feel free to remove or use ones that you like more! :)
      --    Don't feel like these are good choices.
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
    }

    -- Change breakpoint icons
    vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
    vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })
    local breakpoint_icons = vim.g.have_nerd_font
        and { Breakpoint = '', BreakpointCondition = '', BreakpointRejected = '', LogPoint = '', Stopped = '' }
      or { Breakpoint = '●', BreakpointCondition = '⊜', BreakpointRejected = '⊘', LogPoint = '◆', Stopped = '⭔' }
    for type, icon in pairs(breakpoint_icons) do
      local tp = 'Dap' .. type
      local hl = (type == 'Stopped') and 'DapStop' or 'DapBreak'
      vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
    end

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    -- Initialize configurations, via the dap.configurations (:help dap-configuration)
    -- A lot of the DAP adapters are from VSCode, like vscode-java-debug: https://github.com/microsoft/vscode-java-debug/blob/main/Configuration.md

    -- We can acquire project-level configurations just like in VSCode via `.vscode/launch.json`
    -- There is an existing method in nvim-dap that allows us to find any existing project-level configurations
    -- https://github.com/mfussenegger/nvim-dap/blob/master/lua/dap/ext/vscode.lua
    local dap_configurations = require("dap.ext.vscode").getconfigs()
    table.insert(dap_configurations, {
      -- Append a default configuration for Java debugging
      type = 'java';
      request = 'attach';
      name = 'Debug (Attach) - Remote';
      hostName = '127.0.0.1';
      port = 5005;
      shortenCommandLine = 'jarmanifest';
    });

    -- Add all the configurations to dap
    for _, configuration in ipairs(dap_configurations) do
      local config_type = configuration["type"]
      if dap.configurations[config_type] == nil then
        dap.configurations[config_type] = {}
      end
      table.insert(dap.configurations[config_type], configuration)
    end
  end,
}
