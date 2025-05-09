-- Set up basic options (optional)
vim.o.number = true

-- Bootstrap lazy.nvim if not installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Setup plugins
require("lazy").setup({
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- optional, for file icons
      "MunifTanjim/nui.nvim",
    },
  },
  {
    "tanvirtin/monokai.nvim",
    lazy = false, -- load immediately
    priority = 1000, -- load before other plugins
  }, 
  {
  'neovim/nvim-lspconfig',
  config = function()
    require('lspconfig').ts_ls.setup({})
  end,
  },
  {
  "nvimtools/none-ls.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local null_ls = require("null-ls")
    null_ls.setup({
      sources = {
        -- Biome as formatter and/or linter
        null_ls.builtins.formatting.biome,
        -- null_ls.builtins.diagnostics.biome, -- Uncomment if you want Biome as linter

        -- ESLint as linter (diagnostics)
        null_ls.builtins.diagnostics.eslint_d, -- Fast, recommended
        -- Or use `eslint` (slower):
        -- null_ls.builtins.diagnostics.eslint,

        -- Optionally, ESLint as code actions (fixes)
        null_ls.builtins.code_actions.eslint_d,
        -- Or use `eslint`:
        -- null_ls.builtins.code_actions.eslint,
      },
    })
  end,
 }
})

vim.o.relativenumber = true

-- Set the colorscheme
vim.cmd.colorscheme("monokai")

-- Set leader command 
vim.g.mapleader = " "        -- Space as leader
vim.g.maplocalleader = " "   -- Also sets local leader (optional)

-- Create a command to toggle Neo-tree
vim.api.nvim_create_user_command("NeoTreeToggle", function()
  vim.cmd("Neotree toggle")
end, {})

-- Optional keybinding to toggle Neo-tree with <leader>e
vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>", { desc = "Toggle Neo-tree" })
vim.keymap.set("n", "<leader><leader>", ":Telescope find_files<CR>", { desc = "Telescope Find Files" })
vim.keymap.set("n", "<leader>/", ":Telescope live_grep<CR>", { desc = "Telescope Live Grep" })
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function()
        vim.lsp.buf.format({
            filter = function(client) return client.name == "null-ls" end, -- Use only null-ls
            async = false,
        })
    end,
})
vim.keymap.set('n', '<leader>cd', vim.diagnostic.open_float, { noremap = true, silent = true, desc = "Show diagnostic under cursor" })
