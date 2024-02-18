require("oil").setup()
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
vim.keymap.set("n", "<A-o>", "<CMD>Oil --float<CR>", { desc = "Open parent directory" })
