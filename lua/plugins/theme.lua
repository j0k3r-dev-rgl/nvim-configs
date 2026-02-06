-- ~/.config/nvim/lua/plugins/theme.lua
return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "night", -- El más oscuro y profundo
      transparent = false, -- Cambia a true si tu terminal tiene transparencia
      terminal_colors = true,
      styles = {
        sidebars = "dark", -- Hace que nvim-tree sea más oscuro que el editor
        floats = "dark",   -- Menús flotantes elegantes
      },
      on_highlights = function(hl, c)
        -- Toque especial para Java:
        hl['@lsp.type.interface.java'] = { fg = c.orange, italic = true } -- Interfaces en naranja e itálica
        hl['@lsp.type.annotation.java'] = { fg = c.magenta } -- Anotaciones (@Service, etc) en magenta
      end,
    },
    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd([[colorscheme tokyonight-night]])
    end,
  },
}
