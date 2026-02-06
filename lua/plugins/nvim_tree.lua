-- ~/.config/nvim/lua/plugins/nvim_tree.lua
return {
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            local status_ok, nvim_tree = pcall(require, "nvim-tree")
            if not status_ok then return end

            local api = require("nvim-tree.api")

            -- Variable para controlar el estado de expansión
            local is_expanded = false
            local default_width = 35
            local expanded_width = 60

            -- FUNCIÓN para alternar el ancho del árbol (usando API moderna)
            local function toggle_width()
                if is_expanded then
                    api.tree.resize({ absolute = default_width })
                    is_expanded = false
                else
                    api.tree.resize({ absolute = expanded_width })
                    is_expanded = true
                end
            end

            -- FUNCIÓN "CARCELERO": Intercepta la apertura
            local function smart_open()
                local node = api.tree.get_node_under_cursor()
                -- Si el nodo es ".." (padre) o nil, no hacemos NADA
                if not node or node.name == ".." then
                    return
                end
                -- Si es un archivo o carpeta normal, procedemos
                api.node.open.edit()
            end

            nvim_tree.setup({
                sync_root_with_cwd = false,
                respect_buf_cwd = false,
                hijack_cursor = false,
                prefer_startup_root = true,
                git = {
                    enable = true,
                    ignore = false, -- Esto hace que NO se oculten por estar en gitignore
                    show_on_dirs = true,
                    timeout = 400,
                },
                renderer = {
                    group_empty = true, -- Agrupa carpetas vacías anidadas en una sola línea
                    highlight_git = true, -- Colorea el nombre según el estado de Git
                    icons = {
                        show = {
                            git = true, -- Muestra el icono de estado (ej. un círculo gris para ignorados)
                        },
                    },
                },
                filters = {
                    dotfiles = false,
                    git_ignored = false, -- Aseguramos que el filtro esté apagado
                },
                update_focused_file = {
                    enable = true,
                    update_root = false,
                },

                actions = {
                    change_dir = {
                        enable = false,
                        restrict_above_cwd = true,
                    },
                    open_file = {
                        resize_window = false, -- CRÍTICO: No redimensionar el árbol al abrir archivos
                        quit_on_open = true, -- Cerrar el árbol al abrir un archivo
                        window_picker = {
                            enable = true,
                        },
                    },
                },

                view = {
                    width = 35,
                    side = "right",
                    relativenumber = true,
                    adaptive_size = false,     -- Desactivar redimensionamiento automático
                    preserve_window_proportions = true, -- Mantener proporciones de ventana
                },

                on_attach = function(bufnr)
                    local opts = { buffer = bufnr, noremap = true, silent = true }

                    -- 1. ¡ESTO ES LO QUE FALTABA!
                    -- Carga primero todos los atajos estándar (a, c, d, x, p, m...)
                    api.config.mappings.default_on_attach(bufnr)

                    -- 2. APLICAMOS TU "CÁRCEL" (Sobrescribiendo navegación)
                    -- Reemplazamos la apertura estándar por smart_open
                    vim.keymap.set("n", "l", smart_open, opts)
                    vim.keymap.set("n", "<CR>", smart_open, opts)
                    vim.keymap.set("n", "o", smart_open, opts)
                    vim.keymap.set("n", "<2-LeftMouse>", smart_open, opts)

                    -- Cerrar carpeta (pero nunca subir)
                    vim.keymap.set("n", "h", api.node.navigate.parent_close, opts)

                    -- 3. BLOQUEAR SALIDA (Anulamos las teclas que suben de nivel)
                    vim.keymap.set("n", "-", "<Nop>", opts) -- Netrw style
                    vim.keymap.set("n", "<BS>", "<Nop>", opts) -- Backspace
                    vim.keymap.set("n", "<C-k>", "<Nop>", opts)
                    vim.keymap.set("n", "P", "<Nop>", opts) -- Parent dir

                    -- 4. EXPANSIÓN TEMPORAL (tecla 'e' para expandir/contraer)
                    vim.keymap.set("n", "e", toggle_width, opts)

                    -- Nota: Ya no bloqueamos 'c' aquí, así que funcionará para "Copiar"
                end,
            })

            vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', { silent = true, desc = "Explorador" })
        end,
    },
}
