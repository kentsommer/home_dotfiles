vim.pack.add({
  -- Catppuccin
  {
    src = 'https://github.com/catppuccin/nvim',
  },
  -- Oil
  {
    src = 'https://github.com/stevearc/oil.nvim',
  },
  -- Noice
  {
    src = 'https://github.com/MunifTanjim/nui.nvim',
  },
  {
    src = 'https://github.com/rcarriga/nvim-notify',
  },
  {
    src = 'https://github.com/folke/noice.nvim',
  },
  -- Treesitter
  {
    src = 'https://github.com/nvim-treesitter/nvim-treesitter',
  },
  -- Blink
  {
    src = 'https://github.com/saghen/blink.cmp',
  },
  -- Fzf
  {
    src = 'https://github.com/junegunn/fzf',
  },
  {
    src = 'https://github.com/junegunn/fzf.vim',
  },
  {
    src = 'https://github.com/ibhagwan/fzf-lua',
  },
  -- Vim-cool
  {
    src = 'https://github.com/romainl/vim-cool',
  },
  -- Mini.statusline
  {
    src = 'https://github.com/nvim-mini/mini.statusline',
  },
})

-- =============================================================================
-- Catppuccin
-- =============================================================================
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

-- =============================================================================
-- Oil
-- =============================================================================
require("oil").setup({
  default_file_explorer=true,
  use_default_keymaps = false,
  keymaps = {
    ["g?"] = { "actions.show_help", mode = "n" },
    ["<CR>"] = "actions.select",
    ["<C-v>"] = { "actions.select", opts = { vertical = true } },
    ["q"] = { "actions.close", mode = "n" },
    ["<C-r>"] = "actions.refresh",
    ["-"] = { "actions.parent", mode = "n" },
    ["gs"] = { "actions.change_sort", mode = "n" },
    ["gx"] = "actions.open_external",
    ["g."] = { "actions.toggle_hidden", mode = "n" },
    ["g\\"] = { "actions.toggle_trash", mode = "n" },
  },
})
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open Oil" })

-- =============================================================================
-- Noice
-- =============================================================================
require ("notify").setup({
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
  -- you can enable a preset for easier configuration
  presets = {
    bottom_search = true, -- use a classic bottom cmdline for search
    command_palette = true, -- position the cmdline and popupmenu together
    long_message_to_split = true, -- long messages will be sent to a split
    inc_rename = false, -- enables an input dialog for inc-rename.nvim
    lsp_doc_border = true, -- add a border to hover docs and signature help
  },
})

vim.keymap.set({ "n", "i", "s" }, "<c-d>", function()
  if not require("noice.lsp").scroll(4) then
    return "<c-d>"
  end
end, { silent = true, expr = true })

vim.keymap.set({ "n", "i", "s" }, "<c-u>", function()
  if not require("noice.lsp").scroll(-4) then
    return "<c-u>"
  end
end, { silent = true, expr = true })

-- =============================================================================
-- Treesitter
-- =============================================================================
require("nvim-treesitter").setup({
  ensure_installed = {
    "bash",
    "c",
    "cpp",
    "html",
    "javascript",
    "jsdoc",
    "json",
    "json5",
    "lua",
    "luadoc",
    "luap",
    "markdown",
    "markdown_inline",
    "python",
    "regex",
    "toml",
    "vim",
    "vimdoc",
    "yaml",
  },
  auto_install = true,
  highlight = {
    enable = true,
  },
  indent = {
    enable = true,
  },
})

-- =============================================================================
-- Blink
-- =============================================================================
require("blink.cmp").setup({
  keymap = { preset = "enter" },
  completion = { documentation = { auto_show = false } },
  sources = {
    default = { "lsp", "buffer" },
  },
  fuzzy = { implementation = "prefer_rust_with_warning" }
})

-- =============================================================================
-- Fzf
-- =============================================================================
require("fzf-lua").setup({ "border-fused" })

-- =============================================================================
-- mini.statusline
-- =============================================================================
require('mini.statusline').setup()
