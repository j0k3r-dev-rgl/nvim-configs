return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master", -- Usar versión legacy estable
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        -- Lista de parsers a instalar automáticamente
        ensure_installed = {
          "lua",
          "vim",
          "vimdoc",
          "java",
          "javascript",
          "typescript",
          "json",
          "yaml",
          "markdown",
          "markdown_inline",
          "bash",
          "html",
          "css",
        },

        -- Instalar parsers de forma sincrónica (solo aplicado a `ensure_installed`)
        sync_install = false,

        -- Instalar automáticamente parsers faltantes cuando se abre un archivo
        auto_install = true,

        -- Resaltado de sintaxis
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },

        -- Indentación mejorada
        indent = {
          enable = true,
        },
      })
    end,
  },
}
