-- Default config for Java here

-- Python's default bracket indentation is two shiftwidths.  Keep dictionary
-- contents one level deeper and align a closing bracket with its opening line.
vim.g.python_indent = vim.tbl_extend('force', vim.g.python_indent or {}, {
  open_paren = 'shiftwidth()',
  closed_paren_align_last_line = false,
})
