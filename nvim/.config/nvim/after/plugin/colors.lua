-- Rose Pine color theme
--	use({ 'rose-pine/neovim', as = 'rose-pine' })

-- Configure Rose Pine for Dawn variant
--   require('rose-pine').setup({
--       variant = 'moon', -- Set the variant to 'dawn' for the light version
--       -- Other configuration options
--       dark_variant = 'moon',
--       bold_vert_split = false,
--       dim_nc_background = false,
----        disable_background = false,
----        disable_float_background = false,
--       disable_italics = false,
--   })

-- Set colorscheme after options
--	vim.cmd('colorscheme rose-pine')

function ColorMyPencil(color)
    color = color or "rose-pine"
    vim.cmd.colorscheme(color)

    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

---ColorMyPencils()

function ColorMyPencils(color)
    color = color or "rose-pine"
    vim.cmd.colorscheme(color)

    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

return {


}
