-- ~/.config/nvim/lua/plugins/lspsaga.lua
return {
  {
    'nvimdev/lspsaga.nvim',
    dependencies = {
      'nvim-treesitter/nvim-treesitter', -- Para resaltado de código en las ventanas
      'nvim-tree/nvim-web-devicons',     -- Para iconos
    },
    config = function()
      require('lspsaga').setup({
        ui = {
          border = 'rounded', -- Bordes redondeados muy elegantes
          code_action = '💡', -- Icono para sugerencias de fixes
        },
        symbol_in_winbar = {
          enable = true, -- Muestra la ruta del método arriba (breadcrumbs)
        },
        lightbulb = {
          enable = true, -- Te avisa con una bombilla si hay un fix disponible
        },
      })

      -- Actualizamos los atajos de Which-key para usar Lspsaga
      local wk = require("which-key")
      wk.add({
        { "<leader>l", group = "LSP Saga (Mejorado)" },
        { "<leader>lf", "<cmd>Lspsaga finder<cr>", desc = "Buscador de Definición/Referencias" },
        { "<leader>la", "<cmd>Lspsaga code_action<cr>", desc = "Acciones de Código (Fixes)" },
        { "<leader>lo", "<cmd>Lspsaga outline<cr>", desc = "Esquema del Archivo (Métodos)" },
        { "<leader>lk", "<cmd>Lspsaga hover_doc<cr>", desc = "Documentación (Hover)" },
        { "<leader>ld", "<cmd>Lspsaga show_line_diagnostics<cr>", desc = "Ver error de la línea" },
        { "<leader>lr", "<cmd>Lspsaga rename<cr>", desc = "Renombrar Símbolo" },
      })
    end,
  }
}
