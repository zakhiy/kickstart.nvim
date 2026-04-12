-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

---@module 'lazy'
---@type LazySpec
return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  lazy = false,
  keys = {
    { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
  },
  ---@module 'neo-tree'
  ---@type neotree.Config
  opts = {
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
  },
}
