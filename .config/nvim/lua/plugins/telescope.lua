local utils = require("telescope.utils")
local builtin = require("telescope.builtin")
_G.project_files = function()
  local _, ret, _ = utils.get_os_command_output({ "git", "rev-parse", "--is-inside-work-tree" })
  if ret == 0 then
    builtin.git_files()
  else
    builtin.find_files()
  end
end
return {
  "nvim-telescope/telescope.nvim",
  keys = {
    -- Remaps

    { "<leader>/", false },
    -- TODO: Do this properly
    {
      ",f",
      "<cmd> lua project_files() <cr>",
      desc = "find in git files",
    },
    -- TODO: Do this properly
    {
      ",a",
      "<cmd> Telescope find_files follow=true no_ignore=true hidden=true prompt_prefix=\\ >\\ <CR>",
      desc = "Find all files",
    },
    { ",g", "<cmd> Telescope live_grep <CR>", desc = "Live grep" },
    { ",b", "<cmd> Telescope buffers <CR>", desc = "Live grep" },
    { ",o", "<cmd> Telescope oldfiles <CR>", desc = "Live grep" },
    { ",z", "<cmd> Telescope command_history <CR>", desc = "Live grep" },
    { ",m", "<cmd> Telescope marks <CR>", desc = "Live grep" },
    { ",s", "<cmd> Telescope spell_suggest <CR>", desc = "Live grep" },
    { "<leader>fz", "<cmd> Telescope current_buffer_fuzzy_find <CR>", desc = "Find in current buffer" },
  },
}
