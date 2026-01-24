-- =============================================================================
-- UI Plugins
-- =============================================================================

-- Catppuccin
vim.pack.add({
  { src = 'https://github.com/catppuccin/nvim' },
})

require("catppuccin").setup({
    flavour = "mocha",
    transparent_background = true,
    float = {
        transparent = true,
    },
    integrations = {
      blink_cmp = true,
      fzf = true,
    },
})

vim.cmd.colorscheme "catppuccin"

-- Mini.statusline
vim.pack.add({
  { src = 'https://github.com/nvim-mini/mini.statusline' },
})
require('mini.statusline').setup()
