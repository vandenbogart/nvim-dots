vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver40,r-cr-o:hor20"
vim.o.background = "light"

vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.laststatus = 3

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "no"
vim.opt.foldcolumn = "1"
-- vim.opt.colorcolumn = "80"
-- vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50
