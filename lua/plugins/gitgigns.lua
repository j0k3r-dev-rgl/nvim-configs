-- ~/.config/nvim/lua/plugins/git.lua
return {
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      local gs = require('gitsigns')

      gs.setup({
        signs = {
          add          = { text = '┃' },
          change       = { text = '┃' },
          delete       = { text = '_' },
          topdelete    = { text = '‾' },
          changedelete = { text = '~' },
          untracked    = { text = '┆' },
        },
        signcolumn = true, -- Esto usa la columna que fijamos antes
        numhl      = false,
      })

      -- Registramos los atajos globalmente para que Which-key los pille siempre
      local wk = require("which-key")
      wk.add({
        { "<leader>g", group = "Git" },
        { "<leader>gh", gs.preview_hunk, desc = "Previsualizar cambio (Hunk)" },
        { "<leader>gb", function() gs.blame_line{full=true} end, desc = "Git Blame completo" },
        { "<leader>gr", gs.reset_hunk, desc = "Revertir cambio" },
        { "<leader>gd", gs.diffthis, desc = "Ver Diff del archivo" },
        { "<leader>gj", gs.next_hunk, desc = "Siguiente cambio" },
        { "<leader>gk", gs.prev_hunk, desc = "Anterior cambio" },
      })
    end
  }
}
