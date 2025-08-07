return {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    lazy = false,
    keys = {
        { "<C-b>",      function() require('fzf-lua').buffers() end,                    desc = "Buffers" },
        { "<leader>pf", function() require('fzf-lua').files() end,                      desc = "Find Files" },
        { "<leader>ph", function() require('fzf-lua').oldfiles() end,                   desc = "Old Files" },
        { "<leader>qf", function() require('fzf-lua').quickfix() end,                   desc = "Quickfix" },
        { "<leader>qs", function() require('fzf-lua').quickfix_stack() end,             desc = "Quickfix Stack" },
        { "<leader>pg", function() require('fzf-lua').live_grep() end,                  desc = "Live Grep Current Project" },
        { "<leader>pr", function() require('fzf-lua').resume() end,                     desc = "Resume" },
        { "<leader>lv", function() require('fzf-lua').grep_visual() end,                mode = "v",                        desc = "Grep Visual Selection" },
        { "<leader>pb", function() require('fzf-lua').lgrep_curbuf() end,               desc = "LiveGrep Current Buffer" },
        { "<leader>wd", function() require('fzf-lua').lsp_workspace_diagnostics() end,  desc = "Workspace Diagnostics" },
        { "<leader>ws", function() require('fzf-lua').lsp_live_workspace_symbols() end, desc = "Workspace Symbols" },
        { "<leader>dw", function() require('fzf-lua').lsp_document_diagnostics() end,   desc = "Document Diagnostics" },
        { "<leader>ds", function() require('fzf-lua').lsp_document_symbols() end,       desc = "Document Symbols" },
        { "<leader>gr", function() require('fzf-lua').lsp_references() end,             desc = "References" },
        { "<leader>gd", function() require('fzf-lua').lsp_definitions() end,            desc = "Definitions" },
        { "<leader>gD", function() require('fzf-lua').lsp_declarations() end,           desc = "Declarations" },
        { "<leader>gt", function() require('fzf-lua').lsp_typedefs() end,               desc = "Type Definitions" },
        { "<leader>gi", function() require('fzf-lua').lsp_implementations() end,        desc = "Implementations" },
        { "<leader>lp", function() require('fzf-lua').profiles() end,                   desc = "List Profiles" },
        { "<leader>lj", function() require('fzf-lua').jumps() end,                      desc = "List Jumps" },
        { "<leader>lm", function() require('fzf-lua').marks() end,                      desc = "List Marks" },

    },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    -- or if using mini.icons/mini.nvim
    -- dependencies = { "echasnovski/mini.icons" },
    opts = {
        "borderless_full",
        keymap = {

        }
    }
}
