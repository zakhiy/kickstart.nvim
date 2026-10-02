-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

vim.pack.add {
  { src = 'https://github.com/nvim-neo-tree/neo-tree.nvim', version = vim.version.range '*' },
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/MunifTanjim/nui.nvim',
}

vim.keymap.set('n', '\\', '<Cmd>Neotree reveal<CR>', { desc = 'NeoTree reveal', silent = true })

require('neo-tree').setup {
  filesystem = {
    window = {
      mappings = {
        ['\\'] = 'close_window',
      },
    },
    use_libuv_file_watcher = false,
    git_status_async = true,
    bind_to_cwd = false,
  },
  git_status = {
    window = {
      position = 'float',
    },
  },
  default_component_configs = {
    git_status = {
      symbols = {
        added = '✚',
        deleted = '✖',
        modified = '•',
        renamed = '➜',
        untracked = '○',
        ignored = '◌',
        unstaged = '○',
        staged = '●',
        conflict = '⚠',
      },
    },
  },
}
