-- press [:source $MYVIMRC] for reload config
-- scroll using [ctrl + (u - d)(y - e)(f - b)]

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- Normal mode
vim.keymap.set("n", "<C-h>", "b", { desc = "Move to previous word" })
vim.keymap.set("n", "<C-l>", "w", { desc = "Move to next word" })

-- Visual mode
vim.keymap.set("v", "<C-h>", "b", { desc = "Move to previous word" })
vim.keymap.set("v", "<C-l>", "w", { desc = "Move to next word" })

-- Insert mode
vim.keymap.set("i", "<C-h>", "<C-o>b", { desc = "Move to previous word" })
vim.keymap.set("i", "<C-l>", "<C-o>w", { desc = "Move to next word" })
