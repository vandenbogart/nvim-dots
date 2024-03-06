local colors_name = "zenbones_custom"
vim.g.colors_name = colors_name -- Required when defining a colorscheme

local lush = require "lush"
local hsluv = lush.hsluv -- Human-friendly hsl
local util = require "zenbones.util"

local bg = vim.o.background

-- Define a palette. Use `palette_extend` to fill unspecified colors
-- Based on https://github.com/gruvbox-community/gruvbox#palette
local palette
if bg == "light" then
    palette = util.palette_extend({
        bg = hsluv "#fbf1c7",
        fg = hsluv "#3c3836",
        rose = hsluv "#9d0006",
        leaf = hsluv "#79740e",
        wood = hsluv "#b57614",
        water = hsluv "#076678",
        blossom = hsluv "#8f3f71",
        sky = hsluv "#427b58",
    }, bg)
else
    palette = util.palette_extend({
        bg = hsluv(250, 50, 5),
        fg = hsluv(200, 50, 95),
        rose = hsluv(130, 5, 95),
        leaf = hsluv(130, 0, 95),
        wood = hsluv(130, 0, 95),
        water = hsluv(130, 0, 95),
        blossom = hsluv(130, 0, 95),
        sky = hsluv(130, 0, 95),
    }, bg)
end

-- Generate the lush specs using the generator util
local generator = require "zenbones.specs"
local base_specs = generator.generate(palette, bg, generator.get_global_config(colors_name, bg))

-- Optionally extend specs using Lush
local specs = lush.extends({ base_specs }).with(function()
    return {
        -- Statement { base_specs.Statement, fg = palette.rose },
        -- Special { fg = palette.water },
        -- Type { fg = palette.sky, gui = "italic" },
    }
end)

-- Pass the specs to lush to apply
lush(specs)

-- Optionally set term colors
require("zenbones.term").apply_colors(palette)
