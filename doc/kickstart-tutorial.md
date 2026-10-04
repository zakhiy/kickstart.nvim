# Chapter 1: edit, navigate, ship a patch

Sections 1–3: 20–30 minutes. Full chapter: 50–80 minutes.

Workbook keys: Space tn next · Space tp previous · Space ti hint · Space tm mark workflow done.
Edits are checked live; lab checks use saved files. Keep exercise/end markers intact.
Save with `:w`; use Space twice to return to `workbook.md` from another file.

## 1. Recover and extend an edit

Recall: `i/a/o` insert · Esc Normal · `v/V` select characters/lines ·
`u/Ctrl-r` undo/redo · `gg/G` file ends · `0/$` line ends · `w/b/e` words.
`r` replaces one character; `A` inserts at line end.

### Recover a reverted fix

- [ ] `recover_patch` Enable three retries, then verify undo and redo.
  On 0, use `r3`, undo with `u`, then restore with Ctrl-r. Finish at three retries.
<!-- exercise:recover_patch -->
local retries = 0
<!-- end -->

### Add missing cleanup

- [ ] `cleanup` Free buffer after saving, before returning.
  Insert `free(buffer);` between these lines. Use `o` rather than splitting a line.
<!-- exercise:cleanup -->
save_document(buffer);
return 0;
<!-- end -->

### Extend a value

- [ ] `append_path` Build the daily report path.
  Append ` .. "/daily.csv"` to this Lua assignment. Keep the existing string.
<!-- exercise:append_path -->
local path = "reports"
<!-- end -->

## 2. Edit a unit, not a string of characters

An **operator** chooses the action: `c` changes, `d` deletes, `y` copies.
A **text object** chooses the unit: `iw` is a word, `aw` includes adjacent whitespace.
Thus `ciw` replaces a word and enters Insert mode, regardless of your position inside it.

### Fix a setting — guided

Unlike `r`, `c` can change the text's length: replacing 5 with 30 adds a character.

- [ ] `timeout` Give this C++ request a 30-second timeout.
  On 5: `ciw`, type 30, Esc. Keep the declaration and semicolon.
<!-- exercise:timeout -->
const int timeout_seconds = 5;
<!-- end -->

### Change behavior — choose the edit

Python: `json.load` expects an open file; `json.loads` expects JSON text.

- [ ] `parse_call` The payload is JSON text, not an open file. Fix the decoding call.
  Keep the variable, module name, and argument.
<!-- exercise:parse_call -->
response = json.load(payload)
<!-- end -->

### Replace a quoted value

`ci"` combines change (`c`) with inside double quotes (`i"`).
It removes the contents, enters Insert mode, and keeps the quotes.

- [ ] `report_path` Write reports to exports/report.txt.
  Replace only the path value. Don't delete and retype the whole assignment.
<!-- exercise:report_path -->
local output = "tmp debug/report.txt"
<!-- end -->

### Replace arguments together

`ci(` combines change (`c`) with inside parentheses (`i(`).
It removes the arguments, enters Insert mode, and keeps the parentheses.

- [ ] `retry_args` Retry for the actual user and configured timeout.
  Replace the two constants with `user_id, timeout_seconds` in one change.
<!-- exercise:retry_args -->
schedule_retry(0, 5);
<!-- end -->

### Extend a test

`yy` copies a line; `p` pastes it below. Characterwise copies paste after the cursor.

- [ ] `add_test` Add coverage for another log level.
  Keep the ERROR test. Copy it below, then adapt the copy to WARN → warn.
<!-- exercise:add_test -->
assert normalize("ERROR") == "error"
<!-- end -->

### Remove debugging, preserve behavior

`dd` deletes a line. `daw` deletes a word with adjacent whitespace.

- [ ] `remove_debug` Stop printing private response data.
  Remove the debug print; preserve the fetch and return.
<!-- exercise:remove_debug -->
response = fetch_user(user_id)
print(response)
return response
<!-- end -->

### Fix a release note

- [ ] `remove_duplicate` Remove the duplicated word without leaving a double space.
  Choose between `diw` and `daw` before editing.
