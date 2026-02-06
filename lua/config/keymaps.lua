-- Guardar con Ctrl + s (Como en la mayoría de editores)
vim.keymap.set({ 'n', 'i', 'v' }, '<C-s>', '<cmd>write<cr>', { desc = "Guardar archivo", silent = true })


-- Guardar o Espacio + w (Usando tu tecla Leader)
local wk = require("which-key")
wk.add({
  { "<leader>w", "<cmd>write<cr>", desc = "Guardar Archivo" },
})
