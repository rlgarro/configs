set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set number
set rnu
set path=**
set wildmenu
colorscheme darcula

set tags+=~/java-21-tags

call plug#begin()
        Plug 'epwalsh/obsidian.nvim'
        Plug 'nvim-lua/plenary.nvim'
        Plug 'neovim/nvim-lspconfig'
        Plug 'hrsh7th/cmp-nvim-lsp'
        Plug 'hrsh7th/cmp-buffer'
        Plug 'hrsh7th/cmp-path'
        Plug 'hrsh7th/cmp-cmdline'
        Plug 'hrsh7th/nvim-cmp'
        Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.8' }
call plug#end()

lua << EOF
require("obsidian").setup({
    workspaces = {
        {
          name = "personal",
          path = "/home/rl250348/Dokumente/ObsidianVault",
        },
      },
    ui = { enable = false; },
    picker = {
    -- Set your preferred picker. Can be one of 'telescope.nvim', 'fzf-lua', or 'mini.pick'.
    name = "telescope.nvim",
    -- Optional, configure key mappings for the picker. These are the defaults.
    -- Not all pickers support all mappings.
    note_mappings = {
      -- Create a new note from your query.
      new = "<C-x>",
      -- Insert a link to the selected note.
      insert_link = "<C-l>",
    },
    tag_mappings = {
      -- Add tag(s) to current note.
      tag_note = "<C-x>",
      -- Insert a tag at the current location.
      insert_tag = "<C-l>",
    },
  },
})
EOF
