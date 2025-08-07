return {
    {
        "williamboman/mason.nvim",
        cmd = "Mason",
        build = ":MasonUpdate",
        opts = {
        },
    },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
            'williamboman/mason.nvim'
        },
        event = { "BufReadPre", "BufNewFile" },
    },
    {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
            library = {
                -- See the configuration section for more details
                -- Load luvit types when the `vim.uv` word is found
                { path = "luvit-meta/library", words = { "vim%.uv" } },
                "rcarriga/nvim-dap-ui",
            },
        },
    },
    {
        "Bilal2453/luvit-meta",
        lazy = true
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "folke/lazydev.nvim",
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
        },
        event = { "BufReadPre", "BufNewFile" },
        keys = {
            { "K",          vim.lsp.buf.hover,                                          desc = "Hover" },
            { "gt",         vim.lsp.buf.type_definition,                                desc = "Type Definition" },
            { "gd",         vim.lsp.buf.definition,                                     desc = "Definition" },
            { "gD",         vim.lsp.buf.declaration,                                    desc = "Declaration" },
            { "<leader>wf", vim.lsp.buf.add_workspace_folder,                           desc = "Add folder to workspace" },
            { "<c-h>",      vim.lsp.buf.signature_help,                                 mode = "i",                      desc = "Signature Help" },
            { "<leader>ca", vim.lsp.buf.code_action,                                    desc = "Code Action",            mode = { "n", "v" } },
            { "<leader>rn", vim.lsp.buf.rename,                                         desc = "Rename" },
            { "<leader>ff", vim.lsp.buf.format,                                         desc = "Format" },
            { "<leader>dd", vim.diagnostic.open_float,                                  desc = "Diagnostics" },

            { "[d",         function() vim.diagnostic.jump({ count = -1, float = true }) end, desc = "Prev Diagnostic" },
            { "]d",         function() vim.diagnostic.jump({ count = 1, float = true }) end, desc = "Next Diagnostic" }
        },
        config = function(_, opts)
            local server_opts = opts.servers or {}
            local setup = opts.setup or {}

            -- local capabilities = require('cmp_nvim_lsp').default_capabilities()

            local mlsp = require('mason-lspconfig')
            for _, server in ipairs(mlsp.get_installed_servers()) do
                local s_opts = server_opts[server] or {}
                -- if s_opts.capabilities then
                --     s_opts.capabilities = vim.tbl_deep_extend("force", capabilities, s_opts.capabilities)
                -- else
                --     s_opts.capabilities = capabilities
                -- end
                if setup[server] then
                    setup[server](s_opts)
                else
                    require('lspconfig')[server].setup(s_opts)
                end
            end
        end

    }
}
