-- Set <space> as the leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Basic editor setup
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.smartindent = true

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- Make line numbers default
vim.opt.number = true

-- Relative line numbers
-- vim.opt.relativenumber = true

-- Enable mouse mode
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and neovim
vim.schedule(function()
	vim.opt.clipboard = 'unnamedplus'
end)

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case insensitive searching
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true

-- Show which line your cursor is on
vim.opt.cursorline = true

-- [[ BASIC KEYMAPS ]]
--
-- Clear highlights on seach when pressing <ESC>
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')


-- Lazy
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Set up Lazy.nvim as the plugin manager
require("lazy").setup({
  -- Install essential plugins
  { "neovim/nvim-lspconfig" },                  -- LSP config for Neovim
  { "williamboman/mason.nvim" },                -- Mason plugin for easy LSP/installer management
  { "williamboman/mason-lspconfig.nvim" },      -- Mason LSP config
  { "nvim-lua/plenary.nvim" },                  -- Plenary for various utilities
  { "jose-elias-alvarez/null-ls.nvim" },        -- For formatting and other actions
})

-- Mason setup to install Go tools like gopls and gofmt
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "gopls" },
  automatic_installation = true,
})

-- LSP setup for Go
local lspconfig = require("lspconfig")

-- Enable gopls for Go language
lspconfig.gopls.setup({
  on_attach = function(client, bufnr)
    -- Enable formatting on save
    vim.api.nvim_buf_set_option(bufnr, "formatexpr", "v:lua.vim.lsp.formatexpr()")
    vim.cmd([[autocmd BufWritePre <buffer> lua vim.lsp.buf.format()]])
  end,
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
    }
  }
})

-- Null-ls setup for formatting with gofmt
local null_ls = require("null-ls")
null_ls.setup({
  sources = {
    null_ls.builtins.formatting.gofmt,
  },
})

-- Keybindings
vim.api.nvim_set_keymap('n', '<leader>gf', ':lua vim.lsp.buf.format()<CR>', { noremap = true, silent = true })

