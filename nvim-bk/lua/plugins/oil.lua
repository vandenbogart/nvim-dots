return {
    'stevearc/oil.nvim',

    lazy = false,
    opts = {
        default_file_explorer = true,
        delete_to_trash = true,
        columns = {
            "mtime",
            "icon"
        }
    },
    keys = {
        { "-", "<cmd>Oil<cr>", mode = "n", desc = "Open Oil" }
    },
    dependencies = { { "echasnovski/mini.icons", opts = {} } }
}
