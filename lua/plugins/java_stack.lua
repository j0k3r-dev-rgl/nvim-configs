-- ~/.config/nvim/lua/plugins/java_stack.lua

return {
  -- 1. nvim-java: El plugin que automatiza TODO lo de Java
  {
    'nvim-java/nvim-java',
    config = false, -- Se inicializa a través de lspconfig
  },

  -- 2. Mason: Para instalar el JDTLS y el Debugger
  {
    'williamboman/mason.nvim',
    opts = {
      ensure_installed = { 'jdtls', 'java-debug-adapter', 'java-test' }
    }
  },
  
  -- 3. LSP Config: La conexión
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'nvim-java/nvim-java',
      'williamboman/mason.nvim',
    },
    config = function()
      -- Paso 1: Inicializar nvim-java (debe ir antes que el LSP)
      require('java').setup()

      -- Paso 2: Definir la configuración usando la nueva API nativa vim.lsp.config
      -- Ya no usamos require('lspconfig').jdtls.setup()
      vim.lsp.config('jdtls', {
        settings = {
          java = {
            configuration = {
              runtimes = {
                {
                  name = "JavaSE-21",
                  path = "/usr/lib/jvm/java-21-openjdk/", -- Ajusta según 'archlinux-java status'
                  default = true,
                },
                {
                  name = "JavaSE-25",
                  path = "/usr/lib/jvm/java-25-openjdk/",
                },
              }
            }
          }
        }
      })
local wk = require("which-key")
wk.add({
  { "<leader>j", group = "Java" },
  { "<leader>jd", vim.lsp.buf.definition, desc = "Ir a Definición" },
  { "<leader>ji", vim.lsp.buf.implementation, desc = "Ir a Implementación" },
  { "<leader>jr", vim.lsp.buf.references, desc = "Ver Referencias" },
  { "<leader>jk", vim.lsp.buf.hover, desc = "Ver Documentación (Hover)" },
  { "<leader>ja", vim.lsp.buf.code_action, desc = "Acciones de Código (Fixes)" },
  { "<leader>rn", vim.lsp.buf.rename, desc = "Renombrar Símbolo" },
})
      -- Paso 3: Habilitar el servidor nativamente
      vim.lsp.enable('jdtls')
    end
  },

  -- 4. Autocompletado profesional
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'L3MON4D3/LuaSnip',
    },
    config = function()
      local cmp = require('cmp')
      cmp.setup({
        snippet = {
          expand = function(args) require('luasnip').lsp_expand(args.body) end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
        })
      })
    end
  }
}
