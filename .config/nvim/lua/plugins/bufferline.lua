return {
  "akinsho/bufferline.nvim",
  enabled = true,
  event = "VeryLazy",
  opts = {
    options = {
      -- hightlights = {
      --   offset_separator = {
      --     fg = "#665c54", -- colors.dark3
      --     bg = "#3c3836", -- colors.dark1
      --   },
      -- },
      separator_style = "thin",
      offsets = {
        {
          -- padding = 1,
          separator = true,
          -- separator = "|",
          filetype = "NvimTree",
          text = "File Explore",
          highlight = "Directory",
          text_align = "left",
        },
      },
    },
  },
}
