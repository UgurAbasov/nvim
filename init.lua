vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.g.mapleader = " "

-- Lazy.nvim setup
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Plugin list
local plugins = {
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  {
    'nvim-telescope/telescope.nvim', tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' }
  },
  {"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"},
  { 'wakatime/vim-wakatime', lazy = false },
  {'andweeb/presence.nvim'},
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    }
  },
  {'hrsh7th/nvim-cmp'},
  { 
    'L3MON4D3/LuaSnip',
    dependencies = {
      'saadparwaiz1/cmp_luasnip',
      "rafamadriz/friendly-snippets",
    }
  },
  { "neovim/nvim-lspconfig" },
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate"
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "mason.nvim" },
  },
    { "nvim-neotest/nvim-nio" },
  {"mfussenegger/nvim-dap",
    dependencies = {
      'rcarriga/nvim-dap-ui',
      'leoluz/nvim-dap-go'
    }
  },
  {"tpope/vim-fugitive"},
  { 'nvim-tree/nvim-web-devicons' },
  { 'hrsh7th/cmp-nvim-lsp' },
  {"lewis6991/gitsigns.nvim"}
}

-- Lazy.nvim setup
require("lazy").setup(plugins)



-- Telescope keymaps
local builtin = require("telescope.builtin")
vim.keymap.set('n', '<C-p>', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<C-e>', ':Neotree filesystem reveal left<CR>')
vim.keymap.set('n', '<C-n>', ':Neotree toggle<CR>')



-- Treesitter setup
local config = require("nvim-treesitter.configs")
config.setup({
  ensure_installed = { "c", "lua", "query", "javascript", "html", "go" },
  highlight = { enable = true },
  indent = { enable = true },
})


-- Completion setup
local cmp = require('cmp')
require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
  { name = 'nvim_lsp' },  
    { name = 'luasnip' },  
}, {
  { name = 'buffer' },    
    })

})


require("presence").setup()

-- Mason setup
require("mason").setup()

require('gitsigns').setup()


-- LSP capabilities
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- LSP servers setup
local lspconfig = require("lspconfig")

lspconfig.ts_ls.setup{
  capabilities = capabilities
}

lspconfig.clangd.setup{
  capabilities = capabilities
}

lspconfig.gopls.setup{
  capabilities = capabilities
}

lspconfig.lua_ls.setup {
  capabilities = capabilities,
  root_dir = require('lspconfig.util').root_pattern(
    '.stylua.toml'
  ),
}

local dap = require("dap")
local dapui = require("dapui")

require('dapui').setup()
require('dap-go').setup()

dap.listeners.before.attach.dapui_config = function()
  dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
  dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
  dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
  dapui.close()
end


vim.keymap.set('n', '<Leader>dt', dap.toggle_breakpoint, {})
vim.keymap.set('n', "<Leader>dc", dap.continue, {})

vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        if vim.fn.argc() == 0 then
            require('telescope.builtin').find_files()
        end
    end
})


-- Catppuccin setup
require("catppuccin").setup({
  flavour = "frappe",
})

vim.cmd.colorscheme "catppuccin"
