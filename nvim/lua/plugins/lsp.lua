return {
	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
		build = ":MasonUpdate",
		opts = {
		},
	},
	{
		"williamboman/mason-lspconfig.nvim",
		opts = {
			ensure_installed = {
				"lua_ls",
				"tsserver",
			}
		},
	},
    {
        "folke/neodev.nvim",
        opts = {}
    },
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"folke/neodev.nvim",
			"mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"jose-elias-alvarez/typescript.nvim",
		},
        keys = {
            { "K", vim.lsp.buf.hover, desc = "Hover" },
            { "gd", function() require("telescope.builtin").lsp_definitions({ reuse_win = true }) end, desc = "Goto Definition" },
            { "gr", function() require("telescope.builtin").lsp_references({ reuse_win = true }) end, desc = "References" },
            { "gD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
            { "gI", function() require("telescope.builtin").lsp_implementations({ reuse_win = true }) end, desc = "Goto Implementation" },
            { "gy", function() require("telescope.builtin").lsp_type_definitions({ reuse_win = true }) end, desc = "Goto T[y]pe Definition" },
            { "<c-h>", vim.lsp.buf.signature_help, mode = "i", desc = "Signature Help" },
            { "<leader>ca", vim.lsp.buf.code_action, desc = "Code Action", mode = { "n", "v" } },
            { "<leader>rn", vim.lsp.buf.rename, desc = "Rename" },
            { "<leader>dd", vim.diagnostic.open_float, desc = "Diagnostics" },
            { "[d", vim.diagnostic.goto_prev, desc = "Prev Diagnostic" },
            { "]d", vim.diagnostic.goto_next, desc = "Next Diagnostic" }
        },
		opts = {
            servers = {
                gopls = {
                    filetypes = { "go", "gomod", "gowork", "gotmpl" },
                    settings = {
                        templateExtensions = { "gotmpl" }
                    }
                },
                tsserver = {


                },
                html = {
                    filetypes = { "html", "gotmpl" }
                },
                lua_ls = {
                    settings = {
                        Lua = {
                            diagnostics = {
                                globals = { 'vim' }
                            }
                        }
                    }
                },
                pyright = {
                    capabilities = {
                        textDocument = {
                            publishDiagnostics = {
                                tagSupport = {
                                    valueSet = { 2 },
                                },
                            },
                        },
                    },
                }
            },
            setup = {
                tsserver = function(opts)
                    require('typescript').setup(opts)
                end

            }

		},
        init = function()
            vim.filetype.add({
                extension = {
                    gotmpl = "gotmpl",
                }
            })
        end,
		config = function (_, opts)
            local server_opts = opts.servers
            local setups = opts.setup

            local capabilities = require('cmp_nvim_lsp').default_capabilities()

            local mlsp = require('mason-lspconfig')
            for _, server in ipairs(mlsp.get_installed_servers()) do
                local s_opts = server_opts[server] or {}
                if s_opts.capabilities then
                    s_opts.capabilities = vim.tbl_deep_extend("force", capabilities, s_opts.capabilities)
                else
                    s_opts.capabilities = capabilities
                end
                if setups[server] then
                    setups[server](s_opts)
                else
                    require('lspconfig')[server].setup(s_opts)
                end
            end
		end
	}
}
