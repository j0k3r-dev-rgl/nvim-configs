-- ~/.config/nvim/lua/config/autocmds.lua

-- Configurar extensión .graphqls como GraphQL (Spring GraphQL)
vim.filetype.add({
  extension = {
    graphqls = "graphql",
  }
})

-- Variable para rastrear si acabamos de abrir un archivo desde nvim-tree
local recently_opened = false

-- Autocomando para detectar cuando se abre un nuevo buffer
vim.api.nvim_create_autocmd("BufReadPost", {
  group = vim.api.nvim_create_augroup("BufferOpened", { clear = true }),
  callback = function()
    recently_opened = true
    -- Resetear después de 100ms
    vim.defer_fn(function()
      recently_opened = false
    end, 100)
    
    -- Cerrar buffers vacíos [No Name] cuando se abre un archivo real
    vim.schedule(function()
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_is_loaded(buf) then
          local bufname = vim.api.nvim_buf_get_name(buf)
          local buftype = vim.api.nvim_buf_get_option(buf, "buftype")
          local modified = vim.api.nvim_buf_get_option(buf, "modified")
          
          -- Si es un buffer vacío sin nombre, sin modificar y no es especial
          if bufname == "" and buftype == "" and not modified then
            -- Verificar que no sea el buffer actual
            if buf ~= vim.api.nvim_get_current_buf() then
              vim.api.nvim_buf_delete(buf, { force = false })
            end
          end
        end
      end
    end)
  end,
})

-- Autocomando para abrir nvim-tree cuando cierres el último buffer
vim.api.nvim_create_autocmd("BufDelete", {
  group = vim.api.nvim_create_augroup("LastBufferClose", { clear = true }),
  callback = function(args)
    -- Usar schedule para ejecutar después de que el buffer se haya cerrado completamente
    vim.schedule(function()
      -- Esperar un poco más para que quit_on_open termine su ejecución
      vim.defer_fn(function()
        -- Si acabamos de abrir un archivo, no hacer nada
        if recently_opened then
          return
        end
        
        -- Obtener todos los buffers
        local buffers = vim.api.nvim_list_bufs()
        local real_buffers = 0
        
        for _, buf in ipairs(buffers) do
          -- Verificar que el buffer no sea el que se está cerrando
          if buf ~= args.buf and vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_is_loaded(buf) then
            local buftype = vim.api.nvim_buf_get_option(buf, "buftype")
            local bufname = vim.api.nvim_buf_get_name(buf)
            local filetype = vim.api.nvim_buf_get_option(buf, "filetype")
            
            -- Contar solo buffers normales (no especiales como nvim-tree, terminal, etc.)
            if buftype == "" and bufname ~= "" and filetype ~= "NvimTree" then
              real_buffers = real_buffers + 1
            end
          end
        end
        
        -- Si no hay buffers reales, abrir nvim-tree y mover el cursor
        if real_buffers == 0 then
          local ok, api = pcall(require, "nvim-tree.api")
          if ok then
            -- Abrir nvim-tree si no está abierto
            if not api.tree.is_visible() then
              api.tree.open()
            end
            -- Mover cursor al árbol (está en el lado derecho)
            vim.cmd("wincmd l")
          end
        end
      end, 50) -- Delay de 50ms para dar tiempo a quit_on_open
    end)
  end,
})
