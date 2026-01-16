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

-- Noice & Dependencies
vim.pack.add({
  { src = 'https://github.com/MunifTanjim/nui.nvim' },
  { src = 'https://github.com/rcarriga/nvim-notify' },
  { src = 'https://github.com/folke/noice.nvim' },
})

require("notify").setup({
  background_colour = "#000000",
})

require("noice").setup({
  lsp = {
    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true,
    },
  },
  presets = {
    bottom_search = true,
    command_palette = true,
    long_message_to_split = true,
    inc_rename = false,
    lsp_doc_border = true,
  },
})

-- Noice scrolling
vim.keymap.set({ "n", "i", "s" }, "<c-d>", function()
  if not require("noice.lsp").scroll(4) then return "<c-d>" end
end, { silent = true, expr = true })

vim.keymap.set({ "n", "i", "s" }, "<c-u>", function()
  if not require("noice.lsp").scroll(-4) then return "<c-u>" end
end, { silent = true, expr = true })
