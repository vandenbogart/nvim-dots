return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    enabled = false,
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
        "3rd/image.nvim",
    },
    keys = {
        { "<leader>pv", function() vim.cmd("Neotree") end, desc = "Neotree" },
    },
    init = function()
        vim.g.loaded_netrw       = 1
        vim.g.loaded_netrwPlugin = 1
    end,
    opts = {
        window = {
            position = "current",
        },
        filesystem = {
            hijack_netrw_behavior = "open_current",
            window = {
                position = "current"
            }
        },
    }
}
