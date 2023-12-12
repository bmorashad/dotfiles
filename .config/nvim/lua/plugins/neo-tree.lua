return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      sources = { "filesystem", "buffers", "git_status", "document_symbols" },
      filesystem = {
        filtered_items = {
          hide_dotfiles = false,
        },
      },
      window = {
        mappings = {
          ["<C-l>"] = "refresh",
          -- ["<C-r>"] = "rename", -- Rename
          -- ["R"] = "copy", -- To mimic nnn duplicate (C-R)
          -- ["<C-r"] = "rename",
          -- ["N"] = "add_directory", -- see 'n'
          -- ["n"] = "add", -- Create new (file). nnn would ask for 'file', 'dir' and symlinks
          ["."] = "toggle_hidden",
          --            ["<C-o>"] = "open_nofocus", -- Cant use "L" since its used to go back to the code buffer
          ["<C-t>"] = { "show_help", nowait = false, config = { title = "Sort toggles", prefix_key = "t" } }, -- Mimic nnn dialog
          ["<C-x>"] = "cut_to_clipboard", -- Delete
          ["H"] = "set_root",
          ["f"] = "show_file_details", -- File details
          ["h"] = "navigate_up",
          ["n"] = { "show_help", nowait = false, config = { title = "Create new", prefix_key = "n" } }, -- Mimic nnn dialog
          ["nd"] = { "add_directory", nowait = false },
          ["nf"] = { "add", nowait = false },
          ["r"] = "rename", -- Lazy rename. Since neo-tree doesn't have a batch rename function.
          ["td"] = { "order_by_diagnostics", nowait = false }, -- Not in nnn
          ["te"] = { "order_by_type", nowait = false }, -- File extension
          ["tg"] = { "order_by_git_status", nowait = false }, -- Not in nnn
          ["tm"] = { "order_by_modified", nowait = false },
          ["tn"] = { "order_by_name", nowait = false },
          ["ts"] = { "order_by_size", nowait = false },
          ["tt"] = { "order_by_created", nowait = false },
          ["x"] = "delete", -- Delete
          -- ["l"] = "open",
          ["o"] = "open",
        },
      },
    },
  },
}
