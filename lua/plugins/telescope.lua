return {
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local telescope = require('telescope')
      local builtin = require('telescope.builtin')
      local wk = require("which-key")

      -- Configurar telescope sin treesitter highlighting
      telescope.setup({
        defaults = {
          -- Deshabilitar treesitter en el preview para evitar errores
          preview = {
            treesitter = false,
          },
        }
      })

      wk.add({
        { "<leader>f", group = "Buscar" },
        { "<leader>ff", builtin.find_files, desc = "Buscar Archivos" },
        { "<leader>fg", builtin.live_grep, desc = "Buscar Texto (Grep)" },
        { "<leader>fb", builtin.buffers, desc = "Buscar Buffers" },
        { "<leader>fs", builtin.lsp_document_symbols, desc = "Símbolos del Documento (Métodos/Variables)" },
      })
    end
  }
}
