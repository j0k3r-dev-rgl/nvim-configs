return {
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.set_formatting_op"] = true,
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true, -- Barra de comandos al centro
        long_message_to_split = true,
      },
    },
  }
}
