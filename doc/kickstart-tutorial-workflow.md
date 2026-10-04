# Chapter 3: connect tools to an editing workflow

Open with `:tut 3` after Chapter 1's files, windows, and basic editing.
60–100 minutes, excluding tool installation and optional linting/debugging.

## Controls

Space tn continues, Space ti hints, and `:w` saves. These tasks happen across
files and tools, so their results aren't automatically graded.
Return to chapter-3.md with Space twice and use Space tm after verifying a task's result.

## 1. Create the Chapter 3 lab and set its search directory

The **Chapter 3 lab** is `kickstart-tutorial/lab` under Neovim's data directory,
not Chapter 1's lab-1 directory. `:TutLab` (or `:TutLab 3`) creates its files and opens `main.lua`.
Existing files are kept. It starts without a Git repository.

| Lab file | What it's for |
| --- | --- |
| main.lua | Calls helper.greet with a name, then prints the greeting |
| helper.lua | Defines helper.greet, which returns the greeting string |
| .luarc.json | Marks the Lua language server's analysis directory |
| .stylua.toml | Marks the StyLua server's formatting directory and sets its style |
| lint-demo.md | A deliberately incorrect heading for optional linting |

Neovim's **working directory** is the folder printed by `:pwd`.
Space sf finds files under it; Space sg searches saved file contents under it and requires ripgrep (`rg`).
Opening a file doesn't change it or automatically select a project folder.
`:lcd` changes it for this window.
In `:lcd %:p:h`, `%` is the current file, `:p` makes its path absolute, and `:h`
takes the parent folder. From main.lua, that means the lab directory.
Set it to the Chapter 3 lab for its file searches. Record the old path before changing it.

- [ ] `lab` Open the lab, set its search folder, and inspect its files.
  1. In this workbook, run `:pwd` and note the full path somewhere safe.
  2. Save with `:w`, then run `:TutLab`. You should see main.lua.
  3. With main.lua current, run `:lcd %:p:h`, then `:pwd`; expect a path ending in kickstart-tutorial/lab.
  4. Use Space sf to open helper.lua and inspect its greeting function.
  5. Use Space twice to return to `chapter-3.md`. Mark this task there.

After a restart or a directory change, run `:TutLab`, then `:lcd %:p:h` from main.lua before lab searches.
Space twice lists open buffers. In its picker, Esc enters Normal mode; another Esc closes it.

## 2. Language servers: installed, configured, attached

A language server understands code; an **attached client** is Neovim's active
connection to that server for a file. These are three separate steps:

1. **Install:** Mason downloads the server program.
2. **Configure:** nvim-lspconfig supplies defaults, and `vim.lsp.config` adds overrides.
3. **Enable:** `vim.lsp.enable` starts it for appropriate file types and analysis directories.

The config's servers table already enables clangd, gopls, pyright, ts_ls,
stylua, and lua_ls. The Neovim name `lua_ls` corresponds to Mason's package
`lua-language-server`. Names aren't always identical across the two tools.
Mason may install configured tools on startup. Installing another server manually
won't enable it here: `automatic_enable` is false, so it needs configuration too.

### Check this file's connection

The command `:set filetype?` reports the current file's type. The health report
`:checkhealth vim.lsp` describes language-server connections. For an exact list
attached to the current buffer, this Lua command prints the clients:

```vim
:lua vim.print(vim.lsp.get_clients({ bufnr = 0 }))
```

Here `bufnr = 0` means the current buffer, not every open file. Each client uses
`root_dir` as its code-analysis directory, selected from marker files such as .luarc.json.
This is independent of `:pwd`: changing a search directory with `:lcd` does not set an LSP root.
For lua_ls in this lab, root_dir should end in kickstart-tutorial/lab.

- [ ] `attach` Identify main.lua's language server and analysis directory.
  1. Open main.lua with `:TutLab`. Run `:set filetype?`; expect `lua`.
  2. Print the clients using the command above, or open the LSP health report.
  3. Look for lua_ls with root_dir ending in kickstart-tutorial/lab. Close any health window with `:close`.
  4. Return to the workbook and mark the task only if a client attached.

