-- ~/.config/nvim/lua/plugins/multicursor.lua
return {
  {
    'mg979/vim-visual-multi',
    branch = 'master',
    init = function()
      -- Desactivamos los mapeos por defecto para definirlos nosotros
      vim.g.VM_default_mappings = 0 

      -- Definimos los mapas al estilo VS Code
      vim.g.VM_maps = {
        ['Find Under'] = '<C-d>',           -- Seleccionar palabra bajo el cursor (Ctrl+d)
        ['Find Subword Under'] = '<C-d>',   -- Soporte para selección visual
        ['Select Cursor Down'] = '<C-Down>', -- Clonar cursor abajo (opcional)
        ['Select Cursor Up'] = '<C-Up>',     -- Clonar cursor arriba (opcional)
        
        -- IMPORTANTE: Para salir del modo multicursor se usa ESC
      }
      
      -- Opcional: Ajustes para que se sienta más fluido
      vim.g.VM_mouse_mappings = 1
    end,
  }
}
