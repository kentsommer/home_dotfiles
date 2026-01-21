-- Clipboard
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "OSC 52 on yank only",
  callback = function()
    if vim.v.event.operator == "y" then
      local text = vim.v.event.regcontents
      local regtype = vim.v.event.regtype
      require('vim.ui.clipboard.osc52').copy('+')(text)
    end
  end,
})

-- Whitespace
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    local save_cursor = vim.fn.getpos(".")
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.setpos(".", save_cursor)
  end,
})