If nothing attaches, check `:Mason` for installation status (`g?` opens its help).
The command `:messages` shows editor messages; `:LspLog` opens the server log.
Check the filetype, executable, enabled configuration, and root before reinstalling.
If the Lua server is missing and you want it, `:MasonInstall lua-language-server`
downloads it. Restart afterwards and reopen the lab. Otherwise, defer the LSP tasks.
You do not need to run the Lua program to get code intelligence.

### Navigate a symbol

With the cursor on a symbol, `K` opens documentation, `grd` opens its definition,
and `grr` finds references. Ctrl-o retraces earlier jumps in the current window.

- [ ] `lsp_loop` Follow the greeting function from caller to definition and back.
  1. In main.lua, put the cursor on `greet` in `helper.greet`, not on `greeting`.
  2. Try `K`, then `grd`. You should reach the function in helper.lua.
  3. Use `grr` to inspect references. Esc twice closes its picker.
  4. Use Ctrl-o to retrace the jump, then return to the workbook.

### Rename across files, then restore both

The rename action `grn` asks the server to change a symbol and its references.
A rename may change several buffers: one `u` in one file doesn't undo edits in the others.
Inspect every changed file before continuing.

- [ ] `project_rename` Rename greet to salute in the lab, then undo the experiment.
  1. Open main.lua and helper.lua first. On greet in main.lua's helper.greet call, use grn and enter salute.
  2. If asked to apply changes, inspect the listed paths and approve only these two lab files.
  3. Check that the call in main.lua and definition in helper.lua both use salute.
  4. Undo in each changed buffer. Check that both use greet again, then save each.
  5. Return to the workbook.

## 3. Formatting and diagnostics do different jobs

**Formatting** changes layout, such as spacing. **Diagnostics** report problems,
such as an unknown variable. Fixing spacing doesn't necessarily fix a code error.

Space f asks Conform to format the current file. `:ConformInfo` reports available
external formatters. Here its `formatters_by_ft` table is empty, so Conform falls
back to an attached server that can format. lua_ls formatting is disabled;
the configured stylua server can provide it. The lab's .stylua.toml supplies its root.
Formatting also runs when you save, except that save-time formatting is disabled
for C/C++ in this config. Manual Space f is still available for those languages.

- [ ] `formatter` Format a pasted settings declaration in main.lua.
  1. Replace only its settings line with `local settings={name="pilot",visits=1}`. Don't save yet.
  2. Press Space f and wait for the result. Spacing should become consistent.
  3. If nothing happens, inspect `:ConformInfo` and attached clients before repeating.
  4. Save the result and return to the workbook.

If you prefer an external formatter instead of LSP fallback, optionally put
`lua = { 'stylua' }` inside Conform's `formatters_by_ft` table in init.lua.
Make sure the stylua package is installed in Mason, then restart and inspect
`:ConformInfo`. Installing a tool alone doesn't populate that table.
No config change is needed if formatting already works.

### Inspect a temporary error

Space sd opens the diagnostic picker. Reports can take a moment to update after
an edit. We'll make a harmless error in the lab, inspect it, then remove it.

- [ ] `diagnostic` Observe a code error and clear it.
  1. In main.lua, add a new line: `print(missing_name)`. Don't run this program.
  2. Return to Normal mode, wait for analysis, then press Space sd.
  3. Find main.lua's unknown-global report about missing_name. Esc twice closes the picker.
  4. Undo the added line, save, and confirm its report disappears. Return here.

## 4. Snippets: expand a template with editable placeholders

A **snippet** inserts a template and lets you jump through its editable fields.
LuaSnip handles those fields; Blink supplies completion. This config has both,
but its friendly-snippets library is commented out, so we will add one ourselves.

The following session-only registration creates a trigger called `greetdemo`.
Its `${1:pilot}` field starts with pilot selected for replacement; `$0` is the
final cursor stop. Restarting clears this temporary registration.

```vim
:lua require('luasnip').add_snippets('lua', { require('luasnip').parser.parse_snippet('greetdemo', 'print("Hello, ${1:pilot}")$0') })
```

In Insert mode, Ctrl-Space opens completion and Ctrl-n / Ctrl-p chooses a result.
Tab accepts it. For an expanded snippet, Tab moves forward through fields and
Shift-Tab moves backward. If another completion menu appears, Ctrl-e closes it
before you jump. If the terminal intercepts Ctrl-Space, let typing open the menu.

