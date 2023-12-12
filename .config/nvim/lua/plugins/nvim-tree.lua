return {
  "nvim-tree/nvim-tree.lua",
  -- enabled = false,
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  keys = {
    { ",e", "<Cmd>NvimTreeToggle <CR>", desc = "Toggle nvimtree" },
    -- { ",s", "<Cmd>NvimTreeFindFileToggle <CR>", desc = "Toggle nvimtree" },
    { "<leader>e", "<Cmd>NvimTreeToggle <CR>", desc = "Toggle nvimtree" },
  },
  config = function()
    require("nvim-tree").setup({})
  end,
}
