return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    keys = {
        { "<leader>pf", function() require("telescope.builtin").find_files({ reuse_win = true }) end, desc = "Find Files" },
        { "<leader>pg", function() require("telescope.builtin").live_grep({ reuse_win = true }) end, desc = "Live Grep" },
        { "<C-b>", function() require("telescope.builtin").buffers({ reuse_win = true }) end, desc = "Buffers" },
        { "<leader>pt", function() require("telescope.builtin").treesitter({ reuse_win = true }) end, desc = "Treesitter" },
        { "<leader>pr", function() require("telescope.builtin").resume({ reuse_win = true }) end, desc = "Treesitter" },
        { "<leader>ws", function() require("telescope.builtin").lsp_workspace_symbols({ reuse_win = true }) end, desc = "Treesitter" },
        { "<leader>wd", function() require("telescope.builtin").diagnostics({ reuse_win = true }) end, desc = "Treesitter" },
    },
    opts = {
        pickers = {
            find_files = {
                theme = "ivy",
            },
            live_grep = {
                theme = "ivy",
            },
            buffers = {
                theme = "ivy",
            },
        },
    }
}
