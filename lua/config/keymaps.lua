-- Guardar con Ctrl + s (Como en la mayoría de editores)
vim.keymap.set({ 'n', 'i', 'v' }, '<C-s>', '<cmd>write<cr>', { desc = "Guardar archivo", silent = true })

-- Scroll rápido del 25% de la pantalla
vim.keymap.set('n', '<A-j>', '<C-d>', { desc = "Scroll down 25%", silent = true })
vim.keymap.set('n', '<A-k>', '<C-u>', { desc = "Scroll up 25%", silent = true })

-- Guardar o Espacio + w (Usando tu tecla Leader)
local wk = require("which-key")
wk.add({
  { "<leader>w", "<cmd>write<cr>", desc = "Guardar Archivo" },
})
