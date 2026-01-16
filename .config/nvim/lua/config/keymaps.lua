-- =============================================================================
-- Keymaps
-- =============================================================================

-- Better search: Search for word under cursor without moving
vim.keymap.set('n', '*', function()
  local word = vim.fn.expand("<cword>")
  vim.fn.setreg('/', [[\V\<]] .. word .. [[\>]])
  vim.opt.hlsearch = true
end, { desc = "Search word under cursor", silent = true })

-- Search with Space
vim.keymap.set('n', '<space>', '/', { desc = "Search", remap = true })

-- Better Start of Line
vim.keymap.set('n', '0', '^', { desc = "Jump to first non-blank character", remap = true })

-- Toggle Line Numbers
vim.keymap.set('n', 'ml', ':set invnumber<CR>', { desc = "Toggle Line Numbers", silent = true })

-- Plugin Management
vim.keymap.set('n', '<leader>u', '<CMD>lua vim.pack.update()<CR>', { desc = "Update plugins" })
