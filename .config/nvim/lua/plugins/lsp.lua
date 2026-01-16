-- =============================================================================
-- LSP, Completion & Treesitter
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Treesitter
-- -----------------------------------------------------------------------------
vim.pack.add({
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter' },
})

require("nvim-treesitter").setup({
  ensure_installed = {
    "bash", "c", "cpp", "html", "javascript", "jsdoc", "json", "json5",
    "lua", "luadoc", "luap", "markdown", "markdown_inline", "python",
    "regex", "toml", "vim", "vimdoc", "yaml",
  },
  auto_install = true,
  highlight = { enable = true },
  indent = { enable = true },
})

-- Update hook for Treesitter
vim.api.nvim_create_autocmd("PackChanged", {
  group = vim.api.nvim_create_augroup("TreesitterPackUpdate", { clear = true }),
  callback = function(args)
    if args.data and args.data.spec and args.data.spec.name == "nvim-treesitter" then
      if args.data.kind == "update" or args.data.kind == "install" then
        vim.cmd("TSUpdate")
      end
    end
  end,
})

-- -----------------------------------------------------------------------------
-- Blink.cmp (Completion)
-- -----------------------------------------------------------------------------
vim.pack.add({
  { src = 'https://github.com/saghen/blink.cmp' },
})

require("blink.cmp").setup({
  keymap = { preset = "enter" },
  completion = { documentation = { auto_show = false } },
  sources = {
    default = { "lsp", "buffer" },
  },
  fuzzy = { implementation = "prefer_rust_with_warning" }
})

-- Build hook for Blink
local function build_blink(path)
  vim.notify("Building blink.cmp...", vim.log.levels.INFO)
  vim.system({ "cargo", "build", "--release" }, { cwd = path }, function(obj)
    if obj.code == 0 then
      vim.schedule(function() vim.notify("blink.cmp built successfully", vim.log.levels.INFO) end)
    else
      vim.schedule(function() vim.notify("blink.cmp build failed", vim.log.levels.ERROR) end)
    end
  end)
end

vim.api.nvim_create_autocmd("PackChanged", {
  group = vim.api.nvim_create_augroup("BlinkBuildHook", { clear = true }),
  callback = function(args)
    if args.data.spec.name == "blink.cmp" then
      if args.data.kind == "update" or args.data.kind == "install" then
        build_blink(args.data.path)
      end
    end
  end,
})

-- -----------------------------------------------------------------------------
-- General LSP Configuration
-- -----------------------------------------------------------------------------
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp", { clear = true }),
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    local bufnr = args.buf

    -- LSP keybindings helper
    local function map(mode, key, fn, desc)
      vim.keymap.set(mode, key, fn, { silent = true, buffer = bufnr, desc = "LSP: " .. desc })
    end

    map("n", "mR", vim.lsp.buf.rename, "Rename symbol")
    map("n", "mr", vim.lsp.buf.references, "List references")
    map("n", "mh", vim.lsp.buf.hover, "Hover")
    map("n", "md", vim.lsp.buf.definition, "Go to definition")
    map({ "n", "v" }, "ma", function() vim.lsp.buf.code_action({ apply = true }) end, "Code action")

    -- Format on save
    if not client:supports_method("textDocument/willSaveWaitUntil", bufnr) and
      client:supports_method("textDocument/formatting", bufnr) then
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({ bufnr = bufnr, id = client.id, timeout_ms = 1000 })
        end,
      })
    end

    -- Highlight symbol under cursor
    if client:supports_method("textDocument/documentHighlight", bufnr) then
      -- Fallback highlight groups
      if not vim.fn.hlexists("LspReferenceRead") then
        vim.api.nvim_set_hl(0, "LspReferenceRead", { link = "Visual" })
        vim.api.nvim_set_hl(0, "LspReferenceText", { link = "Visual" })
        vim.api.nvim_set_hl(0, "LspReferenceWrite", { link = "Visual" })
      end

      local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight-" .. bufnr, { clear = true })
      vim.api.nvim_create_autocmd("CursorHold", {
        group = highlight_augroup,
        buffer = bufnr,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd("CursorMoved", {
        group = highlight_augroup,
        buffer = bufnr,
        callback = vim.lsp.buf.clear_references,
      })
    end
  end,
})

-- Diagnostics
local signs = { Error = " ", Warn  = " ", Hint  = "󰠠 ", Info  = " " }
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

-- Capabilities
vim.opt.completeopt = { "menuone", "noinsert", "noselect", "fuzzy" }
