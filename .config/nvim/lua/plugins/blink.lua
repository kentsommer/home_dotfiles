return {
  'saghen/blink.cmp',
  build = "/usr/bin/env fish -c 'cargo build --release'",
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    keymap = { preset = "enter" },
    completion = { documentation = { auto_show = false } },
    sources = {
      default = { "lsp" },
    },
    fuzzy = { implementation = "prefer_rust_with_warning" }
  },
  opts_extend = { "sources.default" }
}
