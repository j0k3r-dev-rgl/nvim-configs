-- ~/.config/nvim/lua/plugins/markdown.lua

return {
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons',
    },
    ft = { 'markdown' },  -- Solo cargar en archivos markdown
    opts = {
      -- Configuración básica para renderizar markdown
      enabled = true,
      render_modes = { 'n', 'c' },  -- Normal y command mode
      anti_conceal = {
        enabled = true,
      },
      heading = {
        enabled = true,
        icons = { '󰲡 ', '󰲣 ', '󰲥 ', '󰲧 ', '󰲩 ', '󰲫 ' },
        backgrounds = {
          'RenderMarkdownH1Bg',
          'RenderMarkdownH2Bg',
          'RenderMarkdownH3Bg',
          'RenderMarkdownH4Bg',
          'RenderMarkdownH5Bg',
          'RenderMarkdownH6Bg',
        },
      },
      code = {
        enabled = true,
        sign = false,
        width = 'block',
        left_pad = 2,
      },
      bullet = {
        enabled = true,
        icons = { '●', '○', '◆', '◇' },
      },
    },
    config = function(_, opts)
      require('render-markdown').setup(opts)
    end,
  },
}
