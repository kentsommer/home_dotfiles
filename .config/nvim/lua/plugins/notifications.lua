-- =============================================================================
-- Notifications Configuration (Fidget.nvim)
-- =============================================================================

-- Fidget (notifications)
vim.pack.add({
  { src = 'https://github.com/j-hui/fidget.nvim' },
})

require("fidget").setup({
  notification = {
    override_vim_notify = true,
    filter = vim.log.levels.DEBUG,
  },
  progress = {
    poll_rate = 0.5, -- How and when to poll for progress messages
    suppress_on_insert = true, -- Suppress progress messages while in insert mode
    ignore_done_already = true, -- Ignore progress messages that are already done
    ignore_empty_message = true, -- Ignore progress messages with an empty message
    lsp = {
      progress_ringbuf_size = 1024, -- Increase ring buffer size for high-volume LSPs
    },
  },
})

