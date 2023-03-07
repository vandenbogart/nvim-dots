require('trouble').setup({


})
vim.keymap.set("n", "<leader>q", "<cmd>TroubleToggle<cr>",
  {silent = true, noremap = true}
)
vim.keymap.set("n", "<leader>qw", "<cmd>TroubleToggle workspace_diagnostics<cr>",
  {silent = true, noremap = true}
)
vim.keymap.set("n", "<leader>qd", "<cmd>TroubleToggle document_diagnostics<cr>",
  {silent = true, noremap = true}
)
vim.keymap.set("n", "<leader>ql", "<cmd>TroubleToggle loclist<cr>",
  {silent = true, noremap = true}
)
vim.keymap.set("n", "<leader>qf", "<cmd>TroubleToggle quickfix<cr>",
  {silent = true, noremap = true}
)
vim.keymap.set("n", "gR", "<cmd>TroubleToggle lsp_references<cr>",
  {silent = true, noremap = true}
)
-- jump to the next item, skipping the groups
vim.keymap.set("n", "<C-j>", function()
    require("trouble").next({skip_groups = true, jump = true})
end)

vim.keymap.set("n", "<C-k>", function()
    require("trouble").previous({skip_groups = true, jump = true})
end)

vim.keymap.set("n", "<C-f>", function()
    require("trouble").first({skip_groups = true, jump = true})
end)

vim.keymap.set("n", "<C-g>", function()
    require("trouble").last({skip_groups = true, jump = true})
end)
