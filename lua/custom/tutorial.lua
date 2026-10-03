local tutorial = {}

local chapters = {
  ['1'] = { template = 'kickstart-tutorial.md', workbook = 'workbook.md', rank = 'PILOT' },
  ['2'] = { template = 'kickstart-tutorial-editing.md', workbook = 'chapter-2.md', rank = 'ACE' },
  ['3'] = { template = 'kickstart-tutorial-workflow.md', workbook = 'chapter-3.md', rank = 'ENGINEER' },
}

local targets = {
  words = 'The quick brown fox delivers coffee.',
  quotes = 'message = "ship it"',
  lines = 'keep this line\nkeep this one too',
  repeat_edit = 'apple green\napple blue\napple gold',
  substitute = 'cat naps\ncat runs\ncat wins',
  named_register = 'treasure\ntreasure',
  block_comments = '// oak\n// elm\n// ash',
  macro = 'item: red;\nitem: blue;\nitem: gold;',
  surround_add = '(parcel)',
  surround_replace = '"cargo"',
  ai_argument = 'paint("red", 99, { x = 1, y = 2 })',
  case = 'READY FOR LAUNCH',
}

local hints = {
  words = 'In the exercise sentence (below its marker), move onto steals with h/l. Type ciw, delivers, then <Esc>.',
  quotes = 'Move inside the quotes. Type ci", ship it, then <Esc>.',
  lines = 'Move to DELETE THIS LINE and press dd.',
  repeat_edit = 'On the first pear: ciwapple<Esc>. Then j0. and j0. to repeat.',
  substitute = 'Select ONLY the three dog lines with V2j. Type :s/dog/cat/g<Enter>.',
  named_register = 'First exercise line: "ayy. Then j"_dd, "_dd, k to return to treasure, and "ap to paste below it.',
  block_comments = 'On oak: 0, Ctrl-v, 2j, I, type // followed by a space, then Esc. Wait for all three lines to update.',
  macro = 'On red: qq0Iitem: <Esc>A;<Esc>j0q. Now on blue: 2@q. Stay inside the block.',
  surround_add = 'On parcel: saiw). mini.surround uses ) for tight parentheses, ( for padded ones.',
  surround_replace = 'Inside (cargo): sr)". Replace the parentheses with double quotes.',
  ai_argument = 'On 42: cia99<Esc>. mini.ai defines ia as the inner argument, excluding surrounding spaces.',
  case = 'At the start of the exercise line: 0gU$. gU uppercases the text covered by $.',
}

local namespace = vim.api.nvim_create_namespace 'kickstart-tutorial'
local updating = false

local function workbook_path(chapter) return vim.fn.stdpath 'data' .. '/kickstart-tutorial/' .. chapters[chapter].workbook end

local function current_chapter()
  local name = vim.api.nvim_buf_get_name(0)
  for chapter in pairs(chapters) do
    local path = workbook_path(chapter)
    if name == (vim.uv.fs_realpath(path) or path) then return chapter end
  end
end

local function tasks()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local result = {}
  local section_row = 1
  for index, line in ipairs(lines) do
    if line:match '^## ' then section_row = index end
    local checked, id, description = line:match '^%- %[(.)%] `([%w_]+)` (.+)$'
    if id then
      local task = { id = id, row = index, section_row = section_row, complete = checked == 'x', description = description }
      if targets[id] then
        local block, collecting, closed = {}, false, false
        for block_row = index + 1, #lines do
          local block_line = lines[block_row]
          if block_line:match '^## ' or block_line:match '^%- %[[ x]%] `' then
            break
          elseif block_line == '<!-- exercise:' .. id .. ' -->' then
            collecting = true
            task.start_row = block_row + 1
          elseif collecting and block_line == '<!-- end -->' then
            closed = true
            break
          elseif collecting then
            table.insert(block, block_line)
          end
        end
        task.complete = closed and table.concat(block, '\n') == targets[id]
        task.valid = closed
      end
      table.insert(result, task)
    end
  end
  return result
end

local function current_task()
  local row = vim.api.nvim_win_get_cursor(0)[1]
  local result = tasks()
  local current = result[1]
  for _, task in ipairs(result) do
    if current and task.section_row > current.section_row and row >= task.section_row and row < task.row then return task end
    if task.row > row then break end
    current = task
  end
  return current
end

