-- ~/.config/nvim/lua/plugins/which_key.lua

return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300 -- Tiempo de espera para que aparezca el menú (ms)
    end,
    opts = {
      -- Aquí puedes personalizar el estilo si quieres
      preset = "classic", 
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      
      -- Registrar grupos de nombres para que el menú sea ordenado
      wk.add({
        { "<leader>f", group = "Archivos/Buscar" },
        { "<leader>e", desc = "Explorador de Archivos" },
        { "<leader>x", desc = "Cerrar Buffer" },
        { "<leader>j", group = "Java (LSP)" }, -- Preparando para los atajos de Java
      })
    end,
  },
}
