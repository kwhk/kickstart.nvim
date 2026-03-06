return {
	'nvim-treesitter/nvim-treesitter',
	lazy = false,
	build = ':TSUpdate',
	config = function()
		local ts = require 'nvim-treesitter'
		local parsers = { 'java', 'python', 'bash', 'c', 'diff', 'html', 'latex', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc', 'typescript' }
		for _, parser in ipairs(parsers) do
			ts.install(parser)
		end
	end
}


