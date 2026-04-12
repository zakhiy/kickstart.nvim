---@module 'lazy'
---@type LazySpec[]
return {
  {
    'MeanderingProgrammer/render-markdown.nvim',
    ft = { 'markdown' },
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.nvim' },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
      file_types = { 'markdown' },
      render_modes = { 'n', 'c', 't' },
      completions = {
        lsp = { enabled = true },
      },
    },
  },
  {
    'iamcco/markdown-preview.nvim',
    ft = { 'markdown' },
    cmd = { 'MarkdownPreview', 'MarkdownPreviewToggle', 'MarkdownPreviewStop' },
    keys = {
      { '<leader>p', '<cmd>MarkdownPreview<CR>', desc = 'Markdown preview' },
      { '<leader>mt', '<cmd>MarkdownPreviewToggle<CR>', desc = 'Markdown preview toggle' },
      { '<leader>ms', '<cmd>MarkdownPreviewStop<CR>', desc = 'Markdown preview stop' },
    },
    build = 'cd app && npx --yes yarn install',
    init = function()
      vim.cmd [[
        function! OpenMarkdownPreview(url) abort
          call jobstart(['open', a:url], {'detach': v:true})
        endfunction
      ]]

      vim.g.mkdp_filetypes = { 'markdown' }
      vim.g.mkdp_theme = 'dark'
      vim.g.mkdp_auto_start = 0
      vim.g.mkdp_auto_close = 1
      vim.g.mkdp_echo_preview_url = 1
      vim.g.mkdp_browserfunc = 'OpenMarkdownPreview'
    end,
  },
}
