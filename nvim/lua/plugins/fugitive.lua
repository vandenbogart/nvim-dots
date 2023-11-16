return {
    "tpope/vim-fugitive",
    enabled = true,
    keys = {
        {"<leader>gs", function() vim.cmd("Git") end, desc="Vim Fugitive"},

    }
}
