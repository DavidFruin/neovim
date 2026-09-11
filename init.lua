--[[

Hey everyone this is the NeoVim config that I (David Fruin) use as my daily driver txt editor. Try it out if you would like!

===============================
Keymap Reference
===============================

Global Keymaps (Basic Neovim actions) 

<leader> = space

<leader>il (navigate to this file (init.lua) from anywhere)

<Esc> (Clear search highlighting)
<leader>q (Quit current buffer)
<C-h> (Move to left window)
<C-l> (Move to right window)
<C-j> (Move to down window)
<C-k> (Move to up window)
<leader>v (Vertical split new window)
<leader>n (Horizontal split new windo)
<leader>sc (Switch colorscheme in a list of 3 themes)

Oil (File explorer) 
<leader>p (Toggle hidden files in Oil)
<leader>e (Toggle Oil file explorer)

Twilight (Focus mode for code) 
<leader>l (Toggle Twilight

Conform (Code formatter) 
<leader>cf (Format buffer)

Telescope (Fuzzy finder) 
<leader>ff (Find files)
<leader>fg (Live grep)
<leader>fb (Switch buffers)
<leader>fh (Help tags)
<leader>fc (Commands)
<leader>fk (Keymaps)

Harpoon (File bookmarks) 
<leader>a (Add file)
<leader>m (Menu)
<leader>hn (Next file)
<leader>hp (Previous file)
<leader>h1 (Harpoon file 1)
<leader>h2 (Harpoon file 2)
<leader>h3 (Harpoon file 3)
<leader>h4 (Harpoon file 4)

LSP (Code intelligence, buffer-local on attach) 
grn (Rename symbol)
gra (Code action)
grr (LSP references)
grd (LSP definitions)
gri (LSP implementations)
grt (LSP type definitions)
gO (Document symbols)
gW (Workspace symbols)
<leader>th (Toggle inlay hints)

--]]

-- ===============================
--   Bootstrap Lazy.nvim
-- ===============================

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
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

-- ===============================
--   Neovim Config
-- ===============================

-- Leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true
vim.g.current_scheme = 1

-- ===============================
--   Basic Options
-- ===============================

vim.o.number = true
vim.o.relativenumber = true
vim.o.mouse = "a"
vim.o.showmode = false
vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.signcolumn = "yes"
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.o.inccommand = "split"
vim.o.cursorline = true
vim.o.cursorcolumn = true
vim.o.scrolloff = 10
vim.o.confirm = true

-- Clipboard async setup
vim.schedule(function()
	vim.o.clipboard = "unnamedplus"
end)

-- ===============================
--   Global Keymaps
-- ===============================
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("n", ";", ":", { desc = "Command mode" })
vim.keymap.set("n", "<leader>q", "<cmd>bd<CR>", { desc = "Quit current buffer" })

-- Window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move left window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move right window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move down window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move up window" })

-- Splits
vim.keymap.set("n", "<leader>v", "<cmd>vnew<CR>", { desc = "Vertical split" })
vim.keymap.set("n", "<leader>n", "<cmd>new<CR>", { desc = "Horizontal split" })

-- Nav to this file from anywhere
vim.keymap.set("n", "<leader>il", ":e ~/.config/nvim/init.lua<CR>", { desc = "Edit Neovim config (il = Init.Lua)" })

-- ===============================
--   Lazy.nvim Setup
-- ===============================
require("lazy").setup({
	-- Core
	{ "nvim-lua/plenary.nvim" },
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				-- Load Neovim runtime for better API support
				-- (Add more if you develop plugins, e.g., "${3rd}/luv/library" for vim.uv)
			},
		},
	},

	-- File explorer
	{ "stevearc/oil.nvim" },
	{ "nvim-tree/nvim-web-devicons" },

	-- UI / Utilities
	{ "j-hui/fidget.nvim" },
	{ "folke/twilight.nvim" },
	{ "folke/which-key.nvim" },

	-- Completion
	{
		"saghen/blink.cmp",
		opts = {
			sources = {
				default = { "lazydev", "lsp", "path", "snippets", "buffer" },
				providers = {
					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink",
						score_offset = 100, -- Prioritize lazydev completions
					},
				},
			},
		},
	},

	-- LSP / Mason
	{ "williamboman/mason.nvim" },
	{ "williamboman/mason-lspconfig.nvim" },
	{ "WhoIsSethDaniel/mason-tool-installer.nvim" },
	{ "neovim/nvim-lspconfig" },

	-- Formatting
	{ "stevearc/conform.nvim" },

	-- Telescope
	{ "nvim-telescope/telescope.nvim" },
	{ "nvim-telescope/telescope-ui-select.nvim" },

	-- Harpoon v1
	{ "ThePrimeagen/harpoon" },

	-- Colorschemes
	{ "rose-pine/neovim" },
	{ "folke/tokyonight.nvim" },
	{ "EdenEast/nightfox.nvim" },
})

