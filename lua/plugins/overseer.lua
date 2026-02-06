-- ~/.config/nvim/lua/plugins/overseer.lua
--
-- Centro de control con menús interactivos para proyectos Java y JavaScript

--- Detecta gestor de paquetes JS/TS (bun > npm > pnpm > yarn)
local function detect_package_manager()
  if vim.fn.executable('bun') == 1 then return 'bun'
  elseif vim.fn.executable('npm') == 1 then return 'npm'
  elseif vim.fn.executable('pnpm') == 1 then return 'pnpm'
  elseif vim.fn.executable('yarn') == 1 then return 'yarn'
  end
  return nil
end

--- Carga variables .env
local function load_env_file(filepath)
  local env = {}
  local f = io.open(filepath, "r")
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
  return env
end

--- Detecta tipo de proyecto
local function detect_project_type()
  if vim.fn.filereadable("pom.xml") == 1 then
    return "maven"
  elseif vim.fn.filereadable("package.json") == 1 and
         (vim.fn.filereadable("react-router.config.ts") == 1 or vim.fn.isdirectory("app") == 1) then
    return "react-router"
  elseif vim.fn.filereadable("package.json") == 1 then
    return "nodejs"
  end
  return nil
end

--- Ejecuta tarea de overseer
local function run_task(cmd, args, env_file)
  local overseer = require("overseer")
  overseer.run_task({
    cmd = cmd,
    args = args,
    env = env_file and load_env_file(env_file) or {},
    components = {
      { "on_exit_set_status" },
      { "on_complete_notify" },
      { "open_output", focus = true },
      { "unique", { replace = true } },
    },
  })
end

--- Menú principal inteligente según tipo de proyecto
local function show_main_menu()
  local project_type = detect_project_type()

  if project_type == "maven" then
    show_maven_menu()
  elseif project_type == "react-router" or project_type == "nodejs" then
    show_react_menu()
  else
    vim.notify("⚠️  No se detectó proyecto Maven o React Router", vim.log.levels.WARN)
  end
end

--- Menú de Maven
function show_maven_menu()
  local options = {
    "🚀 Spring Boot: Run (mvn spring-boot:run)",
    "🧹 Clean (mvn clean)",
    "📦 Install (mvn clean install -DskipTests)",
    "📦 Package (mvn clean package -DskipTests)",
    "🧪 Test (mvn test)",
    "🔨 Compile (mvn compile)",
    "🔍 Verify (mvn verify -DskipTests)",
  }

  vim.ui.select(options, {
    prompt = "Maven - Selecciona tarea:",
  }, function(choice)
    if not choice then return end

    if choice:match("Spring Boot: Run") then
      run_task("mvn", { "spring-boot:run" }, ".env")
    elseif choice:match("Clean") and not choice:match("Install") and not choice:match("Package") then
      run_task("mvn", { "clean" })
    elseif choice:match("Install") then
      run_task("mvn", { "clean", "install", "-DskipTests" })
    elseif choice:match("Package") then
      run_task("mvn", { "clean", "package", "-DskipTests" })
    elseif choice:match("Test") then
      run_task("mvn", { "test" })
    elseif choice:match("Compile") then
      run_task("mvn", { "compile" })
    elseif choice:match("Verify") then
      run_task("mvn", { "verify", "-DskipTests" })
    end
  end)
end

--- Menú de React Router 7
function show_react_menu()
  local pm = detect_package_manager()

  if not pm then
    vim.notify(
      "⚠️  No se encontró gestor de paquetes (bun/npm/pnpm/yarn)",
      vim.log.levels.ERROR
    )
    return
  end

  local options = {
    "🚀 Dev Server (" .. pm .. " run dev)",
    "📦 Build (" .. pm .. " run build)",
    "👁️  Preview Build (" .. pm .. " run start)",
    "🔍 Type Check (" .. pm .. " run typecheck)",
    "🧹 Clean node_modules (rm -rf node_modules)",
    "📥 Install Dependencies (" .. pm .. " install)",
  }

  vim.ui.select(options, {
    prompt = "React Router 7 - Selecciona tarea:",
  }, function(choice)
    if not choice then return end

    local args = pm == 'npm' and { 'run' } or { 'run' }

    if choice:match("Dev Server") then
      table.insert(args, 'dev')
      run_task(pm, args, ".env")
    elseif choice:match("^📦 Build") then
      table.insert(args, 'build')
      run_task(pm, args, ".env")
    elseif choice:match("Preview Build") then
      table.insert(args, 'start')
      run_task(pm, args, ".env")
    elseif choice:match("Type Check") then
      table.insert(args, 'typecheck')
      run_task(pm, args)
    elseif choice:match("Clean node_modules") then
      run_task("rm", { "-rf", "node_modules" })
    elseif choice:match("Install Dependencies") then
      if pm == 'npm' then
        run_task(pm, { 'install' })
      else
        run_task(pm, { 'install' })
      end
    end
  end)
end

return {
  {
    'stevearc/overseer.nvim',
    opts = {
      templates = { "builtin" },
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

      -- Keybindings
      local wk = require("which-key")
      wk.add({
        { "<leader>m", group = "Main / Lanzador" },

        -- Menú principal inteligente
        { "<leader>mm", show_main_menu, desc = "📋 Menú Principal" },

        -- Atajos directos a menús específicos
        { "<leader>mj", show_maven_menu, desc = "☕ Menú Maven" },
        { "<leader>mr", show_react_menu, desc = "⚛️  Menú React Router" },

        -- Gestión de tareas
        { "<leader>mt", "<cmd>OverseerToggle<cr>", desc = "📊 Panel de Tareas" },
        { "<leader>ma", "<cmd>OverseerQuickAction<cr>", desc = "⚡ Acciones Rápidas" },

        -- Detener tarea activa
        { "<leader>ms", function()
          local overseer = require("overseer")
          local tasks = overseer.list_tasks({ recent_first = true })
          if tasks[1] then
            overseer.run_action(tasks[1], "stop")
          else
            vim.notify("No hay tareas activas", vim.log.levels.WARN)
          end
        end, desc = "🛑 Detener Tarea Activa" },

        -- Limpiar tareas completadas
        { "<leader>mc", function()
          local overseer = require("overseer")
          local tasks = overseer.list_tasks()
          for _, task in ipairs(tasks) do
            if task.status == "SUCCESS" or task.status == "FAILURE" then
              task:dispose()
            end
          end
          vim.notify("Tareas completadas limpiadas", vim.log.levels.INFO)
        end, desc = "🧹 Limpiar Tareas" },
      })
    end,
  }
}
