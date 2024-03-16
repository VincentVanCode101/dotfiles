require('telescope').setup({
    defaults = {
        file_ignore_patterns = { '^node_modules/', '^.obsidian/' },
    }
})

local builtin = require('telescope.builtin')

-- Modify this key mapping to include hidden files in the search

vim.keymap.set('n', '<leader>pf', function() builtin.find_files({ hidden = true }) end, {})

vim.keymap.set('n', '<leader>lg', builtin.live_grep, {})

vim.keymap.set('n', '<C-p>', builtin.git_files, {})

vim.keymap.set('n', '<leader>ps', function()
    local opts = {
        search = vim.fn.input("Grep > "),
        additional_args = function()
            return {"--hidden"}
        end
    }
    builtin.grep_string(opts)
end)


--vim.keymap.set("n", "<leader>?", require("telescope.builtin").oldfiles, { desc = "[?] Find recently opened files" })
vim.keymap.set("n", "<leader>sd", require("telescope.builtin").diagnostics, { desc = "[S]earch [D]iagnostics" })
--vim.keymap.set("n", "<leader>jl", require("telescope.builtin").jumplist, { desc = "[J]ump [L]ist" })
--vim.keymap.set("n", "<leader>km", require("telescope.builtin").keymaps, { desc = "[K]ey[M]aps" })
--vim.keymap.set("n", "<leader>rg", require("telescope.builtin").registers, { desc = "[R]egisters" })
vim.keymap.set("n", "<leader>ht", require("telescope.builtin").help_tags, { desc = "[H]elp [T]ags" })
