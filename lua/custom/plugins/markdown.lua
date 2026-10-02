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

-- Treesitter and mini.nvim are installed before custom modules in init.lua.
-- The Markdown preview build hook is registered there before vim.pack installs plugins.
vim.pack.add {
  'https://github.com/MeanderingProgrammer/render-markdown.nvim',
  'https://github.com/iamcco/markdown-preview.nvim',
}

require('render-markdown').setup {
  file_types = { 'markdown' },
  render_modes = { 'n', 'c', 't' },
  completions = {
    lsp = { enabled = true },
  },
}

vim.keymap.set('n', '<leader>p', '<Cmd>MarkdownPreview<CR>', { desc = 'Markdown preview' })
vim.keymap.set('n', '<leader>mt', '<Cmd>MarkdownPreviewToggle<CR>', { desc = 'Markdown preview toggle' })
vim.keymap.set('n', '<leader>ms', '<Cmd>MarkdownPreviewStop<CR>', { desc = 'Markdown preview stop' })
