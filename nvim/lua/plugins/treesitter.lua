return {
    {
        "nvim-treesitter/nvim-treesitter",
        opts = {
            ensure_installed = {
                "lua",
                "typescript",
                "rust",
                "python",
                "html",
            },
            auto_install = true,
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
            },
        },
        config = function(_, opts)
            require('nvim-treesitter.configs').setup(opts)
            vim.cmd('TSUpdate')
        end,
    },
    {
        'nvim-treesitter/playground',
        keys = {
            { "<leader>tt", function() vim.cmd('TSPlaygroundToggle') end, desc = "Toggle playground" },
            { "<leader>tg", function() vim.cmd('Inspect') end, desc = "Inspect group" },
        }
    }
}
