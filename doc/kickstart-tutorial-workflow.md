# Chapter 3: build your working cockpit

Open with :Tut 3. Prerequisites: Chapter 1's files/windows and basic code editing.
Plan roughly 60–100 minutes for the main sections, excluding installation delays.
Optional linting/debugging may need another session. Estimates are not measured.
This chapter teaches configured tools AND how to diagnose missing ones. It does
not silently install plugins, enable optional modules, change init.lua, or run Git.

## Flight controls + safety

Space tn/tp navigates; ti hints; tm self-marks; tc reports the chapter's checks.
All missions here are SELF-ASSESSED: there is no fake automatic tooling score.
10 XP per completed task; ENGINEER is a long-term goal, not permission to proceed.
Read first, try the task, return to chapter-3.md, then Space tm on its checkbox.
Save before leaving any workbook with :w. :Tut 1/2/3 opens another saved chapter.
Your Chapter 1 and 2 edits stay separate. Esc means the actual Escape key.
Keep optional missions unchecked until prerequisites exist; don't install tools
you don't need just to earn points. Downloads are deliberate, not tutorial actions.

## 1. A disposable project, not your production code

:TutLab creates a small Lua project under Neovim's data directory and opens main.lua.
It includes helper.lua, .luarc.json, .stylua.toml, and lint-demo.md. Existing files are NEVER
overwritten. There is deliberately uneven Lua spacing and a malformed Markdown
heading for later exercises. This folder is NOT initially a Git repository.
Opening the lab does not change your working directory or install anything.
While main.lua is current, :lcd %:p:h sets this window's directory to the lab.
Use :pwd to verify. For later shell/Git commands, verify the directory again!
Return with Space Space, selecting chapter-3.md, or :Tut 3 after saving your code.
Record your original :pwd now so you can restore it with :lcd /your/original/path.

- [ ] `lab` Save this workbook, run :TutLab, inspect main.lua/helper.lua, then return.

## 2. LSP: install ≠ configure ≠ attach

A server is an executable. Mason installs it; nvim-lspconfig supplies defaults;
vim.lsp.config adds overrides; vim.lsp.enable starts it for matching files/roots.
Your servers table already enables clangd, gopls, pyright, ts_ls, stylua, and lua_ls.
lua_ls is the Neovim config name; lua-language-server is its Mason package name.
This config's mason-lspconfig automatic_enable is false: merely installing some
other server in :Mason does NOT enable it. Add it to the servers table if needed.
Mason may download configured tools on startup; this tutorial does not trigger
additional installations. Don't repeatedly reinstall a tool before diagnosing it.

In lab/main.lua: :set filetype? should say lua. :checkhealth vim.lsp shows clients.
:lua vim.print(vim.lsp.get_clients({ bufnr = 0 })) lists clients for THIS buffer.
No client? Check :Mason (g? explains its keys), :messages, and :LspLog; verify
filetype, server executable, configuration, and root. The lab's .luarc.json helps
lua_ls identify the project. If needed, deliberately install lua-language-server
using :MasonInstall lua-language-server, then restart Neovim and reopen the lab.
The lab helper module should resolve from the project root; inspect its client
root if grd or grr gives surprising results. Do not run Lua project code to get LSP.

- [ ] `attach` Identify the lab buffer's attached client and its project root.
- [ ] `lsp_loop` On greet in helper.greet, try K, grd, grr, and Ctrl-o to retrace the jump.
- [ ] `project_rename` Use grn on greet to rename it salute; inspect BOTH lab files, then undo in BOTH.
A workspace rename edits multiple buffers; one u in one file is not a global undo.
Inspect and :w each restored file before continuing. Leave tasks unchecked if no
server attaches; the remaining terminal/config-reading sections can still be done.

## 3. Formatting and diagnostics have different owners

Space f calls Conform. :ConformInfo reports external formatters and availability.
Here formatters_by_ft is empty and lsp_format='fallback', so Conform currently
relies on attached servers that support formatting. lua_ls formatting is disabled
explicitly; the configured stylua LSP can provide it if it attaches successfully.
The lab's .stylua.toml gives StyLua a project root and explicit formatting options.
Installing an executable does not populate Conform's formatters_by_ft table.
To choose external StyLua deliberately, add lua = { 'stylua' } inside that table
in init.lua. Check :Mason for the stylua package, restart, then inspect :ConformInfo.
This is optional; do not edit the config if your current formatting works.
Formatting also runs on save except for C/C++; their save-time formatting is
disabled in this config, while manual Space f remains available.