-- ===============================
--   Colorscheme Management
-- ===============================
local schemes = { "nightfox", "rose-pine", "tokyonight" }
vim.cmd.colorscheme(schemes[vim.g.current_scheme])

_G.switch_scheme = function()
	vim.g.current_scheme = (vim.g.current_scheme % #schemes) + 1
	vim.cmd.colorscheme(schemes[vim.g.current_scheme])
end
vim.keymap.set("n", "<leader>sc", _G.switch_scheme, { desc = "Switch colorscheme" })

-- ===============================
--   Plugin Configurations
-- ===============================

-- which-key
pcall(function()
	local wk = require("which-key")
	wk.setup({
		win = {
			border = "rounded",
			padding = { 1, 2 },
		},
		layout = { spacing = 4 },
	})
end)

-- Oil setup (toggle + hidden files)
local ok_oil, oil = pcall(require, "oil")
if ok_oil then
	oil.setup({
		view_options = { show_hidden = false },
	})

	vim.keymap.set("n", "<leader>p", function()
		if vim.bo.filetype ~= "oil" then
			vim.notify("Not in an Oil buffer", vim.log.levels.WARN)
			return
		end
		oil.toggle_hidden()
	end, { desc = "Toggle hidden files in Oil" })

	vim.keymap.set("n", "<leader>e", function()
		if vim.bo.filetype == "oil" then
			if vim.fn.winnr("$") == 1 then
				local last_buf = vim.fn.bufnr("#")
				if last_buf > 0 and vim.api.nvim_buf_is_valid(last_buf) then
					vim.cmd("buffer " .. last_buf)
				else
					vim.cmd("enew")
				end
			else
				vim.cmd("close")
			end
		else
			oil.open()
		end
	end, { desc = "Toggle Oil file explorer" })
end

-- Twilight
pcall(function()
	require("twilight").setup()
end)
vim.keymap.set("n", "<leader>l", function()
	local ok, twilight = pcall(require, "twilight")
	if ok then
		twilight.toggle()
	end
end, { desc = "Toggle Twilight" })

-- Conform formatter
pcall(function()
	require("conform").setup({
		formatters_by_ft = { lua = { "stylua" } },
		format_on_save = { timeout_ms = 500, lsp_format = "fallback" },
	})
end)
vim.keymap.set({ "n", "v" }, "<leader>cf", function()
	local ok, conform = pcall(require, "conform")
	if ok then
		conform.format({ async = true, lsp_format = "fallback" })
	end
end, { desc = "Format buffer" })

-- Fidget
pcall(function()
	require("fidget").setup()
end)

-- Telescope
pcall(function()
	require("telescope").setup({
		defaults = { file_ignore_patterns = { "node_modules" } },
	})
	require("telescope").load_extension("ui-select")
end)

pcall(function()
	local builtin = require("telescope.builtin")
	vim.keymap.set("n", "<leader>ff", function()
		builtin.find_files({ hidden = true })
	end, { desc = "Telescope: Find files" })
	vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope: Live grep" })
	vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope: Switch buffers" })
	vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope: Help tags" })
	vim.keymap.set("n", "<leader>fc", function()
		builtin.find_files({
			cwd = vim.fn.expand("%:p:h"),
			hidden = true,
		})
	end, { desc = "Telescope: Find files in current buffer dir" })
	vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "Telescope: Keymaps" })
end)

