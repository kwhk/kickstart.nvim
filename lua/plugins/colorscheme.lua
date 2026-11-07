-- Add catppuccin theme
return {
  'catppuccin/nvim',
  name = 'catppuccin',
  priority = 1000,
  config = function()
    require('catppuccin').setup {
      flavour = 'macchiato',
      no_italic = true,
      term_colors = true,
    }

    vim.cmd.colorscheme 'catppuccin'
  end,
}
