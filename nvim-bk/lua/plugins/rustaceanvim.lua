vim.g.rustaceanvim = {
    -- Plugin configuration
    tools = {
    },
    -- LSP configuration
    server = {
        on_attach = function(client, bufnr)
            vim.keymap.set("n", "<leader>a", function() vim.cmd.RustLsp("codeAction") end,
                { desc = "Code Action", buffer = bufnr })
            vim.keymap.set("n", "<S-k>", function() vim.cmd.RustLsp { "hover", "actions" } end,
                { desc = "Code Action", buffer = bufnr })
            vim.keymap.set("n", "<leader>dr", function() vim.cmd.RustLsp("debuggables") end,
                { desc = "Rust Debuggables", buffer = bufnr })
            vim.keymap.set("n", "<leader>rt", function() vim.cmd.RustLsp("testables") end,
                { desc = "Rust Testables", buffer = bufnr })
            vim.keymap.set("n", "<leader>em", function() vim.cmd.RustLsp("expandMacro") end,
                { desc = "Rust Expand Macro", buffer = bufnr })
        end,
        default_settings = {
            -- rust-analyzer language server configuration
            ['rust-analyzer'] = {
                cargo = {
                    allFeatures = true,
                    loadOutDirsFromCheck = true,
                    buildScripts = {
                        enable = true,
                    },
                },
                -- Add clippy lints for Rust if using rust-analyzer
                checkOnSave = true,
                -- Enable diagnostics if using rust-analyzer
                diagnostics = {
                    enable = true,
                },
                procMacro = {
                    enable = true,
                    ignored = {
                        -- ["async-trait"] = { "async_trait" },
                        -- ["napi-derive"] = { "napi" },
                        -- ["async-recursion"] = { "async_recursion" },
                    },
                },
                runnables = {
                    extraTestBinaryArgs = { "--nocapture" },
                },
                files = {
                    excludeDirs = {
                        ".direnv",
                        ".git",
                        ".github",
                        ".gitlab",
                        "bin",
                        "node_modules",
                        "target",
                        "venv",
                        ".venv",
                    },
                },
            },
        },
    },
    -- DAP configuration
    dap = {
    },
}
return {
    "mrcjkb/rustaceanvim",
    version = '^5',
    -- opts = {
    --     server = {
    --         on_attach = function(_, bufnr)
    --             vim.keymap.set("n", "<leader>a", function()
    --                 vim.cmd.RustLsp("codeAction")
    --             end, { desc = "Code Action", buffer = bufnr })
    --             vim.keymap.set("n", "<leader>dr", function()
    --                 vim.cmd.RustLsp("debuggables")
    --             end, { desc = "Rust Debuggables", buffer = bufnr })
    --         end,
    --         -- default_settings = {
    --         --     -- rust-analyzer language server configuration
    --         --     ["rust-analyzer"] = {
    --         --         cargo = {
    --         --             allFeatures = true,
    --         --             loadOutDirsFromCheck = true,
    --         --             buildScripts = {
    --         --                 enable = true,
    --         --             },
    --         --         },
    --         --         -- Add clippy lints for Rust if using rust-analyzer
    --         --         checkOnSave = true,
    --         --         -- Enable diagnostics if using rust-analyzer
    --         --         diagnostics = {
    --         --             enable = true,
    --         --         },
    --         --         procMacro = {
    --         --             enable = true,
    --         --             ignored = {
    --         --                 ["async-trait"] = { "async_trait" },
    --         --                 ["napi-derive"] = { "napi" },
    --         --                 ["async-recursion"] = { "async_recursion" },
    --         --             },
    --         --         },
    --         --         files = {
    --         --             excludeDirs = {
    --         --                 ".direnv",
    --         --                 ".git",
    --         --                 ".github",
    --         --                 ".gitlab",
    --         --                 "bin",
    --         --                 "node_modules",
    --         --                 "target",
    --         --                 "venv",
    --         --                 ".venv",
    --         --             },
    --         --         },
    --         --     },
    --         -- },
    --     },
    -- },
}