-- Harpoon (v1)
pcall(function()
	local harpoon = require("harpoon")

	harpoon.setup({
		global_settings = {
			save_on_toggle = false,
		},
	})

	local mark = require("harpoon.mark")
	local ui = require("harpoon.ui")

	local function safe_harpoon_call(fn, desc)
		return function()
			local ok, err = pcall(fn)
			if not ok then
				vim.notify("Harpoon error (" .. desc .. "): " .. tostring(err), vim.log.levels.ERROR)
			end
		end
	end

	vim.keymap.set("n", "<leader>a", safe_harpoon_call(mark.add_file, "Add file"), { desc = "Harpoon: Add file" })
	vim.keymap.set("n", "<leader>m", safe_harpoon_call(ui.toggle_quick_menu, "Menu"), { desc = "Harpoon: Menu" })
	vim.keymap.set("n", "<leader>hn", safe_harpoon_call(ui.nav_next, "Next file"), { desc = "Harpoon: Next file" })
	vim.keymap.set(
		"n",
		"<leader>hp",
		safe_harpoon_call(ui.nav_prev, "Previous file"),
		{ desc = "Harpoon: Previous file" }
	)

	for i = 1, 4 do
		vim.keymap.set(
			"n",
			"<leader>h" .. i,
			safe_harpoon_call(function()
				ui.nav_file(i)
			end, "Select file " .. i),
			{ desc = "Harpoon file " .. i }
		)
	end
end)

-- ===============================
--   LSP & Mason Setup
-- ===============================
pcall(function()
	require("mason").setup()
	require("mason-tool-installer").setup({ ensure_installed = { "stylua" } })

	local capabilities = vim.lsp.protocol.make_client_capabilities()
	pcall(function()
		capabilities = require("blink.cmp").get_lsp_capabilities()
	end)

	local servers = {
		lua_ls = {
			settings = {
				Lua = {
					completion = { callSnippet = "Replace" },
					diagnostics = { globals = { "vim" } },
				},
			},
		},
		phpactor = {
			init_options = {
				["language_server_phpstan.enabled"] = false,
				["language_server_psalm.enabled"] = false,
			},
		},
	}

	require("mason-lspconfig").setup({
		ensure_installed = vim.tbl_keys(servers),
		handlers = {
			function(server_name)
				local server = servers[server_name] or {}
				server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
				require("lspconfig")[server_name].setup(server)
			end,
		},
	})
end)

-- ===============================
--   LSP Keymaps and Diagnostics
-- ===============================
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("user-lsp-attach", { clear = true }),
	callback = function(event)
		local map = function(keys, func, desc, mode)
			mode = mode or "n"
			vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
		end

		local builtin = require("telescope.builtin")

		map("grn", vim.lsp.buf.rename, "[R]e[n]ame")
		map("gra", vim.lsp.buf.code_action, "[A]ction", { "n", "x" })
		map("grr", builtin.lsp_references, "[R]eferences")
		map("grd", builtin.lsp_definitions, "[D]efinitions")
		map("gri", builtin.lsp_implementations, "[I]mplementations")
		map("grt", builtin.lsp_type_definitions, "[T]ype Defs")
		map("gO", builtin.lsp_document_symbols, "Document Symbols")
		map("gW", builtin.lsp_dynamic_workspace_symbols, "Workspace Symbols")

		local client = vim.lsp.get_client_by_id(event.data.client_id)
		if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
			map("<leader>th", function()
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
			end, "Toggle Inlay Hints")
		end
	end,
})

vim.diagnostic.config({
	severity_sort = true,
	float = { border = "rounded", source = "if_many" },
	underline = { severity = vim.diagnostic.severity.ERROR },
	signs = vim.g.have_nerd_font and {
		text = {
			[vim.diagnostic.severity.ERROR] = "󰅚 ",
			[vim.diagnostic.severity.WARN] = "󰀪 ",
			[vim.diagnostic.severity.INFO] = "󰋽 ",
			[vim.diagnostic.severity.HINT] = "󰌶 ",
		},
	} or {},
	virtual_text = {
		source = "if_many",
		spacing = 2,
		format = function(diagnostic)
			return diagnostic.message
		end,
	},
})

-- ===============================
--   Misc Autocmds
-- ===============================
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking text",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})