- [ ] `formatter` In main.lua, format its uneven settings line; inspect what changed.
- [ ] `diagnostic` Add a reference to an unknown global in lab/main.lua, inspect Space sd, then undo it.
Formatting rearranges text; diagnostics describe problems. A linter can produce
diagnostics too, but a formatting tool needn't diagnose missing names.
Return to this workbook before marking. Keep the source files saved/restored.

## 4. Snippets: create one before expecting a library

LuaSnip is installed; Blink uses snippets={preset='luasnip'}. Friendly-snippets
and its VS Code loader are COMMENTED OUT, so don't assume a big snippet library.
For a reversible, session-only experiment, while main.lua is open, execute:

:lua require('luasnip').add_snippets('lua', { require('luasnip').parser.parse_snippet('greetdemo', 'print("Hello, ${1:pilot}")$0') })

On a new blank line, enter Insert mode and type greetdemo. Ctrl-Space opens the
menu; Ctrl-n/p chooses the snippet; Tab accepts. Replace pilot with your name.
Tab moves forward through placeholders, Shift-Tab backward; $0 is the final stop.
Tab can also accept another completion while a snippet is active: hide an unwanted
menu with Ctrl-e before jumping. Terminal Ctrl-Space interception? Let typing
open the menu, or inspect :help blink-cmp-config-keymap.
Delete your experiment afterwards if desired. Restart clears this session snippet.
To keep it, place the registration code in a new lua/custom/plugins/snippets.lua
file WITHOUT the :lua prefix: the existing loader runs it after LuaSnip/Blink
setup. No new plugin needed.

- [ ] `snippet` Register greetdemo, expand it, replace the placeholder, and reach the final stop.

## 5. Location list vs quickfix: two different queues

Space q fills the CURRENT WINDOW's diagnostic location list. :lopen displays it;
:lnext/:lprevious move through it; :lclose closes its view.
Quickfix is a separate shared result queue. :copen shows it; :cnext/:cprevious
navigates it; :cclose closes it. Populating one does not populate the other.
Save lab files first. In main.lua, :lcd %:p:h, then run:

:vimgrep /TODO/j *.lua
:copen

This searches lab Lua files with Neovim's built-in search, not ripgrep. j fills
the list without jumping immediately. Enter on a result opens it; :cnext visits
the next result. Use :cfirst if you're at the end. The lab starts with two TODOs.
Do NOT use :cdo to replace across everything until you've inspected the queue.

- [ ] `quickfix` Populate TODO quickfix results, visit both files, close the result window.
- [ ] `location` In a source window with a diagnostic, Space q then :lopen; explain why :copen differs.
If no diagnostic remains, deliberately create and undo one as in section 3.

## 6. Terminal workflows: the shell lives in a buffer

In a lab source window, :split then :terminal opens your shell in another window.
Press i to send keystrokes to the shell. Your config maps Esc Esc to leave
Terminal mode; Ctrl-\ then Ctrl-n is the built-in alternative.
Only after leaving Terminal mode do Ctrl-h/j/k/l navigate editor windows.
Your tmux navigator may move into a tmux pane when you hit an editor edge.
Press i to return to the shell. Run pwd, then printf 'lab ready\n' as harmless tests.
Use exit to end that shell. :close closes its view; :bd removes the stopped buffer.
Closing a window is not the same as stopping a running process. Don't launch an
untrusted command just because you're inside the practice project.

- [ ] `terminal` Print lab ready, leave Terminal mode, switch windows, then exit the shell.

## 7. Git: make review a queue, staging a deliberate act

