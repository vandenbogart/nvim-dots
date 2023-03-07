local builtin = require('telescope.builtin')
local ivy = require('telescope.themes').get_ivy
local theme = {
    path_display = { "truncate" }
}
vim.keymap.set('n', '<leader>pf', function()
    builtin.find_files(ivy(theme))
end)
vim.keymap.set('n', '<C-p>', function()
    builtin.git_files(ivy(theme))
end)
vim.keymap.set('n', '<C-b>', function()
    builtin.buffers(ivy(theme))
end)
vim.keymap.set('n', '<leader>pg', function()
	builtin.live_grep(ivy(theme));
end)
vim.keymap.set('n', '<leader>ps', function()
	builtin.grep_string(ivy(theme));
end)

local trouble = require("trouble.providers.telescope")

local telescope = require("telescope")

telescope.setup {
  defaults = {
    mappings = {
        i = { ["<C-f>"] = trouble.open_with_trouble },
        n = { ["<C-f>"] = trouble.open_with_trouble },
    },
  },
}
