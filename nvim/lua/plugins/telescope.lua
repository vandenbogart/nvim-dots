return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    keys = {
        { "<leader>pf", function() require("telescope.builtin").find_files({ reuse_win = true }) end,            desc = "Find Files" },
        { "<leader>pg", function() require("telescope.builtin").live_grep({ reuse_win = true }) end,             desc = "Live Grep" },
        { "<C-b>",      function() require("telescope.builtin").buffers({ reuse_win = true }) end,               desc = "Buffers" },
        { "<leader>pt", function() require("telescope.builtin").treesitter({ reuse_win = true }) end,            desc = "Treesitter" },
        { "<leader>pr", function() require("telescope.builtin").resume({ reuse_win = true }) end,                desc = "Resume" },
        { "<leader>ww", function() require("telescope.builtin").lsp_workspace_symbols({ reuse_win = true }) end, desc = "LSP Workspace Symbols" },
        { "<leader>wd", function() require("telescope.builtin").diagnostics({ reuse_win = true }) end,           desc = "Diagnostics" },
        { "<leader>wc", function() require("telescope.builtin").git_commits({ reuse_win = true }) end,           desc = "Git Commits" },
    },
    config = function()
        local telescope = require('telescope')
        telescope.setup({
            defaults = {
                -- These three settings are optional, but recommended.
                prompt_prefix = '',
                entry_prefix = ' ',
                selection_caret = ' ',


                -- This is the important part: without this, Telescope windows will look a
                -- bit odd due to how borders are highlighted.
                -- layout_strategy = 'grey',
                layout_config = {
                    -- The extension supports both "top" and "bottom" for the prompt.
                    prompt_position = 'top',

                    -- You can adjust these settings to your liking.
                    width = 0.95,
                    height = 0.95,
                    preview_width = 0.35,
                },
            }
        })

        -- telescope.load_extension('grey')
    end,
    -- opts = {
    --     pickers = {
    --         find_files = {
    --             theme = "ivy",
    --             path_display = { "smart", "shorten", "truncate" },
    --             hidden = true,
    --         },
    --         live_grep = {
    --             theme = "ivy",
    --             path_display = { "smart", "shorten", "truncate" },
    --             additional_args = {'--hidden'}
    --         },
    --         buffers = {
    --             theme = "ivy",
    --             path_display = { "smart", "shorten", "truncate" },
    --             hidden = true,
    --         },
    --         diagnostics = {
    --             path_display = { "smart", "shorten", "truncate" },
    --             theme = "ivy",
    --         },
    --         lsp_workspace_symbols = {
    --             path_display = { "smart", "shorten", "truncate" },
    --             theme = "ivy",
    --         },
    --         lsp_definitions = {
    --             path_display = { "smart", "shorten", "truncate" },
    --             theme = "ivy",
    --         },
    --         lsp_type_defintions = {
    --             path_display = { "smart", "shorten", "truncate" },
    --             theme = "ivy",
    --         },
    --         lsp_implementations = {
    --             path_display = { "smart", "shorten", "truncate" },
    --             theme = "ivy",
    --         },
    --         lsp_references = {
    --             path_display = { "smart", "shorten", "truncate" },
    --             theme = "ivy",
    --         },
    --         git_commits = {
    --             path_display = { "smart", "shorten", "truncate" },
    --             theme = "ivy",
    --         },
    --     },
    -- }
}