local function render()
  local chapter = current_chapter()
  if updating or not chapter then return end
  vim.api.nvim_buf_clear_namespace(0, namespace, 0, -1)
  local complete, total = 0, 0
  for _, task in ipairs(tasks()) do
    total = total + 1
    if task.complete then complete = complete + 1 end
    local label = task.complete and '  PASS +10 XP' or (targets[task.id] and '  IN PROGRESS' or '  SELF-CHECK')
    if task.complete and not targets[task.id] then label = '  DONE (SELF-MARKED) +10 XP' end
    if targets[task.id] and not task.valid then label = '  RESTORE EXERCISE/END MARKERS' end
    vim.api.nvim_buf_set_extmark(0, namespace, task.row - 1, 0, {
      virt_text = { { label, task.complete and 'DiagnosticOk' or 'DiagnosticInfo' } },
    })
  end
  local rank = complete == total and total > 0 and chapters[chapter].rank or 'CADET'
  vim.api.nvim_buf_set_extmark(0, namespace, 0, 0, {
    virt_text = { { string.format('  CH%s %s | %d/%d | %d XP | Space ti: hint, tn: next', chapter, rank, complete, total, complete * 10), 'Title' } },
  })
end

local function is_workbook()
  if current_chapter() then return true end
  vim.notify('Open your workbook with :Tut first.', vim.log.levels.WARN)
  return false
end

local function mark(id, complete)
  for index, line in ipairs(vim.api.nvim_buf_get_lines(0, 0, -1, false)) do
    if line:match '^%- %[[ x]%] `([%w_]+)` ' == id then
      local replacement = line:gsub('%[[ x]%]', complete and '[x]' or '[ ]', 1)
      if line ~= replacement then vim.api.nvim_buf_set_lines(0, index - 1, index, false, { replacement }) end
      return true
    end
  end
  return false
end

local function check(silent)
  if not is_workbook() then return end
  if not vim.bo.modifiable then
    vim.notify('This workbook is not modifiable. Live badges still show your results.', vim.log.levels.WARN)
    return
  end
  local passed, total = 0, 0
  updating = true
  for _, task in ipairs(tasks()) do
    if targets[task.id] then
      mark(task.id, task.complete)
      total = total + 1
      if task.complete then passed = passed + 1 end
    end
  end
  updating = false
  render()
  if not silent then
    local message = total > 0 and string.format('%d/%d edit challenges passed.', passed, total) or 'This chapter has self-assessed workflow missions.'
    vim.notify(message .. ' Save with :w. Try :TutorialNext.')
  end
end

