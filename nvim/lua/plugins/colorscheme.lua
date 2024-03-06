return {
    {
        'yorik1984/newpaper.nvim',
        enabled = true,
        init = function()
            vim.opt.background = "light"
            vim.cmd("colorscheme newpaper")
        end,
        opts = {
            disable_background = true,
        }
    },
    {
        'jacoborus/tender.vim',
        enabled = false,
        init = function()
            vim.opt.background = "dark"
            vim.cmd("colorscheme tender")
        end,
    },
    {
        "sainnhe/everforest",
        enabled = false,
        init = function()
            vim.opt.background = "dark"
            vim.cmd("colorscheme everforest")
        end,

    },
    {
        'ramojus/mellifluous.nvim',
        enabled = false,
        init = function()
            vim.opt.background = "light"
            vim.cmd("colorscheme mellifluous")
        end,
    },
    {
        "ellisonleao/gruvbox.nvim",
        priority = 1000,
        config = true,
        enabled = false,
        opts = {
            terminal_colors = true, -- add neovim terminal colors
            undercurl = true,
            underline = true,
            bold = true,
            italic = {
                strings = true,
                emphasis = true,
                comments = true,
                operators = false,
                folds = true,
            },
            strikethrough = true,
            invert_selection = false,
            invert_signs = false,
            invert_tabline = false,
            invert_intend_guides = false,
            inverse = true, -- invert background for search, diffs, statuslines and errors
            contrast = "",  -- can be "hard", "soft" or empty string
            palette_overrides = {},
            overrides = {},
            dim_inactive = false,
            transparent_mode = false,
        },
        init = function()
            vim.opt.background = "light"
            vim.cmd("colorscheme gruvbox")
        end,
    },
    {
        "mcchrish/zenbones.nvim",
        dependencies = {
            "rktjmp/lush.nvim",
        },
        enabled = false,
        init = function()
            vim.opt.background = "light"
            vim.g.zenbones = {
                lightness = "bright",
                solid_vert_split = true,
                solid_line_nr = true,
                solid_float_border = true,
                darken_comments = 40,
                darken_non_text = 40,
                darken_line_nr = 60,
                darken_cursor_line = 15,
                colorize_diagnostic_underline_text = true,
                transparent_mode = false,
            }
            local spec = require('zenbones_extended')
            local lush = require('lush')
            lush(spec)
        end,
    }
}