- [ ] `snippet` Expand a greeting template and fill in its name field.
  1. Open main.lua. Run the registration command above once.
  2. On a blank line, enter Insert mode and type `greetdemo`.
  3. Open completion, choose the snippet, and press Tab.
  4. Replace the selected pilot with your name. Press Tab to reach the final stop.
  5. Press Esc, inspect the line, and delete it if you don't want to keep it.
  6. Save your code before returning to the workbook.

To keep the registration, place its Lua code in `lua/custom/plugins/snippets.lua`
without the `:lua` prefix. That loader runs after LuaSnip/Blink setup.

## 5. Two result lists: location list and quickfix

A **location list** belongs to one window. Space q fills that window's list with
diagnostics for its current buffer; `:lopen` shows it and `:lclose` closes it.
A **quickfix list** is a separate, shared queue. `:copen` shows it and `:cclose`
closes its view. Filling one list doesn't fill the other.

We'll put both lab TODO comments in quickfix using Neovim's built-in search.
The command `:vimgrep /TODO/j *.lua` searches for TODO in the Lua files in the
working directory. `*.lua` means files ending in .lua; `j` queues the results
without jumping immediately. This command doesn't depend on ripgrep.
In quickfix, Enter visits the selected result. `:cnext` visits the next one;
`:cfirst` restarts at the first when you're already at the end.

- [ ] `quickfix` Collect and visit the lab's two TODO comments.
  1. Save lab files. In main.lua, run `:pwd` and confirm it is the lab folder.
  2. If the folder changed, reset it from main.lua with `:lcd %:p:h` as in section 1.
  3. Run `:vimgrep /TODO/j *.lua`, then `:copen`.
  4. Visit the first result with Enter, then use `:cnext` to visit the other source file.
  5. Close the quickfix window with `:cclose`, then return to the workbook.

### Inspect this window's diagnostics

For the next task, a diagnostic must exist. You can temporarily add
`print(missing_name)` to main.lua as in section 3, then remove it afterwards.
Run the location-list shortcut from the source window, not from this workbook.

- [ ] `location` Display a source file's diagnostics in its window-specific list.
  1. In the source window with a diagnostic, press Space q, then run `:lopen`.
  2. Inspect the entries. This is a different list from your TODO quickfix queue.
  3. Close it with `:lclose`. Remove the test error, save, and return here.

For later: `:lnext` / `:lprevious` navigate the location list; `:cprevious` goes
back in quickfix. Don't run bulk-edit commands over either queue until you inspect it.

## 6. Terminal workflows: a shell inside an editor window

A terminal buffer runs a shell. Its **Terminal mode** sends keystrokes to that
shell; Normal mode lets you navigate its output and editor windows.
The command `:terminal` opens it. In this config, Esc twice leaves Terminal mode;
Control-backslash followed by Ctrl-n is the built-in alternative.
Use `i` to send keystrokes to the shell again. Window keys work after you leave
Terminal mode, not while the shell is consuming them.

- [ ] `terminal` Print a message, switch windows, then stop the shell cleanly.
  1. From a lab source window, run `:split` to make a second window, then `:terminal`.
  2. Press `i`. In the shell, type `pwd` and Enter; verify it is the lab directory.
  3. Type `printf 'lab ready\n'` and Enter. You should see lab ready.
  4. Press Esc twice, then Ctrl-h / Ctrl-j / Ctrl-k / Ctrl-l to switch windows.
  5. Return to the terminal, press `i`, then type `exit` and Enter to stop the shell.
  6. Close its view with `:close` and return to the workbook.

Closing a window doesn't stop its shell. After exit, `:bd` removes the terminal buffer.
If you run Neovim inside tmux, Ctrl-h/j/k/l can cross into a tmux pane at an editor edge.

## 7. Git: review first, stage deliberately

This section uses the Chapter 3 lab as a Git repository.
A **baseline commit** records a file snapshot to compare later changes with.
If the lab has no commit yet, save its files, open main.lua, and run `:lcd %:p:h`.
Check `:pwd` ends in kickstart-tutorial/lab. `:!` runs each shell command below from that directory.
`git init` creates the repository, `git add .` selects files for the commit, and `git commit` records them.
The name/email options apply only to this commit; they don't change your global Git identity.

