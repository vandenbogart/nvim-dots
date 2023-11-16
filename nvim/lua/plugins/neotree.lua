return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
        "3rd/image.nvim",
    },
    keys = {
        { "<leader>pv", function() vim.cmd("Neotree") end, desc = "Neotree" },
    },
    opts = {
        window = {
            position = "current",
        }
    }
}