<!-- exercise:remove_duplicate -->
Ship the the parser fix.
<!-- end -->

## 3. Repeat work without repeating effort

`.` repeats the last **change**, not cursor movements.
A search with `/pattern` is followed by `n/N` for next/previous matches.
`*` searches the word under the cursor; it also jumps to the next match.
Esc clears search highlighting in this config.

### Standardize three settings

- [ ] `timeouts` Set all three Python timeouts to 30.
  Make one word replacement, then reuse it with dot. Don't overwrite the setting names.
<!-- exercise:timeouts -->
connect_timeout = 2
read_timeout = 4
write_timeout = 8
<!-- end -->

### Search, then repeat selectively

- [ ] `log_levels` Promote both connection messages from LOG_DEBUG to LOG_INFO.
  Start on the first LOG_DEBUG call in the exercise, then search for the old name.
  Leave the diagnostic label and connect() call unchanged.
<!-- exercise:log_levels -->
LOG_DEBUG("connected");
connect();
LOG_DEBUG("ready");
const char *diagnostic_label = "LOG_DEBUG";
<!-- end -->

### Replace within a selected range

Select lines with `V`, then `:` supplies the range `'<,'>`.
After that range, `s#old#new#g` replaces every match on those lines.
The separator can be `#` instead of `/`, useful for URLs. `%` addresses the whole file.

- [ ] `secure_urls` Switch the API and health URLs to HTTPS.
  Use one substitution on the first two lines. The legacy mirror must remain HTTP.
<!-- exercise:secure_urls -->
api_url = "http://api.example.test/users"
health_url = "http://api.example.test/health"
mirror_url = "http://archive.example.test/snapshots"
<!-- end -->

### Choose the scope yourself

- [ ] `route_versions` Move both user routes to v2, preserving the historical changelog.
  Choose a range or a sufficiently specific search pattern. Don't replace every v1.
<!-- exercise:route_versions -->
local primary = "v1/users"
local backup = "v1/users"
local changelog = "v1 released"
<!-- end -->

### Resolve a bug report

Python's `requests.get(...)` returns a response. Its `.text` gives a raw string.
Replace `.text` with `.json()` to return parsed JSON; the parentheses call the parser.

- [ ] `repair_parser` Repair this configuration loader.
  Don't log the URL; use a timeout of 30; return parsed JSON rather than raw text.
  Choose the edits yourself. Preserve the function name, parameter, and return structure.
<!-- exercise:repair_parser -->
def load_config(url):
    print("opening", url)
    timeout = 2
    return requests.get(url, timeout=timeout).text
<!-- end -->

## 4. Find the code behind a report

**Telescope** opens search menus called **pickers**. They start in Insert mode:
type to filter, Ctrl-n/Ctrl-p select, Enter opens the selected result.
Esc switches the picker to Normal mode; a second Esc closes it.

Space sk lists key mappings. Pressing Space and pausing opens which-key's shortcut menu.

### Discover a shortcut

- [ ] `format_keys` Search for format with Space sk; find the [F]ormat buffer mapping.
  Write the leader as Space, not <leader>.
<!-- exercise:format_keys -->
format: ?
<!-- end -->

### Create the Chapter 1 lab and choose its search directory

The **Chapter 1 lab** is the directory `kickstart-tutorial/lab-1` under Neovim's data directory.
`:TutLab 1` creates its files and opens `client.lua`; existing files are kept.
It contains three versions of a program that builds a URL and prints a request description.
These programs don't send network requests. Each **client** calls `build_url` in its **helper**:

| Language | Client (calls the function) | Helper (defines the function) |
| --- | --- | --- |
| Lua | client.lua | routes.lua |
| Python | client.py | helpers.py |
| C++ | client.cpp | routes.hpp |

Neovim's **working directory** is the folder printed by `:pwd`. In this config,
Space sf finds filenames under that folder; Space sg searches their **saved contents**
and requires ripgrep (`rg`). They don't automatically detect a project or follow the current file's folder.
Opening a file does not change the working directory.