```vim
:!git init
:!git add .
:!git -c user.name=Tutorial -c user.email=tutorial@example.invalid commit -m "Tutorial lab baseline"
```

Gitsigns groups changed lines into hunks. `]c` / `[c` move between them and Space hp
previews one. Space hs stages a hunk. Git's **index** is the staging area for the
next commit; staging changes that area, not the working file.
From a lab file, `:!git diff` shows unstaged changes; `:!git diff --cached` shows staged ones.
`:!git restore --staged -- helper.lua` removes helper.lua from the index's
changes while keeping its working edits. There is no Space hu mapping here.

- [ ] `stage_review` Stage a lab hunk, review it, and unstage without deleting the edit.
  1. After the baseline, change the greeting string returned by helper.greet in helper.lua and save it.
  2. Visit its hunk with `]c`, preview with Space hp, then stage with Space hs.
  3. From helper.lua, run `:!git diff --cached` and inspect the staged greeting change.
  4. Run `:!git restore --staged -- helper.lua`, then `:!git diff`; the greeting edit should still appear.
  5. Return to the workbook; no new commit is needed for this task.

### Queue repository changes

Space hQ collects repository hunks in quickfix; Space hq collects only this file's.

- [ ] `git_queue` Inspect repository changes as a result queue.
  1. In a changed lab source file, press Space hQ, then run `:copen`.
  2. Inspect or visit a hunk, then close the queue with `:cclose`.
  3. Return to the workbook before marking the task.

Space hr / Space hR discard working edits. Space hd compares with the index;
`:diffoff!` exits diff mode in all windows. Close only the read-only comparison window with `:close`.

## 8. Extend the config with a small, reversible addition

The loader runs independent files in `lua/custom/plugins/` automatically.
Their order isn't guaranteed: keep dependent setup together. Don't also require
an automatically loaded file from init.lua, which could run its setup twice.
Restart after config changes rather than sourcing all of init.lua repeatedly.

A **mapping** assigns an action to a key sequence. Space sn lists Neovim config files independently of `:pwd`.
The following Lua code maps
Space uP to displaying the current file's full path; `<leader>` means Space here.
First check the existing mappings with Space sk to make sure Space uP is free.
The new file belongs in your Neovim config, not inside the lab directory.
The command `:edit` opens a file, or starts a new one if that path doesn't exist.
Relative paths start in the working directory, so we'll set it to the config first.
Use another unused filename if practice.lua already exists; don't overwrite existing config.

```lua
vim.keymap.set('n', '<leader>uP', function()
  vim.notify(vim.fn.expand '%:p')
end, { desc = 'Practice: show current file path' })
```

- [ ] `custom_map` Add and test the practice mapping without installing a plugin.
  1. Check Space uP is free. Save, then open init.lua with Space sn.
  2. From init.lua, run `:lcd %:p:h`, then `:edit lua/custom/plugins/practice.lua`.
  3. Put the Lua code above in the new file and save. Restart Neovim to load it.
  4. Open any file and press Space uP. It should display that file's full path.
  5. If you don't want the mapping, remove the practice file and restart again.
  6. Reopen `:tut 3` and mark the task. Review config changes before committing them.

### Read the plugin update procedure before using it

Your plugin manager is `vim.pack`, not Lazy. Its `vim.pack.add` calls install/load
plugins before their setup functions run. The file `nvim-pack-lock.json` records
plugin revisions so you can review what changed.
The update procedure is documented in `:help vim.pack`: `:lua vim.pack.update()`
downloads changes and opens a confirmation buffer. In THAT buffer, `:w` accepts
updates and `:q` discards them. You do not need to run an update for this course.

- [ ] `pack_read` Find the plugin declarations and read how updates are confirmed.
  1. Open init.lua and locate a `vim.pack.add` call. Find nvim-pack-lock.json too.
  2. Run `:help vim.pack` and read the update/rollback explanation.
  3. Close help with `:close`. Do not update plugins just to mark this task.

For a future plugin, use its documented URL and setup API, not a placeholder
copied from a video. Its Lua module name may differ from its repository name.

