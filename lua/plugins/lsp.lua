-- ~/.config/nvim/lua/plugins/lsp.lua
-- Configuración de LSPs adicionales (XML, YAML, GraphQL)
-- Este archivo se carga DESPUÉS de java_stack.lua

return {
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    priority = 50, -- Se carga después de java_stack.lua
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      require("mason-lspconfig").setup({
        handlers = {
          -- Handler por defecto para LSPs no específicos
          function(server_name)
            -- Ignorar jdtls porque ya se configura en java_stack.lua
            if server_name ~= "jdtls" then
              require("lspconfig")[server_name].setup({
                capabilities = capabilities,
              })
            end
          end,

          -- XML LSP (para pom.xml y configs de Spring)
          ["lemminx"] = function()
            require("lspconfig").lemminx.setup({
              capabilities = capabilities,
              settings = {
                xml = {
                  server = { workDir = "~/.cache/lemminx" }
                }
              }
            })
          end,

          -- YAML LSP (para application.yml de Spring Boot)
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
                    -- Schema específico para Spring Boot
                    ["https://raw.githubusercontent.com/spring-projects/spring-boot/main/spring-boot-project/spring-boot-tools/spring-boot-configuration-metadata/src/main/resources/org/springframework/boot/configuration-metadata-2.0.json"] = "application.yml",
                  },
                  format = { enable = true },
                }
              }
            })
          end,

          -- GraphQL LSP (para APIs Spring con GraphQL)
          ["graphql"] = function()
            require("lspconfig").graphql.setup({
              capabilities = capabilities,
              filetypes = { "graphql", "graphqls", "gql" },
              root_dir = require("lspconfig.util").root_pattern(
                ".graphqlrc*",
                ".graphql.config.*",
                "pom.xml",
                ".git"
              ),
            })
          end,
        }
      })
    end,
  }
}
