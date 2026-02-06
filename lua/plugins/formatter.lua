-- ~/.config/nvim/lua/plugins/formatter.lua
return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    opts = {
      formatters_by_ft = {
        -- Para Java usamos google-java-format (estándar de la industria)
        -- Si prefieres otro, puedes usar 'checkstyle'
        java = { "google-java-format" },
        -- Ya dejamos preparado para cuando pases a React
        javascript = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
      },
      -- CONFIGURACIÓN DE LA GLORIA: Formatear al guardar
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true, -- Si no hay formateador, usa el del LSP
      },
    },
  },
}
