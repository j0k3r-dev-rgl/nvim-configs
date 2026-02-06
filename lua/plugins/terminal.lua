-- ~/.config/nvim/lua/plugins/terminal.lua

return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup({
        size = 20,
        open_mapping = [[<leader>aa]],
        shading_factor = 1,
        direction = "vertical",
        autochdir = true,
      })

      -- Configurar que OpenCode se ejecute en la raíz del proyecto
      local Terminal = require("toggleterm.terminal").Terminal
      local opencode = Terminal:new({
        cmd = "opencode",
        dir = vim.fn.getcwd(),
        direction = "vertical",
        size = math.floor(vim.o.columns * 0.4),
        display_name = "OpenCode",
        on_open = function(term)
          vim.cmd("wincmd H")  -- Mover terminal a la izquierda
          vim.cmd("startinsert!")
        end,
      })

      local function toggle_opencode()
        opencode:toggle()
      end

      -- Mapear <leader>aa para abrir OpenCode
      local wk = require("which-key")
      wk.add({
        { "<leader>a", group = "Agent" },
        { "<leader>aa", toggle_opencode, desc = "Agentic IDE (OpenCode)" },
      })
    end,
  },
}
