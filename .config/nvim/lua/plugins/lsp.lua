return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- autoformat = false,
    },
    init = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      -- change a keymap
      keys[#keys + 1] = { "gr", vim.lsp.buf.definition }
      keys[#keys + 1] = { "gd", require("telescope.builtin").lsp_references }
      keys[#keys + 1] = { "gi", require("telescope.builtin").lsp_implementations }
      -- disable a keymap
      -- keys[#keys + 1] = { "gd", false }
      -- keys[#keys + 1] = { "gr", false }
      -- add a keymap
      keys[#keys + 1] = { ",r", vim.lsp.buf.rename }
    end,
  },
}
