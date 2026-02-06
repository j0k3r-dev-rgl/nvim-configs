-- ~/.config/nvim/lua/plugins/java_stack.lua
-- Configuración principal de Java con nvim-java
-- Este archivo tiene PRIORIDAD ALTA para cargar antes que lsp.lua

return {
  -- 1. Mason: Instalador unificado (se carga primero)
  {
    'williamboman/mason.nvim',
    priority = 100, -- Prioridad alta para cargar primero
    config = function()
      require('mason').setup()
    end
  },

  -- 2. Mason Tool Installer: Instala todas las herramientas necesarias
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    dependencies = { 'williamboman/mason.nvim' },
    priority = 99,
    config = function()
      require('mason-tool-installer').setup({
        ensure_installed = {
          -- Java (JDTLS + Debug)
          'jdtls',
          'java-debug-adapter',
          'java-test',

          -- LSPs para Spring Boot
          'lemminx',       -- XML (pom.xml, config)
          'yamlls',        -- YAML (application.yml)
          'graphql',       -- GraphQL

          -- Formateadores
          'prettier',      -- GraphQL y YAML
          'xmlformatter',  -- XML
        },
      })
    end
  },

  -- 3. nvim-java: El plugin que automatiza TODO lo de Java
  {
    'nvim-java/nvim-java',
    priority = 98, -- Debe inicializarse antes de lspconfig
    ft = { 'java' }, -- Solo se carga con archivos Java
    config = function()
      require('java').setup()
    end
  },

  -- 4. LSP Config: Configuración de JDTLS
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'nvim-java/nvim-java',
      'williamboman/mason.nvim',
      'hrsh7th/cmp-nvim-lsp',
    },
    priority = 97,
    config = function()
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      -- Configurar JDTLS usando la nueva API nativa
      vim.lsp.config('jdtls', {
        capabilities = capabilities,
        settings = {
          java = {
            configuration = {
              runtimes = {
                {
                  name = "JavaSE-21",
                  path = "/usr/lib/jvm/java-21-openjdk/",
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

      -- Keybindings específicos de Java
      local wk = require("which-key")
      wk.add({
        { "<leader>j", group = "Java" },
        { "<leader>jd", vim.lsp.buf.definition, desc = "Ir a Definición" },
        { "<leader>ji", vim.lsp.buf.implementation, desc = "Ir a Implementación" },
        { "<leader>jr", vim.lsp.buf.references, desc = "Ver Referencias" },
        { "<leader>jk", vim.lsp.buf.hover, desc = "Ver Documentación (Hover)" },
        { "<leader>ja", vim.lsp.buf.code_action, desc = "Acciones de Código (Fixes)" },
        { "<leader>jn", vim.lsp.buf.rename, desc = "Renombrar Símbolo" },
      })

      -- Habilitar el servidor JDTLS
      vim.lsp.enable('jdtls')
    end
  },

  -- 5. Autocompletado profesional
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
