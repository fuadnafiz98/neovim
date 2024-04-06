--- Lazy requires mapleader to be set before it is loadedG
local vim = vim
vim.g.mapleader = " "
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", -- latest stable release lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

--- Plugins
require("lazy").setup({
  { "ellisonleao/gruvbox.nvim" },

  { "williamboman/mason.nvim" },
  { "williamboman/mason-lspconfig.nvim" },

  { "neovim/nvim-lspconfig" },
  { "nvim-treesitter/nvim-treesitter",  build = ":TSUpdate" },

  { "hrsh7th/nvim-cmp", },
  { 'saadparwaiz1/cmp_luasnip' },
  { 'L3MON4D3/LuaSnip' },
  { "hrsh7th/cmp-buffer", },
  { "hrsh7th/cmp-path", },
  { "hrsh7th/cmp-nvim-lsp" },
  { "nvimtools/none-ls.nvim" },

  { "junegunn/fzf" },
  { "junegunn/fzf.vim" },
  {
    "ray-x/go.nvim",
    dependencies = { -- optional packages
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("go").setup()
    end,
    event = { "CmdlineEnter" },
    ft = { "go", 'gomod' },
    build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
  }
})

--- Basic
vim.opt.background = "dark"
vim.opt.encoding = "UTF-8"
vim.opt.compatible = false
vim.opt.errorbells = false
vim.opt.exrc = true
vim.opt.expandtab = true
vim.opt.mouse = "a"
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.errorbells = false
vim.opt.signcolumn = "no"
vim.opt.smartindent = true
vim.opt.smarttab = true
vim.opt.autoindent = true
vim.opt.cindent = true
vim.opt.showcmd = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.autowrite = true
vim.opt.autoread = true
vim.opt.wrap = true
vim.opt.incsearch = true
vim.opt.swapfile = false
vim.opt.smartcase = true
vim.opt.clipboard = "unnamed"
vim.cmd("syntax on")
vim.cmd("syntax enable")
vim.cmd("filetype plugin on")
vim.opt.hidden = true
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.cmdheight = 1
vim.opt.updatetime = 300
vim.opt.shortmess:append("c")
vim.opt.cmdheight = 1
vim.opt.ttyfast = true
vim.opt.wildmenu = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

--- Colorscheme
require("gruvbox").setup({
  terminal_colors = true,
  undercurl = true,
  underline = true,
  bold = true,
  italic = {
    strings = true,
    emphasis = true,
    comments = true,
    operators = false,
    folds = true,
  },
  strikethrough = true,
  invert_selection = false,
  invert_signs = false,
  invert_tabline = false,
  invert_intend_guides = false,
  inverse = true,
  contrast = "hard",
  palette_overrides = {},
  overrides = {},
  dim_inactive = false,
  transparent_mode = false,
})
vim.cmd("colorscheme gruvbox")

--- Keymaps
vim.api.nvim_set_keymap("n", "<A-a>", "m<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-\\>", "<C-^>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "dd", '"_dd', { noremap = true })
vim.api.nvim_set_keymap("i", "<C-\\>", "<ESC> <C-^>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("x", "<", "<gv", { noremap = true, silent = true })
vim.api.nvim_set_keymap("x", ">", ">gv", { noremap = true, silent = true })
vim.api.nvim_set_keymap("x", "<leader>p", '"_dP', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-c>', ':nohl<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-k>',
  '<cmd>lua vim.diagnostic.open_float({ scope = "cursor" })<CR>',
  { noremap = true, silent = true })

vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.format()]]

--- FZF
vim.api.nvim_set_keymap("n", "<C-p>", ":GFiles --cached --others --exclude-standard<CR>",
  { noremap = true, silent = true })
vim.g.fzf_layout = { down = "~20%" }
vim.g.fzf_preview_window = { "hidden" }
vim.g.fzf_colors = {
  fg = { "fg", "Normal" },
  bg = { "bg", "Normal" },
  hl = { "fg", "Comment" },
  ["fg+"] = { "fg", "CursorLine", "CursorColumn", "Normal" },
  ["bg+"] = { "bg", "CursorLine", "CursorColumn" },
  ["hl+"] = { "fg", "Statement" },
  info = { "fg", "PreProc" },
  border = { "fg", "Ignore" },
  prompt = { "fg", "Conditional" },
  pointer = { "fg", "Exception" },
  marker = { "fg", "Keyword" },
  spinner = { "fg", "Label" },
  header = { "fg", "Comment" },
}

--- LSPs
local lspconfig = require("lspconfig")
local lsp_defaults = lspconfig.util.default_config

lsp_defaults.capabilities =
    vim.tbl_deep_extend("force", lsp_defaults.capabilities, require("cmp_nvim_lsp").default_capabilities())

vim.api.nvim_create_autocmd("LspAttach", {
  desc = "LSP actions",
  callback = function(event)
    local opts = { buffer = event.buf }

    vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
    vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
    vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
    vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
    vim.keymap.set("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
    vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
    vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
    vim.keymap.set("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
    vim.keymap.set({ "n", "x" }, "<F3>", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", opts)
    vim.keymap.set("n", "<F4>", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)

    vim.keymap.set("n", "gl", "<cmd>lua vim.diagnostic.open_float()<cr>", opts)
    vim.keymap.set("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<cr>", opts)
    vim.keymap.set("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<cr>", opts)
  end,
})

--- GOLANG
local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    require('go.format').goimport()
  end,
  group = format_sync_grp,
})
require('go').setup()

local default_setup = function(server)
  lspconfig[server].setup({})
end

require("mason").setup({})
require("mason-lspconfig").setup({
  ensure_installed = {},
  handlers = { default_setup },
})

local cmp = require 'cmp'
local luasnip = require 'luasnip'
luasnip.config.setup {}

local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end


cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-k>'] = cmp.mapping.scroll_docs(-4),
    ['<C-j>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete {},
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = "buffer" },
    { name = "path" }
  },
  experimental = {
    ghost_text = true,
  },
}

--- golang `templ` support
vim.filetype.add({
  extension = {
    templ = "templ",
  },
})

--- Format current buffer using LSP.
vim.api.nvim_create_autocmd(
  {
    -- 'BufWritePre' event triggers just before a buffer is written to file.
    "BufWritePre"
  },
  {
    pattern = { "*.templ" },
    callback = function()
      -- Format the current buffer using Neovim's built-in LSP (Language Server Protocol).
      vim.lsp.buf.format()
    end,
  }
)

require("lspconfig").tailwindcss.setup({
  filetypes = {
    'templ'
    -- include any other filetypes where you need tailwindcss
  },
  init_options = {
    userLanguages = {
      templ = "html"
    }
  }
})


local on_attach = function(client, bufnr)
  if client.name == 'ruff_lsp' then
    -- Disable hover in favor of Pyright
    client.server_capabilities.hoverProvider = false
  end
end

-- Configure `ruff-lsp`.
-- See: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#ruff_lsp
-- For the default config, along with instructions on how to customize the settings
require('lspconfig').ruff_lsp.setup {
  on_attach = on_attach,
  init_options = {
    settings = {
      -- Any extra CLI arguments for `ruff` go here.
      args = {},
    }
  }
}

require('lspconfig').pyright.setup {
  settings = {
    pyright = {
      -- Using Ruff's import organizer
      disableOrganizeImports = true,
    },
    python = {
      analysis = {
        -- Ignore all files for analysis to exclusively use Ruff for linting
        ignore = { '*' },
      },
    },
  },
}

---
--local null_ls = require("null-ls")
--null_ls.setup({
-- sources = {
--  null_ls.builtins.diagnostics.mypy,
--},
--})
