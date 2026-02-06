-- ~/.config/nvim/lua/plugins/lsp.lua
return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim", -- <--- NUEVO PLUGIN NECESARIO
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      require("mason").setup()

      -- AQUÍ ES DONDE OCURRE LA MAGIA DE LOS FORMATEADORES
      require("mason-tool-installer").setup({
        ensure_installed = {
          -- LSPs (Cerebros)
          "lemminx",       -- XML
          "yamlls",        -- YAML
          "graphql",       -- GraphQL
          
          -- Formateadores (Estilistas) -> ESTOS TE FALTABAN
          "prettier",      -- Para GraphQL y YAML
          "xmlformatter",  -- Para XML
        },
      })

      require("mason-lspconfig").setup({
        handlers = {
          function(server_name)
            require("lspconfig")[server_name].setup({
              capabilities = capabilities,
            })
          end,

          ["lemminx"] = function()
            require("lspconfig").lemminx.setup({
              capabilities = capabilities,
              settings = { xml = { server = { workDir = "~/.cache/lemminx" } } }
            })
          end,

          ["yamlls"] = function()
            require("lspconfig").yamlls.setup({
              capabilities = capabilities,
              settings = {
                yaml = {
                  schemaStore = {
                    enable = true,
                    url = "https://www.schemastore.org/api/json/catalog.json",
                  },
                  schemas = {
                    ["https://raw.githubusercontent.com/spring-projects/spring-boot/main/spring-boot-project/spring-boot-tools/spring-boot-configuration-metadata/src/main/resources/org/springframework/boot/configuration-metadata-2.0.json"] = "application.yml",
                  },
                  format = { enable = true },
                }
              }
            })
          end,

          ["graphql"] = function()
            require("lspconfig").graphql.setup({
              capabilities = capabilities,
              filetypes = { "graphql", "graphqls", "gql" },
              root_dir = require("lspconfig.util").root_pattern(".graphqlrc*", ".graphql.config.*", "pom.xml", ".git"),
            })
          end,
        }
      })
    end,
  }
}
