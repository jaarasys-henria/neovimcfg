--[[ REQUIREMENTS
       nvim => 0.9.0 (lazyvim)
       terminal with true color support, alacritty (lazyvim)
       git => 2.19.0 (lazyvim, partial clones support)
       recommended: ripgrep (Telescope)
       some kind of nerd font installed and enabled in terminal
         https://www.nerdfonts.com/
         JetBrainsMono is quite decent

     REFERENCE MATERIALS
       typecraft: From 0 to IDE in NEOVIM: https://www.youtube.com/watch?v=zHTeCSVAFNY
--]]

--[[ INSTALL AND CONFIGURE LAZYVIM
       http://lazyvim.org
       https://github.com/folke/lazy.nvim
--]]
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim",
		"--branch=stable", --latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath) --add to runtimepath

-- LAZYVIM PLUGINS
local lazyplugins = {
	{
		"catppuccin/nvim", --https://github.com/catppuccin/nvim
		name = "catppuccin",
		priority = 1000,
	},

	{
		"goolord/alpha-nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
	},

	{ "hrsh7th/nvim-cmp" },

	{ "neovim/nvim-lspconfig" },

	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},

	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
	},

	{
		"nvimtools/none-ls.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
	},

	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.5",
		dependencies = { "nvim-lua/plenary.nvim" },
	},

	{
		"nvim-telescope/telescope-ui-select.nvim",
	},

	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
	},

	{ "williamboman/mason.nvim" },
	{ "williamboman/mason-lspconfig.nvim" },
}

-- INIT LAZYVIM
local lazyopts = {}
require("lazy").setup(lazyplugins, lazyopts)

-- INIT LUALINE
require("lualine").setup()

-- INIT CATPPUCCIN
require("catppuccin").setup()

-- INIT MASON AND MASON-LSPCONFIG
require("mason").setup({})

-- https://github.com/williamboman/mason-lspconfig.nvim?tab=readme-ov-file#available-lsp-servers
local lsps = {
	"lua_ls",
	"tsserver",
}

require("mason-lspconfig").setup({
	ensure_installed = lsps,
})

-- INIT NEOVIM-LSPCONFIG WITH LSPS
local lspconfig = require("lspconfig")
lspconfig.lua_ls.setup({
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" }, -- don't nag about the global name 'vim'
			},
		},
	},
})
lspconfig.tsserver.setup({})

-- INIT TREESITTER-NVIM
local treesitter_langs = {
	"bash",
	"c",
	"csv",
	"html",
	"ini",
	"javascript",
	"json",
	"lua",
	"markdown",
	"python",
	"rust",
	"toml",
	"vimdoc",
	"yaml",
}

require("nvim-treesitter.configs").setup({
	ensure_installed = treesitter_langs,
	highlight = { enable = true },
	indent = { enable = true },
})

-- INIT TELESCOPE AND EXTENSIONS
local telescope = require("telescope")
telescope.setup({
	extensions = {
		["ui-select"] = { require("telescope.themes").get_dropdown({}) },
	},
})
telescope.load_extension("ui-select")

-- INIT NONE-LS/NULL-LS
local null_ls = require("null-ls")
null_ls.setup({
	sources = {
		null_ls.builtins.formatting.stylua,
	},
})

-- INIT ALPHA-NVIM
local alpha = require("alpha")
local dash = require("alpha.themes.startify")
dash.section.header.val = {
	[[                                                                       ]],
	[[                                                                       ]],
	[[                                                                       ]],
	[[                                                                       ]],
	[[                                                                     ]],
	[[       ████ ██████           █████      ██                     ]],
	[[      ███████████             █████                             ]],
	[[      █████████ ███████████████████ ███   ███████████   ]],
	[[     █████████  ███    █████████████ █████ ██████████████   ]],
	[[    █████████ ██████████ █████████ █████ █████ ████ █████   ]],
	[[  ███████████ ███    ███ █████████ █████ █████ ████ █████  ]],
	[[ ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
	[[                                                                       ]],
	[[                                                                       ]],
	[[                                                                       ]],
}

alpha.setup(dash.opts)

-- KEYBOARD SHORTCUTS: TELESCOPE
local telescope_builtin = require("telescope.builtin")
vim.keymap.set("n", "<C-p>", telescope_builtin.find_files, {})

-- KEYBOARD SHORTCUTS: NEOTREE
vim.keymap.set("n", "<A-e>", ":Neotree action=focus source=filesystem position=left toggle=true<CR>", {})

-- KEYBOARD SHORTCUTS: LSP, LINT, FORMATTING
vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
vim.keymap.set("n", "gf", vim.lsp.buf.format, {})
vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, {})

-- KEYBAORD SHORTCUTS: OTHER
vim.keymap.set("n", "<A-k>", "<Cmd>move -2<CR>", {})
vim.keymap.set("n", "<A-j>", "<Cmd>move +1<CR>", {})

-- PREFS: INDENTING
vim.opt.expandtab = true --insert spaces instead of tab characters
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 2 --don't try to "simulate" different tab widths by adding spaces
vim.opt.tabstop = 4 --maximum width of actual tab character

-- PREFS: OTHER
vim.opt.colorcolumn = { 89 }
vim.cmd.colorscheme("catppuccin-frappe")
vim.opt.number = true --line numbers visible
vim.opt.relativenumber = true
