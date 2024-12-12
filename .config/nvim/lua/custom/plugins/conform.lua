-- conform.nvim

return {
	'stevearc/conform.nvim',
	event = { 'BufWritePre' },
	cmd = { 'ConformInfo' },
	keys = { { -- Customize or remove this keymap to your liking
		'<leader>fb',
		function()
			require('conform').format {
				lsp_fallback = false,
				async = false,
				timeout_ms = 3000,
			}
		end,
		mode = '',
		desc = 'Format buffer',
	},
	},
	opts = {
		formatters_by_ft = {
			css = { 'prettier' },
			go = { 'golines' },
			html = { 'prettier' },
			htmldjango = { 'prettier' },
			javascript = { 'prettier' },
			json = { 'prettier' },
			toml = { 'prettier' },
			jsonc = { 'prettier' },
			lua = { 'stylua' },
			markdown = { 'prettier' },
			python = { 'isort', 'black' },
			sh = { 'shfmt' },
			sql = { 'pg_format' },
			typescript = { 'prettier' },
			yaml = { 'prettier' },
		},
		format_on_save = {
			lsp_fallback = false,
			async = false,
			timeout_ms = 3000,
		},
	},
}
