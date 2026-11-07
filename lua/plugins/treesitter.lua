return { -- Highlight, edit, and navigate code
  -- NOTE: You'll need `tree-sitter-cli` installed as a prerequisite
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  build = ':TSUpdate',
  config = function()
    require('nvim-treesitter').setup {
      indent = {
        enable = false,
      },
    }

    -- Parser name -> Neovim FileType
    local parser_filetypes = {
      java = 'java',
      python = 'python',
      bash = 'sh',
      c = 'c',
      diff = 'diff',
      html = 'html',
      latex = 'tex',
      lua = 'lua',
      luadoc = 'luadoc',
      markdown = 'markdown',
      query = 'query',
      vim = 'vim',
      vimdoc = 'help',
      typescript = 'typescript',
      json = 'json',
    }

    for parser, filetype in pairs(parser_filetypes) do
      vim.treesitter.language.register(parser, filetype)
    end

    require('nvim-treesitter').install(vim.tbl_keys(parser_filetypes))

    vim.api.nvim_create_autocmd('FileType', {
      pattern = vim.tbl_values(parser_filetypes),
      callback = function(args)
        pcall(vim.treesitter.start, args.buf)
      end,
    })
  end,
  -- There are additional nvim-treesitter modules that you can use to interact
  -- with nvim-treesitter. You should go explore a few and see what interests you:
  --
  --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
  --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
  --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
}
