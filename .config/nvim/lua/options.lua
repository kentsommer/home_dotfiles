vim.o.backup = false
vim.o.writebackup = false
vim.o.updatetime = 400 -- Don't wait 4s to trigger CursorHold (highlighting).
vim.opt.mouse = ""
vim.opt.scrolloff = 10
vim.opt.guicursor = ""
vim.opt.wildignore = "*.o,*~,*.pyc,*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store"
vim.opt.ruler = true
vim.opt.cmdheight = 2
vim.opt.hidden = true
vim.opt.backspace = "eol,start,indent"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.magic = true
vim.opt.showmatch = true
vim.opt.matchtime = 2
vim.opt.foldcolumn = "1"
vim.opt.background = "dark"
vim.opt.encoding = "utf8"
vim.opt.ffs = "unix,dos,mac"
vim.api.nvim_set_keymap('n', '<C-l><C-l>', ':set invnumber<CR>', { noremap = true, silent = true })
vim.opt.listchars:append "space:•"
vim.opt.signcolumn = "yes"
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.cmd("filetype indent on")
vim.api.nvim_set_keymap('v', '*', 'y/\\V<C-R>"<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '#', 'y?\\V<C-R>"<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<space>', '/', { noremap = false })
vim.api.nvim_set_keymap('n', '<C-@>', '?', { noremap = false })
vim.api.nvim_set_keymap('n', '0', '^', { noremap = false })
vim.g.netrw_liststyle = 3
vim.g.netrw_banner = 0
vim.g.netrw_browse_split = 2
vim.g.netrw_winsize = 25

