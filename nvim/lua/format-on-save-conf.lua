local format_on_save = require("format-on-save")
local formatters = require("format-on-save.formatters")

format_on_save.setup({
  exclude_path_patterns = {
    "/node_modules/",
    ".local/share/nvim/lazy",
  },
  formatter_by_ft = {
    graphql = {
      formatters.prettierd,
    },
    astro = {
      formatters.eslint_d_fix,
      formatters.prettierd,
    },
    svelte = {
      formatters.eslint_d_fix,
      formatters.lsp
    },
    css = formatters.lsp,
    html = formatters.lsp,
    java = formatters.lsp,
    javascript = {
      formatters.eslint_d_fix,
      -- formatters.shell({ cmd = "biome format" })
      formatters.prettierd,
    },
    json = formatters.lsp,
    jsonc = formatters.lsp,
    lua = formatters.lsp,
    markdown = formatters.prettierd,
    openscad = formatters.lsp,
    python = formatters.black,
    rust = formatters.lsp,
    scad = formatters.lsp,
    scss = formatters.lsp,
    sh = formatters.shfmt,
    terraform = formatters.lsp,
    typescript = {
      formatters.eslint_d_fix,
      -- formatters.shell({ cmd = "biome format" })
      formatters.prettierd,
    },
    typescriptreact = {
      formatters.eslint_d_fix,
      -- formatters.shell({ cmd = "biome format" }),
      formatters.prettierd,
    },
    yaml = formatters.lsp,
  }
})