`:lcd` changes the working directory for the **current window**.
In `:lcd %:p:h`, `%` is the current file, `:p` makes its path absolute,
and `:h` takes its parent folder. From client.lua, that selects lab-1.

- [ ] `request_lab` Make Space sf and Space sg search the Chapter 1 lab's files.
  1. Run `:pwd` and record the original directory for the final restore task.
  2. Save the workbook, then run `:TutLab 1`. You should be in client.lua.
  3. Run `:lcd %:p:h`, then `:pwd`; the path must end in kickstart-tutorial/lab-1.
  4. Open Space sf: client.lua, client.py, and client.cpp should all appear. Close the picker.
  5. Return to workbook.md with Space twice and mark this task with Space tm.

Keep this window's directory set to lab-1 through section 9. After a restart,
open a lab client with `:TutLab 1` and run `:lcd %:p:h` again before using Space sf/sg.

### Follow an import without LSP

- [ ] `follow_import` Locate where the Python client builds its URL.
  Open client.py with Space sf. Its import names a module; the module's file has a .py suffix.
  Open that helper with Space sf. Identify the fixed path prefix and where user_id is appended.

### Use the tree for nearby files

**Neo-tree** is the file sidebar. Press `\` once to reveal the current file in it.
Use j/k to select a file and Enter to open it. Ctrl-h returns from the code window
to the sidebar on the left; `\` in the sidebar closes it without removing file buffers.

The sidebar's **root** is its top displayed folder, separate from `:pwd` in this config.
If reveal asks “File not in cwd. Change cwd to …?”, check the offered path ends in lab-1,
then type y and Enter. This selects the sidebar's folder; it doesn't change the code window's `:pwd`.

- [ ] `browse_siblings` Compare the C++ caller with its header.
  From a lab file, reveal the tree and open client.cpp. Read its quoted #include.
  Return to the sidebar and open the named .hpp file, which defines the URL-building function.
  Locate build_url there. Close the sidebar; both files should remain in Space twice's buffer list.

## 5. Keep context visible

A **buffer** holds a file's text; a **window** displays one buffer.
Closing a window doesn't remove its buffer. Space twice lists open buffers; select a filename to reopen it.
`:vsplit` adds a side-by-side window; `:vsplit helpers.py` opens that file in the new window.
`:split` adds a window below. New windows inherit the source window's working directory.
Ctrl-h/j/k/l switch left/down/up/right. `:close` closes only the current window.

### Compare caller and helper

- [ ] `compare_windows` View client.py and its imported helper side by side.
  Open client.py in the code window, then open helpers.py in a new split.
  Trace the value 7 from the call into the helper's returned URL.
  Close only the helper window; reopen helpers.py with Space twice to verify its buffer remains.

### Patch across files

Each Space sg result identifies its file and line;
Enter opens it. `:w` saves the current file; `:wa` saves all changed file buffers.

- [ ] `project_routes` Migrate all three URL builders from /api/v1/users/ to /api/v2/users/.
  In the lab code window, search /api/v1/users/ with Space sg. Find the three helper files.
  Change only that prefix in each helper and save each file.
  Return to workbook.md with Space twice; this task should show PASS once all three saved helpers use v2.

`:bnext` visits the next buffer; `:bd` removes the current one from the buffer list, not from disk.

## 6. Use language knowledge, not just text matching

**LSP** connects Neovim to a language server that understands a file's code.
An **attached server** has an active connection to the open file: lua_ls for Lua,
pyright for Python, or clangd for C++. Open a lab client, then use `:checkhealth vim.lsp`
to check its connection; `:Mason` shows installation status. Chapter 3, section 2 covers missing servers.
Each server chooses its own analysis folder from files such as .luarc.json or compile_flags.txt;
that folder is separate from the `:pwd` used by Space sf/sg.
Treesitter provides syntax structure/highlighting; it doesn't perform server-aware renames.

### Read before changing

On a symbol: `K` shows documentation/type information; `grd` goes to its definition;
`grr` finds references. Ctrl-o/Ctrl-i traverse jump history in the current window.

- [ ] `follow_symbol` Trace a URL builder from its caller and back.
  In a client with an attached server, put the cursor on build_url in the call.
  Use K and grd; identify its parameter and return type in the helper.
  Inspect references with grr. Close its picker with Esc twice; Ctrl-o retraces the definition jump.

### Rename a symbol, not matching strings

`grn` renames a symbol and its references, potentially across files.

- [ ] `symbol_rename` Rename build_url to build_user_url in one language's client/helper pair.
  Choose the Lua or C++ pair from the section 4 table. Open both files first, then use grn on build_url in the client.
  If Neovim asks to apply changes, inspect the listed files and approve only the lab edits.
  Check the helper definition and client call both use build_user_url; save both, then return for PASS.
  Keep this change. A cross-file undo would require undoing separately in each changed buffer.

### Complete a real name

Blink: Ctrl-Space opens completion; Ctrl-n/Ctrl-p select; Tab accepts.
Typing can also open the menu if the terminal intercepts Ctrl-Space.

- [ ] `complete_name` Restore a setting name using completion rather than retyping it.
  In a client with an attached server, find the output line containing GET.
  Delete timeout_seconds only on that line, type its first few letters, and accept the completion.
  Leave its declaration above unchanged; the output line should be restored exactly.

### Separate formatting from correctness

**Conform** runs formatting with Space f; `:ConformInfo` reports formatter availability.
No external formatters are listed in this config, so Conform uses an attached server that can format.
lua_ls formatting is disabled; the separate stylua server handles Lua using .stylua.toml.
Saving also formats, except C/C++; manual formatting remains available there.

- [ ] `format_client` Format a pasted timeout declaration in client.lua.
  Replace its declaration with `local timeout_seconds=12`, without saving first.
  Use Space f. Spacing should change; 12, the URL call, and the printed message should not.

### Inspect a diagnostic

**Diagnostics** report code problems, not layout. Space sd lists diagnostics from open buffers.
Space q collects only the current file's diagnostics in a **location list** belonging to its window;
`:lopen` opens that list. Use these shortcuts from the source file, not the workbook.

- [ ] `fix_diagnostic` Make the Python server catch a misspelled setting.
  In client.py, temporarily change the output expression's timeout_seconds to timeout_secodns.
  In Space sd, find the client.py report naming timeout_secodns; Esc twice closes the picker.
  Restore timeout_seconds on that line and verify the report clears before saving.

Other server actions: `gra` offers fixes/refactors; `gri` finds interface implementations;
`grt` opens type definitions. `gO` lists named symbols in this file;
`gW` searches symbols across the files the server analyses. Support varies by server.

## 7. Review your own patch with Git

Git records file snapshots as **commits**. A **baseline commit** is the snapshot you'll compare later edits with.
A **hunk** is a group of nearby changed lines in that comparison.
**Gitsigns** marks hunks beside the line numbers; `]c/[c` navigate them and Space hp previews one.

### Establish a lab baseline

The Chapter 1 lab starts without a Git repository. `:!command` runs a shell command from `:pwd`'s directory.
In a lab source file, verify `:pwd` ends in lab-1 before running these commands.
`git init` creates the repository; `git add .` selects its files for the commit;
`git commit` records that selected content. The identity options apply only to this one commit.
If the lab already has a commit, use that baseline instead.

- [ ] `review_baseline` Put the saved lab files under version control for patch review.
  Save the lab files first. Run these commands only in lab-1:
  `:!git init`
  `:!git add .`
  `:!git -c user.name=Tutorial -c user.email=tutorial@example.invalid commit -m "Lab baseline"`

### Catch an unintended change

- [ ] `review_hunk` Review a timeout change before keeping it.
  In client.cpp, set timeout_seconds to 15 and save. If it is already 15, use 16 instead.
  Use ]c and Space hp: the hunk should change the timeout, not the user ID or URL.
  Space hd opens a comparison with Git's staged content, called the index.
  Run `:diffoff!`, then close only the read-only comparison window; keep the client.cpp code window.

Space hs stages a hunk for the next commit. Space hr / hR discard working edits.
Space hb shows line blame. These actions are not needed for this review.

## 8. Locate the right config section and help entry

Space sn searches Neovim config files independently of the project directory.
In init.lua, SECTION headings organize the configuration:

| Sections | Responsibility |
| --- | --- |
| 1–2 | Options, leader keys, mappings, automatic actions |
| 3–4 | Plugin loading, theme, which-key, Gitsigns, mini plugins |
| 5–6 | Telescope, language servers, Mason |
| 7–8 | Conform, Blink, LuaSnip |
| 9–10 | Treesitter, optional/custom modules |

### Identify the actual plugin loader

- [ ] `config_loader` Find the API that installs plugins in init.lua.
  Open init.lua with Space sn and find a call ending in .add that adds plugin repositories.
  Record the API name before .add, not a plugin's name.
<!-- exercise:config_loader -->
plugin loader: ?
<!-- end -->

### Find the source of a key

- [ ] `config_mapping` Locate the implementation behind the formatting shortcut.
  In init.lua's SECTION 7: FORMATTING, find the Space f mapping, labelled [F]ormat buffer.
  Follow its callback to Conform's format call.
  Find where save-time formatting is configured and identify the C/C++ exception.
  Independent additions load from lua/custom/plugins/; don't edit the lab to change your config.

### Use help to choose an edit

Space sh searches help topics. Help opens a separate window; `:close` closes that window.
Ctrl-o retraces jumps; it does not switch windows.

- [ ] `help_object` A review asks to remove a word and its neighboring whitespace.
  Find text-objects in help; compare iw and aw. Record only the target, without the delete operator.
<!-- exercise:help_object -->
delete object: ?
<!-- end -->

## 9. Ship the same fix across languages

- [ ] `ship_patch` Bug report: every client needs a 30-second timeout.
  Return to a lab client. Check `:pwd` ends in lab-1; Space sn didn't change it.
  Find the timeout_seconds declarations with Space sg, not Space sn.
  Set all three clients to 30; preserve the user ID, output, and migrated route prefix.
  Save all three clients and helpers. Return to workbook.md for PASS; the check reads those saved files.
  Inspect the client.cpp hunk: it should now change the timeout to 30.

### Restore the search directory

- [ ] `restore_search` Restore the working directory from before the lab.
  Back in the original code/workbook window, `:lcd -` returns to its previous directory.
  Run it once, then `:pwd`; compare with the path recorded in section 4.
  If you changed directories more than once or restarted, use `:lcd` followed by that original path instead.
  Escape any spaces in the path with a backslash.

## Recap

| Problem | Tool |
| --- | --- |
| Recover / extend an edit | u/Ctrl-r; o opens a line; A inserts at line end |
| Edit a unit; keep surrounding syntax | operator + object: ciw, ci", ci(, daw |
| Extend a similar case | yy/p, then targeted edits |
| Repeat one change | .; search with n to find the next target |
| Bulk replacement without collateral edits | selection + :s; choose range and pattern |
| Find a file / text / open buffer / shortcut | Space sf / sg / Space twice / sk |
| Choose the file/text search directory | :pwd shows it; :lcd %:p:h uses this file's parent |
| Compare files without losing either | split; Ctrl-h/j/k/l; :close |
| Follow or rename a code symbol | K, grd, grr, grn with an attached server |
| Complete / format / inspect a problem | Ctrl-Space + Tab / Space f / Space sd |
| Review your patch before staging | ]c, Space hp, Space hd |
| Find setup / documentation | Space sn / Space sh; :close exits the help window |

`:w` saves this workbook. `:tut` resumes it; `:tut 2` opens power editing.
`:tutupdate` refreshes wording and backs up old text; `:tutupdate!` replaces retired
Chapter 1 drills with this curriculum, archiving their answers and ticks in that backup.
Personal notes outside current exercises remain in the backup.
`:echo expand('%:p')` prints the saved workbook's path for sharing.
