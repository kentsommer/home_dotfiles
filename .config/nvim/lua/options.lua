-- =============================================================================
-- Leader
-- =============================================================================
vim.g.mapleader = ","
vim.g.maplocalleader = ",,"

-- =============================================================================
-- Performance & UI
-- =============================================================================
vim.opt.updatetime = 250        -- Lower from 400 for snappier CursorHold events (LSP)
vim.opt.timeoutlen = 500        -- Helps with the <Esc> mapping we discussed
vim.opt.cmdheight = 0           -- Modern preference is 1 (or 0) to save screen space
vim.opt.signcolumn = "yes"      -- Prevents "shifting" when LSP icons/signs appear
vim.opt.scrolloff = 10          -- Keep cursor away from screen edges
vim.opt.showmatch = true
vim.opt.matchtime = 2
vim.opt.showtabline = 0

-- =============================================================================
-- Search & Case
-- =============================================================================
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- =============================================================================
-- Formatting & Tabs
-- =============================================================================
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.smarttab = true
vim.opt.backspace = { "eol", "start", "indent" }
vim.opt.wrap = false

-- =============================================================================
-- System & Files
-- =============================================================================
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.undofile = true
vim.opt.wildignore = { "*.o", "*~", "*.pyc", "*/.git/*", "*/.DS_Store" }

-- =============================================================================
-- Visuals
-- =============================================================================
vim.opt.background = "dark"
vim.opt.guicursor = ""
vim.opt.mouse = ""
vim.opt.list = true
vim.opt.listchars:append({ trail = "»" })
vim.opt.foldcolumn = "1"
