return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    keys = {
        { "ff", function() require("telescope.builtin").find_files({ reuse_win = true }) end, desc = "Find Files" },
        { "fg", function() require("telescope.builtin").live_grep({ reuse_win = true }) end, desc = "Live Grep" },
        { "fb", function() require("telescope.builtin").buffers({ reuse_win = true }) end, desc = "Buffers" },
        { "ft", function() require("telescope.builtin").treesitter({ reuse_win = true }) end, desc = "Treesitter" },
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
