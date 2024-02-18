local builtin = require('telescope.builtin')

-- Modify this key mapping to include hidden files in the search
vim.keymap.set('n', '<leader>pf', function() builtin.find_files({ hidden = true }) end, {})


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
