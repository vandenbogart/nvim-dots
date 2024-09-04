return {
        "mbbill/undotree",
        keys = {
            {
                "<leader>pu",
                function() vim.cmd("UndotreeToggle") end,
                desc = "undo history"
            }
        },
    }
