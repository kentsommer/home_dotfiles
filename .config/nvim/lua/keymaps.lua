---------------------
-- Quality Of Life --
---------------------
vim.keymap.set(
  'n',
  '*',
  function()
    local word = vim.fn.expand("<cword>")
    vim.fn.setreg('/', [[\V\<]] .. word .. [[\>]])
    vim.opt.hlsearch = true
  end,
  { 
    desc = "Search word under cursor",
    silent = true,
  }
)

vim.keymap.set(
  'n', 
  '<space>', 
  '/', 
  {
    desc = "Search",
    remap = true,
  }
)

vim.keymap.set(
  'n', 
  '0', 
  '^', 
  {
    desc = "Jump to first non-blank character",
    remap = true,
  }
)

vim.keymap.set(
  'n',
  'ml',
  ':set invnumber<CR>',
  { 
    desc = "Toggle Line Numbers",
    noremap = true,
    silent = true,
  }
)

-----------------------
-- Plugin Management --
-----------------------

vim.keymap.set(
  'n',
  '<leader>u',
  '<CMD>lua vim.pack.update()<CR>',
  { 
    desc = "Update plugins",
  }
)
