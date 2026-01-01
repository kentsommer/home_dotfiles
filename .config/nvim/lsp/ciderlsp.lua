---@type vim.lsp.ClientConfig
return {
  cmd = { "/google/bin/releases/cider/ciderlsp/ciderlsp", "--tooltag=nvim-lsp", "--noforward_sync_responses", "--cdpush_name=" },
  -- Languages supported by CiderLSP, see go/ciderlsp.
  filetypes = { "borg", "bzl", "c", "cpp", "cs", "dart", "gcl", "go", "googlesql", "graphql", "java", "kotlin", "markdown", "mlir", "ncl", "objc", "patchpanel", "proto", "python", "qflow", "soy", "swift", "textpb", "typescript" },
  -- Only run if the file is under the /google mount. This is faster than
  -- `root_markers = { ".citc" }` which has to crawl up the file hierarchy.
  root_dir = function(bufnr, cb)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    local root_dir = "/google"
    if vim.startswith(fname, root_dir) then
      cb(root_dir)
    end
  end,
}
