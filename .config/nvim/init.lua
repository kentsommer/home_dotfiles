-------------
-- Plugins --
-------------

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Configure packages with lazy.nvim
require("lazy").setup("plugins")

-- Post plugin settings.
vim.cmd("colorscheme kanagawa")

-------------
-- Options --
-------------
require("options")

--------
-- UI --
--------
require("ui")

--------------------------------------
-- LSP, Completion, and Diagnostics --
--------------------------------------
require("lsp")

--------------------------
-- Google Plugin Extras --
--------------------------
pcall(require, "google")
