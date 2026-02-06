-- ~/.config/nvim/init.lua

-- Definir la tecla líder (Espacio es la más cómoda)
vim.g.mapleader = " "
vim.g.maplocalleader = " "


-- Instalar Lazy.nvim si no existe
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Cargar plugins
require("lazy").setup("plugins")
require("config.keymaps")

vim.opt.number = true          -- Mostrar números de línea
vim.opt.relativenumber = true  -- Números relativos para moverte rápido
vim.opt.shiftwidth = 4         -- Tabulación de 4 espacios (estándar Java)
vim.opt.tabstop = 4
vim.opt.expandtab = true       -- Convertir tabs en espacios
vim.opt.termguicolors = true   -- Colores reales en la terminal

vim.opt.signcolumn = "yes" -- dejamos fija la bombilla para que no moleste.

