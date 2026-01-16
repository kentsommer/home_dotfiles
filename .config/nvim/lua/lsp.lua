vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp", { clear = true }),
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

    local lsp_buffer_augroup = vim.api.nvim_create_augroup(string.format("lsp-buffer-%d", args.data.client_id), { clear = false })
    local function aucmd(event, callback)
      vim.api.nvim_create_autocmd(event, { group = lsp_buffer_augroup, buffer = args.buf, callback = callback })
    end

    -- LSP keybindings.
    local function map(mode, key, fn, desc)
      vim.keymap.set(mode, key, fn, { silent = true, buffer = args.buf, desc = "LSP:" .. desc })
    end
    map("n", "mR", vim.lsp.buf.rename, "Rename symbol")
    map("n", "mr", vim.lsp.buf.references, "List references")
    map("n", "mh", vim.lsp.buf.hover, "Hover")
    map("n", "md", vim.lsp.buf.definition, "Go to definition")
    map({ "n", "v" }, "ma", function() vim.lsp.buf.code_action({ apply = true }) end, "Code action")

    -- Format on save.
    if not client:supports_method("textDocument/willSaveWaitUntil", args.buf) and
      client:supports_method("textDocument/formatting", args.buf) then
      aucmd("BufWritePre", function() vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 }) end)
    end

    -- Highlight symbol under cursor in other parts of the document.
    if client:supports_method("textDocument/documentHighlight", args.buf) then
      -- Fix colorschemes which do not support LSP highlight groups.
      if not vim.fn.hlexists("LspReferenceRead") then
        vim.api.nvim_set_hl(0, "LspReferenceRead", { link = "Visual" })
        vim.api.nvim_set_hl(0, "LspReferenceText", { link = "Visual" })
        vim.api.nvim_set_hl(0, "LspReferenceWrite", { link = "Visual" })
      end

      aucmd("CursorHold", function() vim.lsp.buf.document_highlight() end)
      aucmd("CursorMoved", function() vim.lsp.buf.clear_references() end)
    end
  end,
})

-- Improve UI for regular and LSP-based autocompletion, :help completeopt.
vim.opt.completeopt = { "menuone", "noinsert", "noselect", "fuzzy" }

-- Tweak diagnostics (:help vim.diagnostic.config)
local signs = {
  Error = " ",
  Warn  = " ",
  Hint  = "󰠠 ",
  Info  = " ",
}

vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = signs.Error,
      [vim.diagnostic.severity.WARN]  = signs.Warn,
      [vim.diagnostic.severity.HINT]  = signs.Hint,
      [vim.diagnostic.severity.INFO]  = signs.Info,
    },
  },
  severity_sort = true,
  virtual_text = true,
})
