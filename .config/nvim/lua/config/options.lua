-- =============================================================================
-- Options
-- =============================================================================

-- Leader
vim.g.mapleader = ","
vim.g.maplocalleader = ",,"

-- Performance & UI
vim.opt.updatetime = 250        -- Faster completion/LSP updates
vim.opt.timeoutlen = 500        -- Faster key sequence timeout
vim.opt.cmdheight = 0           -- Hide command line when unused
vim.opt.signcolumn = "yes"      -- Always show sign column
vim.opt.scrolloff = 10          -- Keep cursor centered
vim.opt.showmatch = true
vim.opt.matchtime = 2
vim.opt.showtabline = 0         -- Never show tabline
vim.opt.termguicolors = true    -- True color support

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Formatting
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.smarttab = true
vim.opt.backspace = { "eol", "start", "indent" }
vim.opt.wrap = false

-- System
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.undofile = true
vim.opt.wildignore = { "*.o", "*~", "*.pyc", "*/.git/*", "*/.DS_Store" }

-- Visuals
vim.opt.guicursor = "a:block"   -- Block cursor in all modes
vim.opt.mouse = ""              -- Disable mouse
vim.opt.list = true
vim.opt.listchars:append({ trail = "»" })
vim.opt.foldcolumn = "1"

-- Clipboard
vim.opt.clipboard = ""
