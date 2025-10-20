-- vim --
local map = vim.keymap.set

vim.g.mapleader = ' '
map({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

vim.api.nvim_create_user_command('ReloadConfig', function()
	dofile(vim.env.MYVIMRC)
	vim.notify("Config reloaded!")
end, {})
vim.api.nvim_create_user_command('Config', function()
	vim.cmd('vsplit ~/.config/nvim/init.lua')
end, {})
map('n', '<leader>so', ':ReloadConfig<CR>')

vim.o.signcolumn = "yes"
vim.o.number = true
vim.o.relativenumber = true
vim.o.wrap = false
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.swapfile = false
vim.o.ignorecase = true
vim.o.hlsearch = false
vim.o.incsearch = true
vim.o.smartindent = true
vim.o.termguicolors = true
vim.o.undofile = true
vim.o.winborder = "single"

map({ 'n', 'v', 'x' }, '<leader>y', '"+y<CR>')
map({ 'n', 'v', 'x' }, '<leader>d', '"+d<CR>')

map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")


-- plugins --
vim.pack.add({
	{ src = 'https://github.com/echasnovski/mini.pick' },
	{ src = 'https://github.com/mason-org/mason.nvim' },
	{ src = 'https://github.com/neovim/nvim-lspconfig' },
	{ src = 'https://github.com/stevearc/oil.nvim' },
	{ src = 'https://github.com/folke/lazydev.nvim' },
	{ src = 'https://github.com/kylechui/nvim-surround' },
	{ src = 'https://github.com/vague2k/vague.nvim' },
	{ src = 'https://github.com/saghen/blink.cmp',               version = 'v1.6.0' },
	{ src = 'https://github.com/sindrets/diffview.nvim' },
	{ src = 'https://github.com/ibhagwan/fzf-lua' },
	{ src = 'https://github.com/nvim-treesitter/nvim-treesitter' },
	{ src = 'https://github.com/mrcjkb/rustaceanvim' },
	{ src = 'https://github.com/tpope/vim-fugitive' },
	{ src = 'https://github.com/supermaven-inc/supermaven-nvim' },
})

-- colorscheme --
require('vague').setup()

vim.cmd.colo "vague"

-- supermaven --
require('supermaven-nvim').setup({
	keymaps = {
		accept_suggestion = "<C-;>",
		clear_suggestion = "<C-'>",
		accept_word = "<C-.>",
	},
})

map('n', '<leader>sv', ':SupermavenToggle<CR>')


-- diffview --
require('diffview').setup({
	use_icons = false
})

map('n', '<leader>gs', ':DiffviewOpen<CR>')
map('n', '<leader>gq', ':DiffviewClose<CR>')

-- lazydev --
require('lazydev').setup()

-- vim-fugitive --
map('n', '<leader>vf', ':G<CR>')

-- oil --
require('oil').setup()

map('n', '-', ':Oil<CR>')

-- blink --
require('blink.cmp').setup({
	keymap = {
		preset = 'default',
		['<C-CR>'] = { 'select_and_accept' }
	},
	fuzzy = {
		prebuilt_binaries = {
			download = true,
			force_version = 'v1.6.0'
		}
	}
})

-- nvim-surround --
require("nvim-surround").setup()

-- mason --
require("mason").setup()
-- Add Mason's install path to PATH so vim.lsp can find the servers
vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin:" .. vim.env.PATH

-- qf / ll --
map("n", "<C-j>", "<cmd>cnext<CR>zz")
map("n", "<C-k>", "<cmd>cprev<CR>zz")
vim.api.nvim_create_autocmd('FileType', {
	pattern = 'qf',
	callback = function()
		map('n', '<S-CR>', function()
			local wininfo = vim.fn.getwininfo(vim.fn.win_getid())[1]
			if wininfo.loclist == 1 then
				vim.cmd('ll | lclose')
			else
				vim.cmd('cc | cclose')
			end
		end, { buffer = true })
		map('n', '<C-j>', function()
			local wininfo = vim.fn.getwininfo(vim.fn.win_getid())[1]
			if wininfo.loclist == 1 then
				vim.cmd('lnext')
			else
				vim.cmd('cnext')
			end
		end, { buffer = true })
		map('n', '<C-k>', function()
			local wininfo = vim.fn.getwininfo(vim.fn.win_getid())[1]
			if wininfo.loclist == 1 then
				vim.cmd('lprev')
			else
				vim.cmd('cprev')
			end
		end, { buffer = true })
	end,
})

-- lsp --
local lspconfig = require('lspconfig')
lspconfig.lua_ls.setup({})
lspconfig.terraformls.setup({})
lspconfig.ruff.setup({})
lspconfig.pyright.setup({})
lspconfig.svelte.setup({})
lspconfig.ts_ls.setup({})
lspconfig.postgres_lsp.setup({})


local set_sorted_qflist = function(open)
	local diagnostics = vim.diagnostic.get()
	table.sort(diagnostics, function(a, b)
		return a.severity < b.severity
	end)
	vim.diagnostic.setqflist({
		open = open,
		items = diagnostics
	})
end

map('n', '<leader>dd', vim.diagnostic.open_float)
map('n', '<leader>dl', function() vim.diagnostic.setloclist() end)
map('n', '<leader>df', function() set_sorted_qflist(true) end)

vim.api.nvim_create_autocmd('DiagnosticChanged', {
	callback = function()
		set_sorted_qflist(false)
	end
})

map('n', '<leader>ff', vim.lsp.buf.format)

vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('UserLspConfig', {}),
	callback = function(ev)
		local opts = { buffer = ev.buf }
		-- Navigation --
		vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
		vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
		vim.keymap.set('n', 'gi', vim.lsp.buf.implementation,
			opts)
		vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition,
			opts)
		vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)

		-- Documentation --
		vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
		vim.keymap.set({ 'n', 'i' }, '<C-h>', vim.lsp.buf.signature_help,
			opts)

		-- Actions --
		vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename,
			opts)
		vim.keymap.set({ 'n', 'v' }, '<leader>a',
			vim.lsp.buf.code_action, opts)
		vim.keymap.set('n', '<leader>f', vim.lsp.buf.format,
			opts)

		-- Workspace --
		vim.keymap.set('n', '<leader>wa',
			vim.lsp.buf.add_workspace_folder, opts)
		vim.keymap.set('n', '<leader>wr',
			vim.lsp.buf.remove_workspace_folder, opts)
	end,
})

