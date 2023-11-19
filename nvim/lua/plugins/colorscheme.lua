return {
	"mcchrish/zenbones.nvim",
    dependencies = {
        "rktjmp/lush.nvim",
    },
	init = function()
        vim.opt.background="dark"
        local spec = require('zenbones_extended')
        local lush = require('lush')
        lush(spec)
	end,
}
