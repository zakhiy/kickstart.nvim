local tutorial = {}

local targets = {
  words = 'The quick brown fox delivers coffee.',
  quotes = 'message = "ship it"',
  lines = 'keep this line\nkeep this one too',
  repeat_edit = 'apple green\napple blue\napple gold',
  substitute = 'cat naps\ncat runs\ncat wins',
}

local hints = {
  words = 'In the exercise sentence (below its marker), move onto steals with h/l. Type ciw, delivers, then <Esc>.',
  quotes = 'Move inside the quotes. Type ci", ship it, then <Esc>.',
  lines = 'Move to DELETE THIS LINE and press dd.',
  repeat_edit = 'On the first pear: ciwapple<Esc>. Then j0. and j0. to repeat.',
  substitute = 'Select ONLY the three dog lines with V2j. Type :s/dog/cat/g<Enter>.',
}

local namespace = vim.api.nvim_create_namespace 'kickstart-tutorial'
local updating = false

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
  if updating then return end
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
  local rank = complete == total and total > 0 and 'PILOT' or 'CADET'
  vim.api.nvim_buf_set_extmark(0, namespace, 0, 0, {
    virt_text = { { string.format('  %s | %d/%d | %d XP | Space ti: hint, tn: next', rank, complete, total, complete * 10), 'Title' } },
  })
end

local function workbook_path() return vim.fn.stdpath 'data' .. '/kickstart-tutorial/workbook.md' end

local function is_workbook()
  local path = workbook_path()
  if vim.api.nvim_buf_get_name(0) == (vim.uv.fs_realpath(path) or path) then return true end
  vim.notify('Open your workbook with :Tut first.', vim.log.levels.WARN)
  return false
end

local function mark(id, complete)
  for index, line in ipairs(vim.api.nvim_buf_get_lines(0, 0, -1, false)) do
    if line:match('^%- %[[ x]%] `' .. id .. '` ') then
      local replacement = line:gsub('%[[ x]%]', complete and '[x]' or '[ ]', 1)
      if line ~= replacement then vim.api.nvim_buf_set_lines(0, index - 1, index, false, { replacement }) end
      return true
    end
  end
  return false
end

local function check(silent)
  if not is_workbook() then return end
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
  if not silent then vim.notify(string.format('%d/%d edit challenges passed. Save with :w. Try :TutorialNext.', passed, total)) end
end

local function navigate(direction)
  if not is_workbook() then return end
  local available = {}
  for _, task in ipairs(tasks()) do
    if direction < 0 or not task.complete then table.insert(available, task) end
  end
  if #available == 0 then
    vim.notify 'All missions complete! Save with :w and take your real-world lap.'
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
  vim.api.nvim_create_autocmd({ 'TextChanged', 'TextChangedI', 'InsertLeave', 'BufEnter' }, {
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

function tutorial.setup()
  vim.api.nvim_create_user_command('KickstartTutorial', function()
    local path = workbook_path()
    if vim.fn.filereadable(path) == 0 then
      local source = vim.fn.stdpath 'config' .. '/doc/kickstart-tutorial.md'
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
  end, { desc = 'Open your resumable Kickstart workbook' })
  vim.api.nvim_create_user_command('Tut', function() vim.cmd 'KickstartTutorial' end, { desc = 'Open your resumable Kickstart workbook' })

  vim.api.nvim_create_user_command('TutorialCheck', function() check(false) end, { desc = 'Check the five editing challenges' })
  vim.api.nvim_create_user_command('TutorialNext', function() navigate(1) end, { desc = 'Next unfinished mission' })
  vim.api.nvim_create_user_command('TutorialPrevious', function() navigate(-1) end, { desc = 'Previous mission' })
  vim.api.nvim_create_user_command('TutorialHint', hint, { desc = 'Hint for the current mission' })
  vim.api.nvim_create_user_command('TutorialMark', function(args)
    if not is_workbook() then return end
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
