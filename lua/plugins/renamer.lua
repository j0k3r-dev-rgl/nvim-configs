-- ~/.config/nvim/lua/plugins/renamer.lua
return {
  {
    "smjonas/inc-rename.nvim",
    config = function()
      require("inc_rename").setup({
        -- Muestra una vista previa de los cambios mientras escribes
        show_message = true, 
      })

      -- Mapeo Estilo IntelliJ / Estándar
      -- Usaremos <leader>rn (ReName) o F2 (clásico de IDEs)
      vim.keymap.set("n", "<leader>rn", function()
        return ":IncRename " .. vim.fn.expand("<cword>")
      end, { expr = true, desc = "Renombrado Inteligente (LSP)" })
      
      -- Opción con F2 para sentirse como en casa
      vim.keymap.set("n", "<F2>", function()
        return ":IncRename " .. vim.fn.expand("<cword>")
      end, { expr = true, desc = "Renombrado Inteligente (LSP)" })
    end,
  }
}
