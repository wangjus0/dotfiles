------------ Nvim Mappings ------------

-- Leader
vim.g.mapleader = " "

-- Save
vim.keymap.set("n", "<leader>w", "<cmd>write<cr>", { desc = "Save" })

-- Centers cursor for half page jumps
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Groups and move text up/dowm in visual mode
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")

-- Move through wrapped lines
vim.keymap.set("n", "<Up>", "gk", { desc = "Move up through wrapped lines" })
vim.keymap.set("n", "<Down>", "gj", { desc = "Move down through wrapped lines" })

-- Quick indent
vim.keymap.set("n", "<", "<<", { noremap = true })
vim.keymap.set("n", ">", ">>", { noremap = true })

-- Show Diagnostic
vim.keymap.set("n", "D", vim.diagnostic.open_float, {
	desc = "[S]how [D]iagnostic",
})

-- Split horizontal/vertical
vim.keymap.set("n", "<leader>sv", ":vsplit<CR>", { desc = "[S]plit [v]ertical" })
vim.keymap.set("n", "<leader>sh", ":split<CR>", { desc = "[S]plit [h]orizontal" })

------------ Plugin Mappings ------------

-- Oil
vim.keymap.set("n", "<leader>e", function()
	require("oil").open(vim.fn.expand("%:p:h"))
end, { desc = "Oil: Open current file directory" })

-- Harpoon
local harpoon = require("harpoon")

harpoon:setup()

vim.keymap.set("n", "<leader>a", function()
	harpoon:list():add()
end, { desc = "Harpoon: Add file" })

vim.keymap.set("n", "<leader>h", function()
	harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = "Harpoon: Toggle menu" })

vim.keymap.set("n", "th", function()
	harpoon:list():select(1)
end, { desc = "Harpoon file 1" })
vim.keymap.set("n", "tj", function()
	harpoon:list():select(2)
end, { desc = "Harpoon file 2" })
vim.keymap.set("n", "tk", function()
	harpoon:list():select(3)
end, { desc = "Harpoon file 3" })
vim.keymap.set("n", "tl", function()
	harpoon:list():select(4)
end, { desc = "Harpoon file 4" })
vim.keymap.set("n", "t;", function()
	harpoon:list():select(5)
end, { desc = "Harpoon file 5" })

-- Fuzzy Finder
local fzf = require("fzf-lua")

vim.keymap.set("n", "<leader>pf", fzf.files, { desc = "[F]ind [F]iles" })

vim.keymap.set("n", "<leader>pw", fzf.live_grep_native, { desc = "[F]ind [W]ord" })

vim.keymap.set("n", "<leader>fb", fzf.git_branches, { desc = "[F]ind by Git [B]ranches" })
vim.keymap.set("n", "<leader>fd", fzf.diagnostics_document, { desc = "[F]ind by Git [B]ranches" })

vim.keymap.set("n", "gd", function()
	require("fzf-lua").lsp_definitions({
		jump1 = true,
	})
end, { desc = "Go to definition" })

-- Misc
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "LSP Hover Documentation" })
