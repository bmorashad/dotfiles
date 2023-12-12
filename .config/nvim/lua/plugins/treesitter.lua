return {
  "nvim-treesitter/nvim-treesitter",
  -- opts = {
  --   ignore_install = { "markdown", "markdown_inline" },
  --   ensure_installed = {},
  -- },
  opts = {
    highlight = {
      disable = { "markdown" },
      -- Disable if the file has more than 10000 lines
      -- (usually done for performance issues with large files when treesitter is loaded)
      -- disable = function(_, bufnr) -- Disable in large buffers
      --   return vim.api.nvim_buf_line_count(bufnr) > 10000
      -- end,
    },
  },
  -- opts = function(_, opts)
  --   return {}
  -- end,
  -- config = function(_, opts)
  --   -- return {}
  --   if opts and opts.ensure_installed then
  --     -- Languages to remove from ensure_installed
  --     local languages_to_remove = { "go" } -- Modify this list as needed
  --
  --     -- Remove specified languages from ensure_installed
  --     opts.ensure_installed = vim.tbl_filter(function(lang)
  --       return not vim.tbl_contains(languages_to_remove, lang)
  --     end, opts.ensure_installed)
  --   end
  --   return opts
  -- end,
}
