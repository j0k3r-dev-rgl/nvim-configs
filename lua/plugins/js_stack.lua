-- ~/.config/nvim/lua/plugins/js_stack.lua
-- Stack profesional para JavaScript/TypeScript + React Router 7 (Vite)
--
-- DETECCIÓN DE RAÍZ (carga condicional):
-- Antes de activar cualquier cosa, se busca hacia arriba desde el directorio
-- actual archivos típicos de un proyecto JS/TS (package.json, tsconfig.json,
-- vite.config.ts, etc.) usando vim.fs.find con `upward = true`.
-- Si ninguno existe, la función `is_js_project()` retorna false y NINGÚN
-- servidor LSP de este stack se habilita. Esto evita saturar el editor
-- cuando abres carpetas aleatorias que no son proyectos JS.

--- Detecta si el directorio actual pertenece a un proyecto JavaScript/TypeScript.
--- Busca archivos marcadores hacia arriba desde el cwd.
--- @return boolean
local function is_js_project()
  local markers = {
    'package.json',
    'tsconfig.json',
    'tsconfig.app.json',
    'jsconfig.json',
    'vite.config.ts',
    'vite.config.js',
    'react-router.config.ts', -- Específico de React Router 7
  }
  local found = vim.fs.find(markers, {
    upward = true,
    path = vim.fn.getcwd(),
    limit = 1,
  })
  return #found > 0
end

return {
  -- 1. Mason Tool Installer: herramientas del stack JS/TS
  -- Mason ya está inicializado en java_stack.lua, aquí solo declaramos
  -- las herramientas adicionales que necesitamos.
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    dependencies = { 'williamboman/mason.nvim' },
    config = function()
      require('mason-tool-installer').setup({
        ensure_installed = {
          -- LSPs
          'vtsls',              -- TypeScript/JavaScript (reemplazo moderno de tsserver)
          'tailwindcss-language-server', -- Tailwind CSS
          'eslint-lsp',         -- ESLint como LSP

          -- Formateadores
          'prettier',           -- Ya existe en java_stack, pero lo declaramos por completitud
        },
      })
    end,
  },

  -- 2. LSP Config: servidores del stack JS/TS
  -- Solo se activan si is_js_project() retorna true.
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
      -- Si no es un proyecto JS, no configurar nada
      if not is_js_project() then
        return
      end

      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      -- === vtsls: servidor principal para TypeScript/JavaScript ===
      -- Mejor rendimiento que tsserver para proyectos React grandes.
      -- Soporta .ts, .tsx, .js, .jsx de forma nativa.
      vim.lsp.config('vtsls', {
        capabilities = capabilities,
        filetypes = {
          'javascript',
          'javascriptreact',
          'typescript',
          'typescriptreact',
        },
        settings = {
          typescript = {
            -- Habilitar inlay hints para mejor DX
            inlayHints = {
              parameterNames = { enabled = 'all' },
              parameterTypes = { enabled = true },
              variableTypes = { enabled = true },
              propertyDeclarationTypes = { enabled = true },
              functionLikeReturnTypes = { enabled = true },
            },
            -- Preferir imports con rutas relativas (común en React Router 7)
            preferences = {
              importModuleSpecifier = 'relative',
            },
          },
          javascript = {
            inlayHints = {
              parameterNames = { enabled = 'all' },
              parameterTypes = { enabled = true },
              variableTypes = { enabled = true },
              propertyDeclarationTypes = { enabled = true },
              functionLikeReturnTypes = { enabled = true },
            },
          },
          vtsls = {
            -- Habilitar soporte para archivos .tsx/.jsx (React)
            tsserver = {
              globalPlugins = {},
            },
          },
        },
      })

      -- === tailwindcss: autocompletado de clases CSS ===
      vim.lsp.config('tailwindcss', {
        capabilities = capabilities,
        filetypes = {
          'html',
          'css',
          'javascript',
          'javascriptreact',
          'typescript',
          'typescriptreact',
        },
        settings = {
          tailwindCSS = {
            experimental = {
              classRegex = {
                -- Soporta className="..." y variantes con template literals
                { 'className\\s*=\\s*["\']([^"\']*)["\']' },
                { 'class:\\s*["\']([^"\']*)["\']' },
              },
            },
          },
        },
      })

      -- === eslint: linting integrado como LSP ===
      vim.lsp.config('eslint', {
        capabilities = capabilities,
        filetypes = {
          'javascript',
          'javascriptreact',
          'typescript',
          'typescriptreact',
        },
        settings = {
          -- Respetar la configuración flat config de ESLint (eslint.config.js)
          useFlatConfig = true,
        },
      })

      -- Habilitar los tres servidores
      vim.lsp.enable('vtsls')
      vim.lsp.enable('tailwindcss')
      vim.lsp.enable('eslint')

      -- === Keybindings específicos para JS/TS - Se registran cuando se abre un archivo JS/TS ===
      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
        callback = function()
          -- Diferir para asegurar que which-key esté disponible
          vim.schedule(function()
            local ok, wk = pcall(require, 'which-key')
            if ok then
              wk.add({
                { '<leader>t', group = 'TypeScript/JS' },

                -- LSP básico
                { '<leader>td', vim.lsp.buf.definition, desc = 'Ir a Definición' },
                { '<leader>ti', vim.lsp.buf.implementation, desc = 'Ir a Implementación' },
                { '<leader>tr', vim.lsp.buf.references, desc = 'Ver Referencias' },
                { '<leader>tk', vim.lsp.buf.hover, desc = 'Ver Documentación (Hover)' },
                { '<leader>ta', vim.lsp.buf.code_action, desc = 'Acciones de Código' },
                { '<leader>tn', vim.lsp.buf.rename, desc = 'Renombrar Símbolo' },

                -- React Router 7 específico - Navegación rápida de archivos
                { '<leader>tf', group = 'Files (React Router 7)' },

                { '<leader>tfc', function()
                  vim.cmd('edit react-router.config.ts')
                end, desc = '⚙️  Config' },

                { '<leader>tfr', function()
                  vim.cmd('edit app/root.tsx')
                end, desc = '🏠 Root Layout' },

                { '<leader>tft', function()
                  vim.cmd('edit app/routes.ts')
                end, desc = '🗺️  Routes' },

                { '<leader>tfe', function()
                  vim.cmd('edit .env')
                end, desc = '🔐 Environment' },
              })
            end
          end)
        end,
      })
    end,
  },
}