OPTIONAL prerequisite: a disposable Git repository. You can use an existing one
or deliberately create one in the LAB ONLY. This tutorial never initializes it.
If creating one, save lab files, open a terminal, verify pwd is the lab directory,
then git init, git add ., and git commit -m "Tutorial lab baseline".
Use your existing Git identity; if it isn't configured, skip this mission rather
than changing global settings just to finish the course.
After the baseline, change and save a greeting in helper.lua. ]c/[c navigate,
Space hp previews, Space hs stages the current hunk, and Space hd compares with
the index. :diffoff closes diff MODE; :close closes an extra diff window.
In the terminal, git diff and git diff --cached distinguish unstaged and staged.
There is no Space hu mapping in this config. To unstage the practice file while
keeping its working edit, use git restore --staged -- helper.lua in the lab shell.
Space hq puts this file's hunks in quickfix; Space hQ collects repository hunks.
Space hr/hR discards working edits: avoid those keys unless you intend that.

- [ ] `stage_review` Stage a LAB hunk, inspect git diff --cached, then unstage without deleting it.
- [ ] `git_queue` Collect lab hunks with Space hQ and inspect :copen; then close the queue.

## 8. Extend the config without cargo-culting a video

Independent lua/custom/plugins/*.lua files load automatically. Their order is
unspecified: keep dependent setup together. Do not require one from init.lua too,
or you may run its setup twice. Your plugin manager is vim.pack, NOT Lazy.
vim.pack.add { 'https://github.com/OWNER/REPO' } installs/loads a plugin; only then
call its documented setup function. The module name needn't equal the repo name.
Never paste or source code you haven't inspected. Restart after changes rather
than sourcing all of init.lua repeatedly (it can recreate setup/side effects).

No-download customization exercise: create lua/custom/plugins/practice.lua with:

```lua
vim.keymap.set('n', '<leader>uP', function()
  vim.notify(vim.fn.expand '%:p')
end, { desc = 'Practice: show current file path' })
```

First use Space sk to check that Space uP isn't already mapped. Restart, test it,
then remove the practice file and restart if you don't want to keep the mapping.
Track desired changes with Git; review the diff before committing.
The lockfile is nvim-pack-lock.json. :help vim.pack explains updates/rollback.
:lua vim.pack.update() downloads updates and shows a confirmation buffer; :w
there confirms, :q discards. Read :help vim.pack before actually updating.
No update is required for this course. Avoid changing many plugins at once.

- [ ] `custom_map` Add, test, and optionally remove the practice mapping using the custom loader.
- [ ] `pack_read` Locate vim.pack.add and nvim-pack-lock.json; read update confirmation help without updating.

## 9. Optional linting and debugging: opt in with prerequisites

These modules are present but disabled in init.lua. Don't press their mappings
and assume they work; choose tools for a language you actually use.
Read lua/kickstart/plugins/lint.lua: it installs nvim-lint when enabled, but
expects the Markdown linter executable to be installed separately. To opt in,
deliberately install markdownlint (e.g. :MasonInstall markdownlint), uncomment
require 'kickstart.plugins.lint' in init.lua, and restart. Open lab/lint-demo.md.
The malformed #Lint demo heading should produce a missing-space diagnostic.
The module tries linting on BufEnter, BufWritePost, and InsertLeave. Fix it to
# Lint demo, save, inspect diagnostics. Return; leave this unchecked if disabled.
Linting also runs on workbook Markdown: use Space q and :lopen from lint-demo.md
to inspect that source buffer's diagnostics rather than every open workbook's.

- [ ] `lint` If enabled, observe the lab heading diagnostic and fix it; otherwise defer.

Read lua/kickstart/plugins/debug.lua: this example is Go-specific, not a universal
Python/JavaScript debugger. It configures DAP, dap-ui, dap-go, and Delve. Opt in by
uncommenting require 'kickstart.plugins.debug' and restarting ONLY if you want Go
debugging. Prerequisites: Go, a working Go project, and Delve installed/available.
For a disposable Go project, make a new folder, run go mod init tutorial.local/demo,
and create main.go containing:

```go
package main

import "fmt"

func main() {
    visits := 1
    visits++
    fmt.Println(visits)
}
```

Open that file from the Go project. Space b toggles a breakpoint on visits++;
F5 starts/continues (choose Debug if prompted); F2 steps over; F1 steps into;
F3 steps out; F7 toggles the UI. macOS may require Fn for actual function keys.
Inspect visits in the UI before/after stepping; :lua require('dap').terminate()
stops the session. Keep ordinary test runs separate from debugger runs.
If startup fails, inspect :messages and :help dap; don't toggle more plugins at
random. Another language needs its OWN adapter and launch configuration.

- [ ] `debug` If Go debugging is enabled, hit the breakpoint, inspect visits, step, terminate.

## Graduation: close the loop, not every optional checkbox

- [ ] `workflow_lap` Open the lab, inspect a symbol, edit, format, inspect results, save, and review your diff if using Git.
- [ ] `restore_directory` Restore the original window directory recorded in section 1; verify :pwd.

Save :w. Share chapter-3.md for review (:echo expand('%:p') reveals its path).
Keep optional tasks unchecked when deferred. ENGINEER rank isn't a requirement
for daily productivity; a reliable edit → inspect → save habit is the real reward.
