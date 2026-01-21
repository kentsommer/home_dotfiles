-- 1. Core Configuration
require("config.options")
require("config.keymaps")
require("config.autocmds")

-- 2. Plugins
require("plugins.ui")
require("plugins.editor")
require("plugins.lsp")
require("plugins.multiplexer")

-- 3. Environment Specific
local plugins_google = vim.fn.stdpath("config") .. "/lua/plugins/google.lua"
if vim.uv.fs_stat(plugins_google) then
  require("plugins.google")
end
