-- ~/.config/nvim/lua/plugins/nvim_tree.lua

return {
  { 'nvim-tree/nvim-web-devicons' },
  {
    'nvim-tree/nvim-tree.lua',
    version = "*",
    lazy = false,
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require("nvim-tree").setup({
        sort_by = "case_sensitive",
        git = {
          enable = true,
          ignore = false, -- MUY IMPORTANTE: Cambiar a false para que nvim-tree NO oculte los archivos del .gitignore
          timeout = 400,
        },
        view = {
          width = 35,
          side = "right",
          relativenumber = true,
        },
        renderer = {
          group_empty = true,
          highlight_git = true, -- Esto hace que los nombres de archivos cambien de color según Git
          icons = {
            show = {
              file = true,
              folder = true,
              folder_arrow = true,
              git = true,
            },
          },
        },
        filters = {
          dotfiles = false,
          -- Desactivamos el filtro aquí también para asegurar visibilidad
          git_ignored = false, 
        },
        on_attach = function(bufnr)
          local api = require("nvim-tree.api")
          -- Mapear 'l' para expandir/abrir carpeta
          vim.keymap.set("n", "l", api.node.open.replace_tree_buffer, { buffer = bufnr, noremap = true, silent = true })
          -- Mapear 'h' para cerrar/colapsar carpeta
          vim.keymap.set("n", "h", api.node.navigate.parent_close, { buffer = bufnr, noremap = true, silent = true })
        end,
      })

      vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', { silent = true, desc = "Explorador de archivos" })
    end,
  },
}
