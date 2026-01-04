return {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  build = ':TSUpdate',
  opts = {
    -- custom handling of parsers
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
  },
  config = function(_, opts)
    if opts.ensure_installed and #opts.ensure_installed > 0 then
      require("nvim-treesitter").install(opts.ensure_installed)
      for _, parser in ipairs(opts.ensure_installed) do
        local filetypes = parser
        vim.treesitter.language.register(parser, filetypes)
        vim.api.nvim_create_autocmd({ "FileType" }, {
          pattern = filetypes,
          callback = function(event)
            vim.treesitter.start(event.buf, parser)
          end,
        })
      end
    end
  end,
}