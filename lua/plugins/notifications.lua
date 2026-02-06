-- ~/.config/nvim/lua/plugins/notifications.lua
return {
  {
    "rcarriga/nvim-notify",
    config = function()
      local notify = require("notify")
      notify.setup({
        stages = "fade", -- Animación suave
        timeout = 3000,  -- 3 segundos de visibilidad
        background_colour = "#000000", -- Se adapta a Tokyo Night
      })
      -- Esto hace que Neovim use este plugin para todos los mensajes
      vim.notify = notify
    end,
  },
}