## 9. Optional linting and debugging: know what you're enabling

These modules are present but disabled. You don't need either for the earlier
chapters. Choose them only if they fit a language or workflow you use.

### Lint a Markdown heading

A **linter** reports style or code problems as diagnostics. The optional
`lua/kickstart/plugins/lint.lua` module loads nvim-lint, but its configured
Markdown linter, markdownlint, must be installed separately.
If you opt in, `:MasonInstall markdownlint` downloads that tool. In init.lua,
uncomment `require 'kickstart.plugins.lint'`, then restart to enable the module.
It runs on file entry, after saving, and after leaving Insert mode.
The lab heading `#Lint demo` lacks a space; a normal Markdown heading is `# Lint demo`.

- [ ] `lint` Observe and fix the lab's heading diagnostic, if you enabled linting.
  1. Run `:TutLab`, then `:lcd %:p:h` from main.lua. Use Space sf to open lint-demo.md.
  2. Wait for its missing-space report.
  3. Inspect current-file reports using Space q, then `:lopen`; close with `:lclose`.
  4. Add the space after #, save, and verify that report disappears. Return to chapter-3.md.

The linter also sees Markdown workbooks. Inspect from the lab source window to
avoid confusing its reports with reports about instructional prose.

### Debug a small Go program

A **debugger** pauses a running program so you can inspect values and step through
instructions. This optional example is Go-specific, not a universal debugger.
The module `lua/kickstart/plugins/debug.lua` configures DAP (the debug protocol),
its UI, dap-go, and the Go debugger Delve. Read it before enabling it.
Prerequisites are Go, a working Go project, and Delve installed/available. If you
choose this workflow, uncomment `require 'kickstart.plugins.debug'` and restart.

For a disposable Go project, create a separate folder and open a shell there.
The shell command `go mod init tutorial.local/demo` writes go.mod, marking that folder
as a Go module. Then create main.go beside go.mod with this complete program:

```go
package main

import "fmt"

func main() {
    visits := 1
    visits++
    fmt.Println(visits)
}
```

A **breakpoint** pauses before a chosen line runs. Space b toggles one.
F5 starts/continues debugging; F2 steps over one instruction; F1 steps into a call;
F3 steps out of a function; F7 shows/hides the debugger UI. On macOS you may need Fn.
The command `:lua require('dap').terminate()` stops a debug session.

- [ ] `debug` Pause before incrementing visits, inspect it, and step once.
  1. Open main.go from the folder containing go.mod. Put the cursor on visits++ and press Space b.
  2. Press F5; choose Debug if prompted. The program should pause at that line.
  3. Inspect visits in the debugger UI: it should be 1 before the increment.
  4. Press F2. Inspect visits again: it should now be 2.
  5. Stop with `:lua require('dap').terminate()`, then return to this workbook.

If startup fails, inspect `:messages` and `:help dap` rather than enabling more
plugins at random. Another programming language needs its own adapter and launch setup.

## Recap: edit, inspect, save

- [ ] `workflow_lap` Complete a small lab edit and inspect the result before saving.
  1. Reopen the Chapter 3 lab with `:TutLab`; set its directory with `:lcd %:p:h` if needed.
  2. In main.lua, inspect a symbol and change the name in its settings table.
  3. Format if available, inspect the result, and save.
  4. Review the change with `:!git diff` if you created the baseline commit. Return here to mark the task.

### Restore the search folder

The lab changed this window's search folder in section 1. To restore it, give
`:lcd` the original full path you recorded. For example, `:lcd /Users/you/project`
is only an example: replace that path with your recorded directory, not the lab.
If the path contains spaces, escape each space with a backslash.

- [ ] `restore_directory` Restore your original search folder.
  1. Run `:lcd` followed by your recorded path. Press Enter.
  2. Run `:pwd` and check that it prints the original folder.

Save with `:w`. `:echo expand('%:p')` prints this workbook's path for sharing.
Space tp goes back; `:tut 1`, `:tut 2`, and `:tut 3` switch chapters after saving.
For updated lesson wording, `:tutupdate` preserves exercise answers and ticks,
backs up the old workbook, and replaces prose. Personal notes remain in the backup.
