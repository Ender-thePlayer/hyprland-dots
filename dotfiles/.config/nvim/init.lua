vim.wo.number = true
vim.api.nvim_set_keymap('n', 'C-u', '<u>', { noremap = true })

vim.api.nvim_create_autocmd("VimEnter", {
    pattern = "*",
    command = "set mouse="
})

require "paq" {
    "savq/paq-nvim", -- Let Paq manage itself
	
    "andweeb/presence.nvim",

    "neovim/nvim-lspconfig",

    "xiyaowong/transparent.nvim",

    { "lervag/vimtex", opt = true }, -- Use braces when passing options

    { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
}


require("presence").setup({
	main_image = "file"
})

require("transparent").setup({ -- Optional, you don't have to run setup.
  groups = { -- table: default groups
    'Normal', 'NormalNC', 'Comment', 'Constant', 'Special', 'Identifier',
    'Statement', 'PreProc', 'Type', 'Underlined', 'Todo', 'String', 'Function',
    'Conditional', 'Repeat', 'Operator', 'Structure', 'LineNr', 'NonText',
    'SignColumn', 'CursorLine', 'CursorLineNr', 'StatusLine', 'StatusLineNC',
    'EndOfBuffer',
  },
  extra_groups = {}, -- table: additional groups that should be cleared
  exclude_groups = {}, -- table: groups you don't want to clear
})
