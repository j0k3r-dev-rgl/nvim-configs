-- ~/.config/nvim/lua/plugins/trouble.lua
return {
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      {
        "<leader>tt",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Panel de Errores",
      },
      {
        "<leader>ts",
        "<cmd>Trouble symbols toggle focus=true<cr>",
        desc = "Estructura de Clase",
      },
    },
    opts = {
      -- Configuración para mover el panel
      modes = {
        symbols = {
          mode = "lsp_document_symbols",
          groups = {
            { "kind", "fixed" },
          },
          win = {
            position = "left", -- <--- AQUÍ lo movemos a la izquierda
            width = 35,        -- Ancho similar a tu NvimTree
          },
        },
      },
    },
  },
}
