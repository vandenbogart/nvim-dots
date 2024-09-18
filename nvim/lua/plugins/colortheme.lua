return {
    {

        "mcchrish/zenbones.nvim",
        dependencies = {
            "rktjmp/lush.nvim",
        },
        enabled = true,
        init = function()
            vim.opt.background = "light"
            vim.g.zenbones = {
                -- lightness = "default",
                -- darkness = "stark",
                solid_vert_split = true,
                solid_line_nr = true,
                solid_float_border = true,
                darken_comments = 40,
                darken_non_text = 40,
                darken_line_nr = 60,
                darken_cursor_line = 15,
                -- lighten_comments = 60,
                -- lighten_non_text = 40,
                -- lighten_line_nr = 60,
                -- lighten_cursor_line = 50,
                colorize_diagnostic_underline_text = true,
                transparent_background = false,
            }
            vim.cmd[[colorscheme zenbones]]
        end,
    },
    {
        'yorickpeterse/nvim-grey',
        enabled = false;
        config = function()
            vim.cmd [[colorscheme grey]]
        end
    }
}
