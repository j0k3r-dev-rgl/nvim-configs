-- ~/.config/nvim/lua/plugins/bufferline.lua

return {
  {
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
      require("bufferline").setup({
        options = {
          mode = "buffers", -- pestañas normales
          separator_style = "slant", -- estilo elegante inclinado
          always_show_bufferline = true,
          show_buffer_close_icons = true,
          show_close_icon = false,
          color_icons = true,
          -- Esto hace que el explorador de archivos no tape las pestañas
           offsets = {
            {
              filetype = "NvimTree",
              text = "File Explorer",
              text_align = "center",
              separator = true,
            }
          },
        }
      })

      -- Atajos para moverte entre buffers (TAB y SHIFT-TAB)
      vim.keymap.set('n', '<Tab>', ':BufferLineCycleNext<CR>', { silent = true })
      vim.keymap.set('n', '<S-Tab>', ':BufferLineCyclePrev<CR>', { silent = true })
      
      -- Cerrar buffer actual con <leader>x
      vim.keymap.set('n', '<leader>x', ':bdelete<CR>', { silent = true })
    end
  }
}
