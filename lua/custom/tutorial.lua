local tutorial = {}

local chapters = {
  ['1'] = { template = 'kickstart-tutorial.md', workbook = 'workbook.md', rank = 'PILOT' },
  ['2'] = { template = 'kickstart-tutorial-editing.md', workbook = 'chapter-2.md', rank = 'ACE' },
  ['3'] = { template = 'kickstart-tutorial-workflow.md', workbook = 'chapter-3.md', rank = 'ENGINEER' },
}

local targets = {
  recover_patch = 'local retries = 3',
  cleanup = 'save_document(buffer);\nfree(buffer);\nreturn 0;',
  append_path = 'local path = "reports" .. "/daily.csv"',
  timeout = 'const int timeout_seconds = 30;',
  parse_call = 'response = json.loads(payload)',
  report_path = 'local output = "exports/report.txt"',
  retry_args = 'schedule_retry(user_id, timeout_seconds);',
  add_test = 'assert normalize("ERROR") == "error"\nassert normalize("WARN") == "warn"',
  remove_debug = 'response = fetch_user(user_id)\nreturn response',
  remove_duplicate = 'Ship the parser fix.',
  timeouts = 'connect_timeout = 30\nread_timeout = 30\nwrite_timeout = 30',
  log_levels = 'LOG_INFO("connected");\nconnect();\nLOG_INFO("ready");\nconst char *diagnostic_label = "LOG_DEBUG";',
  secure_urls = 'api_url = "https://api.example.test/users"\nhealth_url = "https://api.example.test/health"\nmirror_url = "http://archive.example.test/snapshots"',
  route_versions = 'local primary = "v2/users"\nlocal backup = "v2/users"\nlocal changelog = "v1 released"',
  repair_parser = 'def load_config(url):\n    timeout = 30\n    return requests.get(url, timeout=timeout).json()',
  format_keys = 'format: Space f',
  config_loader = 'plugin loader: vim.pack',
  help_object = 'delete object: aw',
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
  recover_patch = 'On 0: r3, u, then Ctrl-r. Finish with local retries = 3.',
  cleanup = 'On save_document(buffer); press o, type free(buffer);, then Esc.',
  append_path = 'Press A and type a space followed by .. "/daily.csv", then Esc.',
  timeout = 'On 5: ciw, type 30, then Esc. The semicolon is outside iw.',
  parse_call = 'On load after json.: ciw, type loads, then Esc. Keep json. and the argument unchanged.',
  report_path = 'Inside the path quotes: ci", type exports/report.txt, then Esc.',
  retry_args = 'Inside the parentheses: ci(, type user_id, timeout_seconds, then Esc.',
  add_test = 'Copy the line with yy and paste with p. In the copy, use ci" to change ERROR to WARN and error to warn.',
  remove_debug = 'On print(response): dd. Keep the fetch and return lines.',
  remove_duplicate = 'On either duplicated the: daw. Unlike diw, aw includes the neighboring space.',
  timeouts = 'On 2: ciw, type 30, Esc. Then j, $, . for each remaining line.',
  log_levels = [[On the first LOG_DEBUG: * searches it; N returns to that first occurrence.
Change the word to LOG_INFO with ciw. Use n, then . on the second call, not on the label string.]],
  secure_urls = 'From api_url: V, j, then :. After the selection marks, type s#http://#https://#g and Enter.',
  route_versions = 'Select only the first two lines with Vj. Use :s#v1/users#v2/users#g on that selection.',
  repair_parser = 'Delete the print line with dd. Change 2 to 30 with ciw. On the final text: ciw, type json(), then Esc.',
  format_keys = 'Space sk, search format, select the [F]ormat buffer mapping. The answer is format: Space f.',
  request_lab = 'Record :pwd before changing it. Save, run :TutLab 1, then :lcd %:p:h from client.lua. :pwd must end in kickstart-tutorial/lab-1; Space sf should list the three clients.',
  follow_import = 'Space sf: client.py imports build_url from helpers. Open helpers.py; it inserts user_id after /api/v1/users/.',
  browse_siblings = 'One backslash reveals Neo-tree. If it asks to change cwd, approve only the lab-1 folder. client.cpp includes routes.hpp; Ctrl-h returns to the sidebar and one backslash closes it.',
  compare_windows = 'Open client.py, run :vsplit, then open helpers.py in one view. Use Ctrl-h/l to compare; :close removes only that view.',
  project_routes = 'Space sg: search /api/v1/users/. Update routes.lua, helpers.py, and routes.hpp to /api/v2/users/. Save each helper.',
  follow_symbol = 'In a client with an attached server, put the cursor on build_url. K shows its type; grd opens its helper; grr finds callers. Esc twice closes the picker; Ctrl-o retraces the jump.',
  symbol_rename = 'Open the Lua or C++ client and helper first. In the caller: grn on build_url, enter build_user_url. Approve lab edits, inspect, and save both.',
  complete_name = 'Keep the timeout_seconds declaration. In its use, type timeout_, choose timeout_seconds in completion, and accept with Tab.',
  format_client = 'In client.lua, paste local timeout_seconds=12 over its declaration. Space f should add spacing, keeping 12. :ConformInfo reports readiness.',
  fix_diagnostic = 'Misspell only the use in the Python f-string, not the declaration. Space sd should report timeout_secodns as undefined. Restore timeout_seconds.',
  review_baseline = 'From a lab source file, verify :pwd ends in lab-1. Save lab files, then run the three Git commands in the lesson.',
  review_hunk = 'In client.cpp, change only the timeout to 15 (or 16 if already 15) and save. ]c and Space hp show the hunk; Space hd compares with staged content. Close only the read-only comparison window.',
  config_loader = 'Space sn: open init.lua. Plugin declarations use vim.pack.add. Record plugin loader: vim.pack.',
  config_mapping = 'In init.lua, search /SECTION 7: FORMATTING. Find the [F]ormat buffer mapping and Conform format call. Search /format_on_save for the C/C++ exception.',
  help_object = 'Space sh: text-objects. aw includes adjacent whitespace; iw does not. Record delete object: aw.',
  ship_patch = 'In the lab directory, Space sg: timeout_seconds. Set the declarations in client.lua, client.py, and client.cpp to 30; save them and all helpers.',
  restore_search = 'In the original code/workbook window, :lcd - restores its previous directory. Compare :pwd with your section 4 record; if you restarted or changed directories again, use :lcd followed by that recorded path.',
  words = 'On steals in the exercise sentence, press ciw. Type delivers, then Esc. Keep every other word unchanged.',
  quotes = 'Inside the exercise quotes, press ci". Type ship it, then Esc. The quotes and spacing should stay.',
  lines = 'On DELETE THIS LINE inside the exercise, press dd. Leave both keep lines and the marker lines intact.',
  repeat_edit = [[On the first exercise pear, press ciw, type apple, then Esc.
For each remaining line: j moves down, 0 reaches its start, and . repeats the edit.]],
  substitute = [[On dog naps: V selects the line; 2j extends to the other two.
Press :. Keep the added selection marks, type s/dog/cat/g, then Enter.]],
  named_register = [[On treasure: "ayy copies into register a. Press j to reach rubbish.
Use "_dd twice to delete rubbish and empty without replacing the copy.
Press k to return to treasure, then "ap to paste below it.]],
  block_comments = [[On the exercise oak: 0, then Ctrl-v, then 2j selects the first column.
Press I, type // followed by one space, then Esc. Wait for all three lines to update.]],
  macro = [[On red: qq starts recording. Press 0, then I, type item: with a trailing space, then Esc.
Press A, type ;, then Esc. Press j, then 0, then q to stop.
Replay once on blue with @q, then once on gold with @@.]],
  surround_add = 'On parcel: saiw). mini.surround uses ) for tight parentheses, ( for padded ones.',
  surround_replace = 'Inside (cargo): sr)". Replace the parentheses with double quotes.',
  ai_argument = 'On the exercise 42, press cia, type 99, then Esc. The ia target selects only that argument.',
  case = 'On the exercise line, press 0 to reach its start, then gU$ to uppercase through the end.',
}

local retired_chapter_one = {
  modes = true,
  travel = true,
  copy = true,
  words = true,
  quotes = true,
  lines = true,
  search = true,
  repeat_edit = true,
  substitute = true,
  discover = true,
  files = true,
  grep = true,
  tree = true,
  windows = true,
  buffers = true,
  lsp = true,
  rename = true,
  format = true,
  complete = true,
  git = true,
  config = true,
  help = true,
  lap = true,
}

local function lab_directory(chapter) return vim.fn.stdpath 'data' .. '/kickstart-tutorial/' .. (chapter == '1' and 'lab-1' or 'lab') end

local function read_lab_file(name)
  local path = lab_directory '1' .. '/' .. name
  if vim.fn.filereadable(path) == 0 then return nil end
  return table.concat(vim.fn.readfile(path), '\n') .. '\n'
end

local function all_lab_files(names, predicate)
  local complete, valid = true, true
  for _, name in ipairs(names) do
    local content = read_lab_file(name)
    valid = valid and content ~= nil
    complete = complete and content ~= nil and predicate(content)
  end
  return complete, valid
end

local file_checks = {
  project_routes = function()
    return all_lab_files(
      { 'routes.lua', 'helpers.py', 'routes.hpp' },
      function(content) return content:find('/api/v2/users/', 1, true) ~= nil and content:find('/api/v1/users/', 1, true) == nil end
    )
  end,
  symbol_rename = function()
    local valid = false
    for _, pair in ipairs { { 'client.lua', 'routes.lua' }, { 'client.py', 'helpers.py' }, { 'client.cpp', 'routes.hpp' } } do
      local complete, present = all_lab_files(
        pair,
        function(content) return content:find '%f[%w_]build_user_url%f[^%w_]' ~= nil and content:find '%f[%w_]build_url%f[^%w_]' == nil end
      )
      if complete then return true, true end
      valid = valid or present
    end
    return false, valid
  end,
  ship_patch = function()
    local clients, clients_present = all_lab_files({ 'client.lua', 'client.py', 'client.cpp' }, function(content)
      local timeout = content:find 'timeout_seconds%s*=%s*30[%s;]'
      local user = content:find 'build_url%s*%(%s*7%s*%)' or content:find 'build_user_url%s*%(%s*7%s*%)'
      return timeout ~= nil and user ~= nil and content:find('GET ', 1, true) ~= nil and content:find('timeout=', 1, true) ~= nil
    end)
    local routes, routes_present = all_lab_files(
      { 'routes.lua', 'helpers.py', 'routes.hpp' },
      function(content) return content:find('/api/v2/users/', 1, true) ~= nil and content:find('/api/v1/users/', 1, true) == nil end
    )
    return clients and routes, clients_present and routes_present
  end,
}

local function is_graded(id) return targets[id] ~= nil or file_checks[id] ~= nil end

local namespace = vim.api.nvim_create_namespace 'kickstart-tutorial'
local updating = false

local function workbook_path(chapter) return vim.fn.stdpath 'data' .. '/kickstart-tutorial/' .. chapters[chapter].workbook end

local function current_chapter(buffer)
  local name = vim.api.nvim_buf_get_name(buffer or 0)
  for chapter in pairs(chapters) do
    local path = workbook_path(chapter)
    if name == (vim.uv.fs_realpath(path) or path) then return chapter end
  end
end

local function tasks(buffer)
  local lines = vim.api.nvim_buf_get_lines(buffer or 0, 0, -1, false)
  local result = {}
  local section_row = 1
  local lesson_row = 1
  local has_tasks = false
  for index, line in ipairs(lines) do
    if line:match '^## ' then
      section_row, lesson_row, has_tasks = index, index, false
    elseif line:match '^### ' then
      lesson_row = index
    end
    local checked, id, description = line:match '^%- %[(.)%] `([%w_]+)` (.+)$'
    if id then
      local task = {
        id = id,
        row = index,
        section_row = has_tasks and lesson_row or section_row,
        complete = checked == 'x',
        description = description,
        graded = is_graded(id),
      }
      has_tasks = true
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
      elseif file_checks[id] then
        task.complete, task.valid = file_checks[id]()
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

function tutorial.markdown_checks(context, checkbox)
  if not current_chapter(context.buf) then return {} end
  local first_row, _, last_row = context.root:range()
  local marks = {}
  for _, task in ipairs(tasks(context.buf)) do
    local row = task.row - 1
    if task.graded and row >= first_row and row <= last_row then
      local state = task.complete and checkbox.checked or checkbox.unchecked
      table.insert(marks, {
        conceal = 'check_icon',
        start_row = row,
        start_col = 2,
        opts = {
          virt_text = { { state.icon, state.highlight } },
          virt_text_pos = 'overlay',
          hl_mode = 'combine',
          priority = 5000,
        },
      })
    end
  end
  return marks
end

local function render()
  local chapter = current_chapter()
  if updating or not chapter then return end
  vim.api.nvim_buf_clear_namespace(0, namespace, 0, -1)
  local complete, total = 0, 0
  for _, task in ipairs(tasks()) do
    total = total + 1
    if task.complete then complete = complete + 1 end
    local label = task.complete and '  PASS +10 XP' or (task.graded and '  IN PROGRESS' or '  SELF-CHECK')
    if task.complete and not task.graded then label = '  DONE (SELF-MARKED) +10 XP' end
    if task.graded and not task.valid then label = file_checks[task.id] and '  LAB FILES MISSING: :TutLab 1' or '  RESTORE EXERCISE/END MARKERS' end
    if task.graded then
      vim.api.nvim_buf_set_extmark(0, namespace, task.row - 1, 3, {
        virt_text = { { task.complete and 'x' or ' ', task.complete and 'DiagnosticOk' or 'Normal' } },
        virt_text_pos = 'overlay',
        hl_mode = 'replace',
        priority = 0,
      })
    end
    vim.api.nvim_buf_set_extmark(0, namespace, task.row - 1, 0, {
      virt_text = { { label, task.complete and 'DiagnosticOk' or 'DiagnosticInfo' } },
    })
  end
  local rank = complete == total and total > 0 and chapters[chapter].rank or 'CADET'
  vim.api.nvim_buf_set_extmark(0, namespace, 0, 0, {
    virt_text = { { string.format('  CH%s %s | %d/%d | %d XP', chapter, rank, complete, total, complete * 10), 'Title' } },
  })
  local has_renderer, renderer = pcall(require, 'render-markdown')
  if has_renderer and renderer.render then renderer.render { buf = vim.api.nvim_get_current_buf() } end
end

local function is_workbook()
  if current_chapter() then return true end
  vim.notify('Open your workbook with :tut first.', vim.log.levels.WARN)
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
    if task.graded then
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
    vim.notify 'All chapter missions complete! Save with :w. Open another chapter with :tut 1, :tut 2, or :tut 3.'
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
  vim.notify(
    task.id .. ': ' .. (hints[task.id] or (task.description .. '\nFollow the steps below its checkbox. Return there and press Space tm when done.')),
    vim.log.levels.INFO
  )
end

local function attach()
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

local function refresh_intro(source)
  if not vim.bo.modifiable then
    vim.notify('This workbook is not modifiable. Its introduction was left unchanged.', vim.log.levels.WARN)
    return
  end
  local function first_lesson(lines)
    for row, line in ipairs(lines) do
      if line:match '^## 1%. ' then return row end
    end
  end
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local current_start, source_start = first_lesson(lines), first_lesson(source)
  if not current_start or not source_start then
    vim.notify('Could not find section 1. No text was replaced.', vim.log.levels.WARN)
    return
  end
  local introduction = vim.list_slice(source, 1, source_start - 1)
  if table.concat(vim.list_slice(lines, 1, current_start - 1), '\n') ~= table.concat(introduction, '\n') then
    vim.api.nvim_buf_set_lines(0, 0, current_start - 1, false, introduction)
    vim.notify 'Introduction refreshed; exercise edits kept. Save with :w, or undo with u.'
  else
    vim.notify 'Your introduction is already up to date.'
  end
end

local function open(chapter, refresh)
  local path = workbook_path(chapter)
  local source
  if vim.fn.filereadable(path) == 0 or refresh then
    local template = vim.fn.stdpath 'config' .. '/doc/' .. chapters[chapter].template
    if vim.fn.filereadable(template) == 0 then
      vim.notify('Tutorial template not found: ' .. template, vim.log.levels.ERROR)
      return
    end
    source = vim.fn.readfile(template)
  end
  if vim.fn.filereadable(path) == 0 then
    vim.fn.mkdir(vim.fn.fnamemodify(path, ':h'), 'p')
    vim.fn.writefile(source, path)
  end
  if current_chapter() ~= chapter then vim.cmd.edit(vim.fn.fnameescape(path)) end
  if refresh then refresh_intro(source) end
  attach()
end

local function snapshot(lines)
  local state = { checks = {}, blocks = {} }
  local index = 1
  while index <= #lines do
    local checked, id = lines[index]:match '^%- %[(.)%] `([%w_]+)` '
    if id then
      if state.checks[id] ~= nil then return nil, 'Duplicate task: ' .. id .. '. Undo the duplicate before updating.' end
      state.checks[id] = checked == 'x'
    end
    local exercise = lines[index]:match '^<!%-%- exercise:([%w_]+) %-%->$'
    if exercise then
      if state.blocks[exercise] then return nil, 'Duplicate exercise: ' .. exercise end
      local content = {}
      index = index + 1
      while index <= #lines and lines[index] ~= '<!-- end -->' do
        if lines[index]:match '^<!%-%- exercise:' or lines[index]:match '^%- %[(.)%] `([%w_]+)` ' then break end
        table.insert(content, lines[index])
        index = index + 1
      end
      if lines[index] ~= '<!-- end -->' then return nil, 'Restore the end marker for ' .. exercise .. ' before updating.' end
      state.blocks[exercise] = { content = content, last = index }
    end
    index = index + 1
  end
  return state
end

local function update_lessons(args)
  if not is_workbook() then return end
  if not vim.bo.modifiable then
    vim.notify('This workbook is not modifiable. Nothing was updated.', vim.log.levels.WARN)
    return
  end
  local chapter = current_chapter()
  local template = vim.fn.stdpath 'config' .. '/doc/' .. chapters[chapter].template
  if vim.fn.filereadable(template) == 0 then
    vim.notify('Tutorial template not found: ' .. template, vim.log.levels.ERROR)
    return
  end
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local source = vim.fn.readfile(template)
  local previous, previous_error = snapshot(lines)
  local next_state, next_error = snapshot(source)
  if not previous or not next_state then
    vim.notify(previous_error or next_error, vim.log.levels.WARN)
    return
  end
  local has_retired = false
  for id in pairs(previous.checks) do
    if next_state.checks[id] == nil then
      if chapter == '1' and retired_chapter_one[id] then
        has_retired = true
      else
        vim.notify('Unknown task ' .. id .. '. No update was made.', vim.log.levels.WARN)
        return
      end
    end
    if targets[id] and not previous.blocks[id] then
      vim.notify('Restore the exercise marker for ' .. id .. ' before updating.', vim.log.levels.WARN)
      return
    end
  end
  for id in pairs(previous.blocks) do
    if not next_state.blocks[id] then
      if chapter == '1' and retired_chapter_one[id] then
        has_retired = true
      else
        vim.notify('Unknown exercise ' .. id .. '. No update was made.', vim.log.levels.WARN)
        return
      end
    end
  end
  if has_retired and not args.bang then
    vim.notify('Chapter 1 exercises changed. Use :tutupdate! to start the replacement tasks; all old answers and ticks will be backed up.', vim.log.levels.WARN)
    return
  end
  local replacement = {}
  local index = 1
  while index <= #source do
    local line = source[index]
    local checkpoint = line:match '^%- %[[ x]%] `([%w_]+)` '
    if checkpoint then
      local complete = previous.checks[checkpoint]
      if targets[checkpoint] then
        local block = previous.blocks[checkpoint] or next_state.blocks[checkpoint]
        complete = block and table.concat(block.content, '\n') == targets[checkpoint]
      elseif file_checks[checkpoint] then
        complete = file_checks[checkpoint]()
      end
      line = line:gsub('%[(.)%]', complete and '[x]' or '[ ]', 1)
    end
    table.insert(replacement, line)
    local exercise = source[index]:match '^<!%-%- exercise:([%w_]+) %-%->$'
    if exercise then
      local block = previous.blocks[exercise] or next_state.blocks[exercise]
      vim.list_extend(replacement, block.content)
      table.insert(replacement, '<!-- end -->')
      index = next_state.blocks[exercise].last
    end
    index = index + 1
  end
  if table.concat(lines, '\n') == table.concat(replacement, '\n') then
    vim.notify 'Your lessons are already up to date.'
    return
  end
  local directory = vim.fn.stdpath 'data' .. '/kickstart-tutorial/backups'
  local base = directory .. '/' .. chapters[chapter].workbook .. '.' .. vim.fn.strftime '%Y%m%d-%H%M%S'
  local suffix = 1
  local backup = base .. '.' .. suffix .. '.md'
  while vim.uv.fs_stat(backup) do
    suffix = suffix + 1
    backup = base .. '.' .. suffix .. '.md'
  end
  local success, result = pcall(function()
    vim.fn.mkdir(directory, 'p')
    return vim.fn.writefile(lines, backup)
  end)
  if not success or result ~= 0 then
    vim.notify('Could not back up this workbook. No update was made.', vim.log.levels.ERROR)
    return
  end
  vim.api.nvim_buf_set_lines(0, 0, -1, false, replacement)
  render()
  local message = has_retired and 'New Chapter 1 tasks loaded; retired answers/ticks archived.' or 'Lessons updated; current answers and ticks kept.'
  vim.notify(message .. ' Save with :w. Full backup: ' .. backup)
end

local function request_lab_files()
  return {
    ['client.lua'] = {
      "local routes = require 'routes'",
      'local timeout_seconds=5',
      'local url = routes.build_url(7)',
      "print(string.format('GET %s timeout=%ds', url, timeout_seconds))",
    },
    ['routes.lua'] = {
      'local routes = {}',
      '',
      'function routes.build_url(user_id)',
      "  return '/api/v1/users/' .. tostring(user_id)",
      'end',
      '',
      'return routes',
    },
    ['client.py'] = {
      'from helpers import build_url',
      '',
      'timeout_seconds = 5',
      'url = build_url(7)',
      'print(f"GET {url} timeout={timeout_seconds}s")',
    },
    ['helpers.py'] = {
      'def build_url(user_id: int) -> str:',
      '    return f"/api/v1/users/{user_id}"',
    },
    ['client.cpp'] = {
      '#include "routes.hpp"',
      '#include <iostream>',
      '',
      'int main() {',
      '  const int timeout_seconds = 5;',
      '  const std::string url = build_url(7);',
      '  std::cout << "GET " << url << " timeout=" << timeout_seconds << "s\\n";',
      '  return 0;',
      '}',
    },
    ['routes.hpp'] = {
      '#pragma once',
      '#include <string>',
      '',
      'inline std::string build_url(int user_id) {',
      '  return "/api/v1/users/" + std::to_string(user_id);',
      '}',
    },
    ['.luarc.json'] = { '{"runtime":{"version":"LuaJIT"},"workspace":{"checkThirdParty":false}}' },
    ['.stylua.toml'] = { 'indent_type = "Spaces"', 'indent_width = 2', 'quote_style = "AutoPreferSingle"' },
    ['pyproject.toml'] = { '[project]', 'name = "request-lab"', 'version = "0.1.0"' },
    ['compile_flags.txt'] = { '-std=c++17' },
    ['.gitignore'] = { '__pycache__/', 'client' },
  }
end

local function lab(args)
  local chapter = args.args == '' and '3' or args.args
  if chapter ~= '1' and chapter ~= '3' then
    vim.notify('Use :TutLab 1 for the Chapter 1 lab (lab-1), or :TutLab for the Chapter 3 lab (lab).', vim.log.levels.WARN)
    return
  end
  local directory = lab_directory(chapter)
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
  if chapter == '1' then files = request_lab_files() end
  for name, lines in pairs(files) do
    local path = directory .. '/' .. name
    if vim.fn.filereadable(path) == 0 then vim.fn.writefile(lines, path) end
  end
  local entry = chapter == '1' and 'client.lua' or 'main.lua'
  vim.cmd.edit(vim.fn.fnameescape(directory .. '/' .. entry))
  vim.notify('Lab: ' .. directory)
end

function tutorial.setup()
  local options = {
    nargs = '?',
    bang = true,
    complete = function() return { '1', '2', '3' } end,
    desc = 'Open chapter 1, 2, or 3; ! refreshes only its introduction',
  }
  local function open_command(args)
    local chapter = args.args == '' and '1' or args.args
    if not chapters[chapter] then
      vim.notify('Choose :Tut 1 (basics), :Tut 2 (editing), or :Tut 3 (workflow).', vim.log.levels.WARN)
      return
    end
    open(chapter, args.bang)
  end
  vim.api.nvim_create_user_command('KickstartTutorial', open_command, options)
  vim.api.nvim_create_user_command('Tut', open_command, options)
  vim.cmd [[cnoreabbrev <expr> tut getcmdtype() == ':' && getcmdline() ==# 'tut' ? 'Tut' : 'tut']]
  vim.api.nvim_create_user_command('TutUpdate', update_lessons, {
    bang = true,
    desc = 'Update lessons with a full backup; ! also replaces known retired Chapter 1 exercises',
  })
  vim.cmd [[cnoreabbrev <expr> tutupdate getcmdtype() == ':' && getcmdline() ==# 'tutupdate' ? 'TutUpdate' : 'tutupdate']]
  vim.api.nvim_create_user_command('TutLab', lab, {
    nargs = '?',
    complete = function() return { '1', '3' } end,
    desc = 'Open the Chapter 1 mixed-language lab or Chapter 3 Lua lab; preserve existing files',
  })

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
    if is_graded(id) then
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
