return {
  "Exafunction/codeium.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "hrsh7th/nvim-cmp",
  },
  config = function()
    require("codeium").setup({
      -- Desactivamos la integración con nvim-cmp para que NO aparezca en el menú
      enable_cmp_source = false,
      virtual_text = {
        enabled = true,
        -- Configuramos el teclado para que se parezca a VS Code
        key_bindings = {
          accept = "<Tab>", -- Aceptar sugerencia con Tab
          next = "<M-]>",  -- Alt + ] para ver la siguiente
          prev = "<M-[>",  -- Alt + [ para la anterior
          dismiss = "<C-]>", -- Control + ] para quitar la sombra
        },
      },
    })
  end,
}
