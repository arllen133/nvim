local map = vim.keymap.set


map('n', '<leader>e', '<Cmd>Neotree toggle<CR>', { silent = true })


-- Move to window using the <ctrl> hjkl keys
map("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window", remap = true })
map("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
map("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
map("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window", remap = true })


-- Add undo break-points
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")
map("i", ";", ";<c-g>u")


-- bufferline
map("n", "<leader>bd", function()
    vim.api.nvim_command('bp|bd#')
end, { desc = "Delete Current Buffer", remap = true })

-- clear hlsearch
-- map("n", "<Esc><Esc>", ":noh<CR>", { desc = "Clear Highlight Search" })

-- Map the function to a key
map("n", "<leader>gg", ":lua LazyVim.open_lazygit()<CR>", { noremap = true, silent = true, desc = "Open Lazygit" })

-- Map the function to a key
map("n", "<leader>ra", ":lua LazyVim.reload_all_buffers()<CR>",
    { noremap = true, silent = true, desc = "Realod All Bufders" })

-- codelens
map('n', '<leader>cl', '<cmd>lua LazyVim.show_and_execute_codelens()<CR>',
    { noremap = true, silent = true, desc = "Open and Execute Codelens" })
