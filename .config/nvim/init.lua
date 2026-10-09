-- press [:source $MYVIMRC] for reload config
-- scroll using [ctrl + (u - d)(y - e)(f - b)]

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

------------------------ Move cursor ------------------------
-- Visual mode
vim.keymap.set("v", "<C-h>", "b", { desc = "Move to previous word" })
vim.keymap.set("v", "<C-l>", "w", { desc = "Move to next word" })

-- Insert mode
vim.keymap.set("i", "<C-h>", "<C-o>b", { desc = "Move to previous word" })
vim.keymap.set("i", "<C-l>", "<C-o>w", { desc = "Move to next word" })

----------------------- Scroll config ------------------------
-- Normal mode
vim.keymap.set("n", "<C-j>", "<C-e>", { desc = "Scroll oneline to bottom" })
vim.keymap.set("n", "<C-k>", "<C-y>", { desc = "Scroll oneline to top" })
