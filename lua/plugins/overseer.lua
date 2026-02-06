-- ~/.config/nvim/lua/plugins/overseer.lua
return {
  {
    'stevearc/overseer.nvim',
    opts = {
      templates = { "builtin" },
      -- Centralizamos aquí la dirección para evitar errores de parámetros
      strategy = {
        "terminal",
        direction = "bottom",
        quit_on_exit = "never",
      },
      task_list = {
        direction = "bottom",
        min_height = 15,
      },
    },
    config = function(_, opts)
      require('overseer').setup(opts)
      local overseer = require("overseer")

      overseer.register_template({
        name = "Java Spring Boot (.env)",
        builder = function()
          local env = {}
          local f = io.open(".env", "r")
          if f then
            for line in f:lines() do
              if not line:match("^%s*#") and line:match("=") then
                local key, value = line:match("([^=]+)=(.*)")
                if key and value then
                  env[key:gsub("%s+", "")] = value:gsub("%s+", "")
                end
              end
            end
            f:close()
          end

          return {
            cmd = { "mvn" },
            args = { "spring-boot:run" },
            env = env,
            components = {
              { "on_exit_set_status" },
              { "on_complete_notify" },
              -- Quitamos parámetros de aquí para usar la estrategia global
              { "open_output", focus = true }, 
              { "unique", { replace = true } },
            },
          }
        end,
        condition = {
          callback = function()
            return vim.fn.filereadable("pom.xml") == 1
          end,
        },
      })

      local wk = require("which-key")
      wk.add({
        { "<leader>m", group = "Main / Lanzador" },
        { "<leader>mm", "<cmd>OverseerRun<cr>", desc = "Ejecutar Spring Boot" },
        { "<leader>mt", "<cmd>OverseerToggle<cr>", desc = "Panel de Tareas" },
        { "<leader>ma", "<cmd>OverseerQuickAction<cr>", desc = "Acciones (Restart/Stop)" },
        { "<leader>ms", function()
          local overseer = require("overseer")
          local tasks = overseer.list_tasks({ recent_first = true })
          if tasks[1] then
            overseer.run_action(tasks[1], "stop")
          end
        end, desc = "Detener Aplicación" },
      })
    end,
  }
}