local function navigate(direction)
  if not is_workbook() then return end
  local available = {}
  for _, task in ipairs(tasks()) do
    if direction < 0 or not task.complete then table.insert(available, task) end
  end
  if #available == 0 then
    vim.notify 'All chapter missions complete! Save with :w. Open another chapter with :Tut 1, :Tut 2, or :Tut 3.'
    return
  end
  local row = vim.api.nvim_win_get_cursor(0)[1]
  local destination = direction > 0 and available[1] or available[#available]
  if direction > 0 then
    for _, task in ipairs(available) do
      if task.row > row then
        destination = task
        break
      end
    end
  else
    for index = #available, 1, -1 do
      if available[index].row < row then
        destination = available[index]
        break
      end
    end
  end
  local destination_row = destination.row
  if direction > 0 and row < destination.section_row then destination_row = destination.section_row end
  vim.api.nvim_win_set_cursor(0, { destination_row, 0 })
  vim.cmd 'normal! zz'
end

local function hint()
  if not is_workbook() then return end
  local task = current_task()
  if not task then return end
  vim.notify(task.id .. ': ' .. (hints[task.id] or (task.description .. '\nWhen done: :TutorialMark ' .. task.id)), vim.log.levels.INFO)
end

local function attach()
  local has_renderer, renderer = pcall(require, 'render-markdown')
  if has_renderer then renderer.buf_disable() end
  if vim.b.kickstart_tutorial_attached then
    render()
    return
  end
  vim.b.kickstart_tutorial_attached = true
  local buffer = vim.api.nvim_get_current_buf()
  local group = vim.api.nvim_create_augroup('kickstart-tutorial-' .. buffer, { clear = true })
  vim.api.nvim_create_autocmd({ 'TextChanged', 'TextChangedI', 'TextChangedP', 'InsertLeave', 'BufEnter' }, {
    group = group,
    buffer = buffer,
    callback = render,
  })
  vim.api.nvim_create_autocmd('BufWritePre', {
    group = group,
    buffer = buffer,
    callback = function() check(true) end,
  })
  local mappings = {
    tn = { function() navigate(1) end, 'Tutorial: next unfinished mission' },
    tp = { function() navigate(-1) end, 'Tutorial: previous mission' },
    ti = { hint, 'Tutorial: hint' },
    tc = { function() check(false) end, 'Tutorial: check answers' },
    tm = { function() vim.cmd 'TutorialMark' end, 'Tutorial: mark current workflow mission' },
  }
  for keys, mapping in pairs(mappings) do
    vim.keymap.set('n', '<leader>' .. keys, mapping[1], { buffer = buffer, desc = mapping[2] })
  end
  render()
end

local function open(chapter)
  local path = workbook_path(chapter)
  if vim.fn.filereadable(path) == 0 then
    local source = vim.fn.stdpath 'config' .. '/doc/' .. chapters[chapter].template
    if vim.fn.filereadable(source) == 0 then
      vim.notify('Tutorial template not found: ' .. source, vim.log.levels.ERROR)
      return
    end
    vim.fn.mkdir(vim.fn.fnamemodify(path, ':h'), 'p')
    vim.fn.writefile(vim.fn.readfile(source), path)
  end
  vim.cmd.edit(vim.fn.fnameescape(path))
  attach()
  vim.notify 'Tutorial controls: Space tn/tp next/previous, ti hint, tc check, tm self-mark. Save with :w.'
end

local function lab()
  local directory = vim.fn.stdpath 'data' .. '/kickstart-tutorial/lab'
  vim.fn.mkdir(directory, 'p')
  local files = {
    ['main.lua'] = {
      "local helper = require 'helper'",
      'local settings={name="pilot",visits=1}',
      'local greeting = helper.greet(settings.name)',
      'print(greeting)',
      '',
      '-- TODO: add an alternate greeting',
    },
    ['helper.lua'] = {
      'local helper = {}',
      '',
      'function helper.greet(name)',
      "  return 'Hello, ' .. name",
      'end',
      '',
      'return helper',
      '',
      '-- TODO: add a farewell',
    },
    ['.luarc.json'] = { '{"runtime":{"version":"LuaJIT"},"workspace":{"checkThirdParty":false}}' },
    ['.stylua.toml'] = { 'indent_type = "Spaces"', 'indent_width = 2', 'quote_style = "AutoPreferSingle"' },
    ['lint-demo.md'] = { '#Lint demo', '', 'This heading is deliberately missing a space.' },
  }
  for name, lines in pairs(files) do
    local path = directory .. '/' .. name
    if vim.fn.filereadable(path) == 0 then vim.fn.writefile(lines, path) end
  end
  vim.cmd.edit(vim.fn.fnameescape(directory .. '/main.lua'))
  vim.notify('Practice project: ' .. directory .. '. Existing lab files were kept. No tools installed; no Git operations run.')
end

function tutorial.setup()
  local options = {
    nargs = '?',
    complete = function() return { '1', '2', '3' } end,
    desc = 'Open tutorial chapter 1, 2, or 3 (default: 1)',
  }
  local function open_command(args)
    local chapter = args.args == '' and '1' or args.args
    if not chapters[chapter] then
      vim.notify('Choose :Tut 1 (basics), :Tut 2 (editing), or :Tut 3 (workflow).', vim.log.levels.WARN)
      return
    end
    open(chapter)
  end
  vim.api.nvim_create_user_command('KickstartTutorial', open_command, options)
  vim.api.nvim_create_user_command('Tut', open_command, options)
  vim.api.nvim_create_user_command('TutLab', lab, { desc = 'Create/open the disposable tutorial Lua project without replacing existing files' })

  vim.api.nvim_create_user_command('TutorialCheck', function() check(false) end, { desc = 'Check this chapter’s editing challenges' })
  vim.api.nvim_create_user_command('TutorialNext', function() navigate(1) end, { desc = 'Next unfinished mission' })
  vim.api.nvim_create_user_command('TutorialPrevious', function() navigate(-1) end, { desc = 'Previous mission' })
  vim.api.nvim_create_user_command('TutorialHint', hint, { desc = 'Hint for the current mission' })
  vim.api.nvim_create_user_command('TutorialMark', function(args)
    if not is_workbook() then return end
    if not vim.bo.modifiable then
      vim.notify('This workbook is not modifiable. Use :setlocal modifiable before marking.', vim.log.levels.WARN)
      return
    end
    local task = current_task()
    local id = args.args ~= '' and args.args or (task and task.id)
    if not id then return end
    if targets[id] then
      vim.notify('Use :TutorialCheck for automatically graded challenges.', vim.log.levels.WARN)
    elseif mark(id, true) then
      render()
      vim.notify 'Marked complete. Save with :w.'
    else
      vim.notify('Unknown exercise ID: ' .. args.args, vim.log.levels.WARN)
    end
  end, { nargs = '?', desc = 'Self-mark the current workflow exercise or an ID' })
end

return tutorial
