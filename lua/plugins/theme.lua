-- ~/.config/nvim/lua/plugins/theme.lua
return {
    {
        "EdenEast/nightfox.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require("nightfox").setup({
                options = {
                    -- Estilo Carbonfox es el que buscas (negro carbón)
                    style = "carbonfox",
                    transparent = false, -- Cambia a true si usas transparencia en tu terminal
                    terminal_colors = true,
                    styles = {
                        comments = "italic",
                        keywords = "bold",
                        types = "italic,bold",
                    },
                    inverse = {
                        match_paren = true, -- Resalta el paréntesis de cierre
                    },
                    -- Aquí forzamos el negro absoluto en el fondo
                    palette = {
                        carbonfox = {
                            bg1 = "#000000", -- Fondo principal negro puro
                            bg0 = "#000000", -- Fondo de paneles laterales
                            bg3 = "#161616", -- Color de la línea de estado o líneas sutiles
                            sel0 = "#2a2a2a", -- Color de selección (que no brille demasiado)
                        },
                    },
                    specs = {
                        carbonfox = {
                            syntax = {
                                keyword = "#78a9ff", -- Un azul vibrante para palabras clave (if, return)
                            },
                        },
                    },
                },
            })

            -- Aplicar el tema
            vim.cmd("colorscheme carbonfox")

            -- Ajustes extras de contraste para Java y React (opcional pero recomendado)
            vim.api.nvim_set_hl(0, "@lsp.type.interface.java", { fg = "#ee5396", italic = true })
            vim.api.nvim_set_hl(0, "@lsp.type.annotation.java", { fg = "#be95ff" })
            vim.api.nvim_set_hl(0, "@tag.tsx", { fg = "#3ddbd9" }) -- Etiquetas de React/JSX más vivas
            vim.api.nvim_set_hl(0, "@tag.attribute.tsx", { fg = "#ff7eb6", italic = true })
        end,
    },
}
