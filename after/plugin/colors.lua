function ColorMyEditor(color)
	color = color or "rose-pine"
	vim.cmd.colorscheme(color)
end
require('rose-pine').setup({
    disable_italics = true,
})
ColorMyEditor()
