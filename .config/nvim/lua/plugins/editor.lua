-- =============================================================================
-- Editor Plugins
-- =============================================================================

-- Oil (File Explorer)
vim.pack.add({
  { src = 'https://github.com/stevearc/oil.nvim' },
})

require("oil").setup({
  default_file_explorer = true,
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

-- FZF & FZF-Lua
vim.pack.add({
  { src = 'https://github.com/junegunn/fzf' },
  { src = 'https://github.com/junegunn/fzf.vim' },
  { src = 'https://github.com/ibhagwan/fzf-lua' },
})

require("fzf-lua").setup({ "border-fused" })

-- Vim-cool (Search Highlight)
vim.pack.add({
  { src = 'https://github.com/romainl/vim-cool' },
})

