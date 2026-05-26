------------ Plugin Manager ------------

-- Lazy loader
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fs.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({

	-- Auto complete
	{
		"saghen/blink.cmp",
		dependencies = { "rafamadriz/friendly-snippets" },

		version = "1.*",

		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			keymap = {
				preset = "enter",
			},

			appearance = {
				nerd_font_variant = "mono",
			},

			completion = { documentation = { auto_show = false } },

			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
			},

			fuzzy = { implementation = "prefer_rust_with_warning" },
		},
		opts_extend = { "sources.default" },
	},

	-- Mason
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},

	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				automatic_enable = false,
				ensure_installed = {
					"clangd",
					"html",
					"lua_ls",
					"gopls",
					"ts_ls",
					"pyright",
					"tailwindcss",
					"jdtls",
				},
			})
		end,
	},

	{
		"neovim/nvim-lspconfig",
		config = function()
			local capabilities = require("blink.cmp").get_lsp_capabilities()
			vim.lsp.config("*", {
				capabilities = capabilities,
			})
			vim.lsp.enable({
				"lua_ls",
				"gopls",
				"ts_ls",
				"pyright",
				"clangd",
				"html",
				"tailwindcss",
				"jdtls",
			})
		end,
	},

	-- Oil
	{
		"stevearc/oil.nvim",
		---@module 'oil'
		---@type oil.SetupOpts
		opts = {
			view_options = {
				show_hidden = true,
			},
			lsp_file_methods = {
				enabled = true,
				timeout_ms = 1000,
			},
			skip_confirm_for_simple_edits = true,
		},
		dependencies = { { "nvim-mini/mini.icons", opts = {} } },
		lazy = false,

		config = function(_, opts)
			require("oil").setup(opts)

			-- Auto-open Oil if nvim was started on a directory
			vim.api.nvim_create_autocmd("VimEnter", {
				callback = function()
					local path = vim.fn.expand("%:p")
					if vim.fn.isdirectory(path) == 1 then
						require("oil").open(path)
					end
				end,
			})

			vim.api.nvim_create_autocmd("User", {
				pattern = "OilActionsPost",
				callback = function(event)
					local actions = event.data and event.data.actions
					local action = actions and actions[1]
					if not action or action.type ~= "move" then
						return
					end

					local ok, snacks = pcall(require, "snacks")
					if not ok or not snacks.rename then
						return
					end

					snacks.rename.on_rename_file(action.src_url, action.dest_url, function()
						vim.cmd("silent! wall")
					end)
				end,
			})
		end,
	},

	-- Fzf Lua
	{
		"ibhagwan/fzf-lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local fzf = require("fzf-lua")

			fzf.setup({
				"fzf-vim",
				files = {
					find_opts = [[--type f --hidden --no-ignore --exclude .git --exclude node_modules --exclude .venv]],
				},
				grep = {
					rg_opts = [[--color=always --hidden --smart-case --glob '!.git/*' --glob '!node_modules/*' --glob '!.venv/*']],
				},
				file_ignore_patterns = { ".git/", "node_modules/", ".venv/", "__pycache__/" },
			})

			-- Keymaps
			vim.keymap.set("n", "<leader>pf", fzf.files, { desc = "[F]ind [F]iles" })

			vim.keymap.set("n", "<leader>pw", fzf.live_grep_native, { desc = "[F]ind [W]ord" })

			vim.keymap.set("n", "<leader>fb", fzf.git_branches, { desc = "[F]ind by Git [B]ranches" })
			vim.keymap.set("n", "<leader>fd", fzf.diagnostics_document, { desc = "[F]ind [D]iagnostics" })
			vim.keymap.set("n", "gd", fzf.lsp_definitions, { desc = "[G]oto [D]efinition" })
			vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "LSP Hover Documentation" })
		end,
	},

	-- Git signs
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			on_attach = function(bufnr)
				local gitsigns = require("gitsigns")

				local function map(mode, lhs, rhs, desc)
					vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
				end

				map("n", "<leader>gn", function()
					gitsigns.nav_hunk("next", { target = "all" })
				end, "Next git hunk")
				map("n", "<leader>gN", function()
					gitsigns.nav_hunk("prev", { target = "all" })
				end, "Previous git hunk")

				map("n", "<leader>gs", gitsigns.stage_hunk, "[g]it [s]tage/unstage")
				map("n", "<leader>gr", gitsigns.reset_hunk, "[g]it [r]eject")
				map("v", "<leader>gs", function()
					gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, "Stage selected git lines")

				-- Git reset for selections
				map("v", "<leader>gr", function()
					gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, "[g]it [r]eset")

				map("n", "<leader>gp", gitsigns.preview_hunk, "[g]it [p]review")
				map("n", "<leader>gd", gitsigns.diffthis, "[g]it [d]iff")
			end,
		},
	},

	-- Auto Format
	{
		"stevearc/conform.nvim",
		lazy = false,
		keys = {
			{
				"<leader>w",
				function()
					require("conform").format({ async = true })
				end,
				mode = "",
				desc = "format buffer",
			},
		},
		opts = {
			notify_on_error = false,
			format_after_save = function(bufnr)
				local disable_filetypes = { c = true, cpp = true, html = true }
				return {
					timeout_ms = 500,
					lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
				}
			end,
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "isort", "black" },
				sql = { "sql_formatter", stop_after_first = true },
				javascript = { "prettierd" },
				typescript = { "prettierd", "biome" },
				typescriptreact = { "prettierd", "biome" },
				javascriptreact = { "prettierd" },
				markdown = { "prettierd", "prettier", stop_after_first = true },
				css = { "prettierd", "prettier", stop_after_first = true },
				html = { "prettierd", "prettier", stop_after_first = true },
				cpp = { "clang-format" },
				c = { "clang-format" },
				go = { "gofumpt" },
			},
		},
	},

	-- Comment.nvim (gcc, gco, etc)
	{
		"numToStr/Comment.nvim",
		opts = {
			toggler = {
				block = "gbc",
			},
		},
	},

	-- Tmux navigator (vim navigation for tmux panes)
	{
		"christoomey/vim-tmux-navigator",
		cmd = {
			"TmuxNavigateLeft",
			"TmuxNavigateDown",
			"TmuxNavigateUp",
			"TmuxNavigateRight",
			"TmuxNavigatePrevious",
			"TmuxNavigatorProcessList",
		},
		keys = {
			{ "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>", desc = "Navigate left" },
			{ "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>", desc = "Navigate down" },
			{ "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>", desc = "Navigate up" },
			{ "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>", desc = "Navigate right" },
			{ "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>", desc = "Navigate previous" },
		},
	},

	-- Mini.nvim (small independent plugins/modules)
	{
		"echasnovski/mini.nvim",
		config = function()
			require("mini.surround").setup()
			require("mini.pairs").setup()
		end,
	},

	-- Color Theme
	{
		"olimorris/onedarkpro.nvim",
		priority = 1000,
		config = function()
			require("onedarkpro").setup()
			vim.cmd.colorscheme("onedark_vivid")
		end,
	},

	-- Harpoon
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
	},

	-- Git conflict resolution
	{
		"akinsho/git-conflict.nvim",
		version = "*",
		opts = {
			default_mappings = {
				ours = "co",
				theirs = "ct",
				both = "cb",
				none = "c0",
				next = "[x",
				prev = "]x",
			},
		},
	},

	-- Markdown preview
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		build = "cd app && yarn install",
		init = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,
		ft = { "markdown" },
	},
})
