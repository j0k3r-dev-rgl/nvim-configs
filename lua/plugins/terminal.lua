-- ~/.config/nvim/lua/plugins/terminal.lua
return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup({
        -- Configuración global (opcional si solo usas OpenCode)
        size = function(term)
          if term.direction == "vertical" then
            return math.floor(vim.o.columns * 0.33)
          end
          return 15
        end,
        open_mapping = [[<leader>aa]],
        direction = "vertical",
        autochdir = true,
      })

      local Terminal = require("toggleterm.terminal").Terminal
      
      -- Calculamos 1/3 del ancho actual de tu Arch Linux
      local fixed_width = math.floor(vim.o.columns * 0.33)

      local opencode = Terminal:new({
        cmd = "opencode",
        dir = vim.fn.getcwd(),
        direction = "vertical",
        -- Aquí forzamos el tamaño fijo de 1/3
        size = fixed_width,
        display_name = "OpenCode",
        on_open = function(term)
          -- Movemos a la izquierda
          vim.cmd("wincmd H")
          -- RE-AJUSTE: Después de moverla, forzamos el ancho otra vez
          -- Esto evita que Neovim la deje al 50%
          vim.api.nvim_win_set_width(0, fixed_width)
          vim.cmd("startinsert!")
        end,
      })

      local function toggle_opencode()
        opencode:toggle()
      end

      local wk = require("which-key")
      wk.add({
        { "<leader>a", group = "Agent" },
        { "<leader>aa", toggle_opencode, desc = "Agentic IDE (OpenCode)" },
      })
    end,
  },
}