-- treesitter --
require("nvim-treesitter.configs").setup({
	ensure_installed = { "rust", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" },
	highlight = {
		enable = true,
	}
})

-- rustaceanvim --
vim.g.rustaceanvim = {
	-- LSP configuration
	server = {
		on_attach = function(client, bufnr)
			vim.keymap.set("n", "<leader>a", function() vim.cmd.RustLsp("codeAction") end,
				{ desc = "Code Action", buffer = bufnr })
			vim.keymap.set("n", "<leader>rd", function() vim.cmd.RustLsp("renderDiagnostic") end,
				{ desc = "Render Diagnostics", buffer = bufnr })
			vim.keymap.set("n", "<leader>ee", function() vim.cmd.RustLsp("explainError") end,
				{ desc = "Explain Error", buffer = bufnr })
			vim.keymap.set("n", "<S-k>", function() vim.cmd.RustLsp { "hover", "actions" } end,
				{ desc = "Code Action", buffer = bufnr })
			vim.keymap.set("n", "<leader>rf", function() vim.cmd.RustLsp("debuggables") end,
				{ desc = "Rust Debuggables", buffer = bufnr })
			vim.keymap.set("n", "<leader>rt", function() vim.cmd.RustLsp("testables") end,
				{ desc = "Rust Testables", buffer = bufnr })
			vim.keymap.set("n", "<leader>em", function() vim.cmd.RustLsp("expandMacro") end,
				{ desc = "Rust Expand Macro", buffer = bufnr })
		end,
	}
}

-- mini.pick --
-- require("mini.pick").setup()
-- local wipeout_cur = function()
-- 	vim.api.nvim_buf_delete(MiniPick.get_picker_matches().current.bufnr, {})
-- end
-- local delete_unmodified_buffers = function()
-- 	local current_buf = vim.api.nvim_get_current_buf()
-- 	local deleted_count = 0
-- 	local picker_items = MiniPick.get_picker_items()
--
-- 	for _, item in ipairs(picker_items) do
-- 		local buf = item.bufnr
-- 		if buf
-- 			and buf ~= current_buf
-- 			and vim.api.nvim_buf_is_loaded(buf)
-- 			and not vim.api.nvim_get_option_value('modified', { buf = buf }) then
-- 			vim.api.nvim_buf_delete(buf, { force = false })
-- 			deleted_count = deleted_count + 1
-- 		end
-- 	end
--
-- 	vim.notify("Deleted " .. deleted_count .. " unmodified buffers")
-- 	MiniPick.stop()
-- end
-- local buffer_mappings = {
-- 	wipeout = { char = '<C-d>', func = wipeout_cur },
-- 	delete_unmodified = { char = '<C-S-d>', func = delete_unmodified_buffers }
-- }
-- map('n', '<leader>pf', function() MiniPick.builtin.files() end)
-- map('n', '<leader>pg', function() MiniPick.builtin.grep_live({}, { tool = 'rg --ignore-case' }) end)
-- map('n', '<leader>ph', function() MiniPick.builtin.help() end)
-- map('n', '<leader>pr', function() MiniPick.builtin.resume() end)
-- map('n', '<C-b>', function() MiniPick.builtin.buffers({}, { mappings = buffer_mappings }) end)
--
-- fzf.lua


require('fzf-lua').setup()
map('n', "<C-b>", function() require('fzf-lua').buffers() end)
map('n', "<leader>pf", function() require('fzf-lua').files() end)
map('n', "<leader>ph", function() require('fzf-lua').help_tags() end)
map('n', "<leader>qf", function() require('fzf-lua').quickfix() end)
map('n', "<leader>qs", function() require('fzf-lua').quickfix_stack() end)
map('n', "<leader>pg", function() require('fzf-lua').live_grep() end)
map('n', "<leader>pr", function() require('fzf-lua').resume() end)
map({ 'n', 'v' }, "<leader>lv", function() require('fzf-lua').grep_visual() end)
map('n', "<leader>pb", function() require('fzf-lua').lgrep_curbuf() end)
map('n', "<leader>wd", function() require('fzf-lua').lsp_workspace_diagnostics() end)
map('n', "<leader>ws", function() require('fzf-lua').lsp_live_workspace_symbols() end)
map('n', "<leader>dw", function() require('fzf-lua').lsp_document_diagnostics() end)
map('n', "<leader>ds", function() require('fzf-lua').lsp_document_symbols() end)
map('n', "<leader>gr", function() require('fzf-lua').lsp_references() end)
map('n', "<leader>gd", function() require('fzf-lua').lsp_definitions() end)
map('n', "<leader>gD", function() require('fzf-lua').lsp_declarations() end)
map('n', "<leader>gt", function() require('fzf-lua').lsp_typedefs() end)
map('n', "<leader>gi", function() require('fzf-lua').lsp_implementations() end)
map('n', "<leader>lp", function() require('fzf-lua').profiles() end)
map('n', "<leader>lj", function() require('fzf-lua').jumps() end)
map('n', "<leader>lm", function() require('fzf-lua').marks() end)
