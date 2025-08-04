return {
  "dmtrKovalenko/fold-imports.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {
    enabled = true,
    auto_fold = true,
    fold_level = 0,
    -- refolds imports after lsp code edits (e.g. code actions)
    auto_fold_after_code_action = true,
    -- custom fold text for import sections
    custom_fold_text = true,
    fold_text_format = "Folded imports (%d lines)",
    -- maximum lines for a single import statement to be considered for folding
    max_import_lines = 10,
    languages = {
      java = {
        enabled = true,
        parsers = { "java" },
        queries = {
          "(import_declaration) @import"
        },
        filetypes = { "java" },
        patterns = { "*.java" }
      }
    }
  },
  event = "BufRead"
}
