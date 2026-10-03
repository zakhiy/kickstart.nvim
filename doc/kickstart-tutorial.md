# Kickstart: from passenger to pilot

Chapter 1: an interactive workbook for THIS config, not an old video.
Do sections 1–4 first (about 20 minutes); return for the rest.
Allow 45–75 minutes for the full chapter, excluding tool setup.
Accuracy before speed. Arrow keys are allowed. Learn a few keys at a time.
This covers everyday Kickstart workflows, not every plugin or Vim feature.

## Your cockpit

Open with :KickstartTutorial. This creates a personal copy in Neovim's
data directory; the template stays untouched. No notes directory is required.
Markdown rendering is disabled only in this workbook so markers stay visible.
:w saves edits AND progress. Reopen with :KickstartTutorial to resume.
Live badges grade editing blocks as you type; the header tracks XP and rank.
Each completed mission earns 10 XP. Complete all missions to become PILOT.
Space tn / :TutorialNext jumps to the next unfinished mission (wraps around).
When entering a new section it stops at the lesson heading: read the explanation,
then press Space tn again to reach the first unfinished mission in that section.
Space tp / :TutorialPrevious goes to the previous mission, including passed ones.
Space ti / :TutorialHint gives a hint for the mission at or above your cursor.
Space tc / :TutorialCheck grades the five editing blocks and updates their boxes.
Space tm / :TutorialMark self-marks the current workflow mission.
Automatic checks also update checkboxes on :w. Live badges don't change your
text or undo history; keep practicing with u and Ctrl-r as usual.
:TutorialMark discover marks a self-assessed task (replace discover with its ID).
You can also put the cursor on a checkbox's space and type rx to mark it.
To unmark a task, put the cursor on its x and type r followed by Space.
Checkpoints are not exams: automatic checks assess results, not keystrokes.
Workflow missions remain self-assessed, not secretly tracked or auto-verified.
Keep the exercise/end markers intact and edit only the lines between them.
First-time route: read a section, try its missions in order, then go to the next.
Use Space tm on a workflow checkbox AFTER returning from its project exercise.

Notation: Space sf means press Space, then s, then f; Ctrl-h means hold Ctrl
and press h. Esc returns to Normal mode. Type colon commands, then Enter.
Commands/key sequences below start in Normal mode unless stated otherwise.

## 1. Escape room: modes, movement, recovery

Normal mode is your control panel; Insert mode types text; Visual mode selects.
i inserts before the cursor; a after it; A at line end; o opens a line below.
Esc returns to Normal. v selects characters, V selects lines.
h/j/k/l move left/down/up/right. w/b move by word; e goes to a word's end.
0/$ go to line start/end; gg/G go to file start/end. Counts multiply: 3w, 5j.
u undoes; Ctrl-r redoes. :w saves; :q closes; :q! discards unsaved changes.
Don't quit this workbook before saving progress. :help opens built-in docs.

- [ ] `modes` Type a small note here with o, Esc, undo it with u, redo with Ctrl-r.
- [ ] `travel` Reach the bottom with G and return with gg, then try 3w on a sentence.
After returning to the top, Space tn returns you to unfinished missions.

## 2. Word surgery: operators + objects

Think VERB + TARGET: d deletes, c changes (then Insert mode), y copies.
iw is inside a word; aw includes surrounding whitespace; i" is inside quotes.
ciw replaces a word, diw deletes it, yiw copies it. p pastes after the cursor.
dd deletes a line; yy copies it. Dot (.) repeats your last change.
Put the cursor on the actual exercise text below each exercise marker, not the
instructions. Hints assume your cursor is in that block. Use h/j/k/l to get there.

- [ ] `copy` On this line, press yy then p to duplicate it, then u to undo the copy.

Mission: replace steals with delivers, without rewriting the sentence.
Hint: move onto steals in the sentence with h/l; ciw, type delivers, Esc.
- [ ] `words` Deliver the coffee instead of stealing it.
<!-- exercise:words -->
The quick brown fox steals coffee.
<!-- end -->

Mission: replace only the text inside the quotes with ship it.
Hint: move inside the quotes with h/l, then ci" and type the replacement, Esc.
- [ ] `quotes` Ship the release; preserve the quotes and spacing.
<!-- exercise:quotes -->
message = "not ready"
<!-- end -->

Mission: remove just the middle line. Hint: cursor on that line, dd.
- [ ] `lines` Defuse the extra line.
<!-- exercise:lines -->
keep this line
DELETE THIS LINE
keep this one too
<!-- end -->

## 3. Search + repeat: stop holding movement keys

/text Enter searches forward; ?text Enter searches backward. n/N repeat.
* searches the word under the cursor. Esc clears search highlights here.
f followed by a character jumps to it on this line; ; repeats that jump.
% jumps between matching brackets. Ctrl-o returns to an earlier jump;
Ctrl-i goes forward. These are your navigation breadcrumbs.

- [ ] `search` Search /pear, press n until you reach the exercise block, then Esc.
Search also matches instructions: inspect the destination before editing!

Mission: change pear to apple on all three lines, using one edit plus dot.
Hint: on the first pear, ciwapple then Esc; j0. then j0.
- [ ] `repeat_edit` Harvest three apples with one change and two repeats.
<!-- exercise:repeat_edit -->
pear green
pear blue
pear gold
<!-- end -->

Mission: turn dog into cat ONLY in these three lines.
Hint: V, select three lines with 2j, then :s/dog/cat/g and Enter.
Visual selection inserts '<,'> automatically after the colon.
Don't use %s here: % addresses the entire workbook, including instructions!
- [ ] `substitute` Transform the whole pack with a range-limited substitution.
<!-- exercise:substitute -->
dog naps
dog runs
dog wins
<!-- end -->

Run :TutorialCheck now. Fix any unchecked blocks; :w to keep your score.

## 4. Find things: your everyday project loop

:pwd shows the working directory. Start nvim from your project root for search.
This workbook lives outside your project; opening it doesn't change :pwd.
Save with :w before leaving the workbook, or file switching may refuse unsaved
changes. Return with Space Space, select workbook.md, and press Enter.
Space sf finds files; Space sg searches project text (requires ripgrep).
Space sw searches the word under your cursor. Space / searches this buffer.
Space Space lists open buffers; Space s. lists recent files.
Space sn finds config files, regardless of your current project directory.
In Telescope: type to filter, Ctrl-n/Ctrl-p select, Enter opens, Esc closes.
Press Space and pause for which-key hints; Space sk searches actual mappings.
Neo-tree: TWO backslashes reveal the tree in this config; Enter opens a file.
Inside the tree, TWO backslashes close it. It is not a single-backslash toggle.

- [ ] `discover` Use Space sk to find the mapping for Format buffer.
- [ ] `files` Use Space sn to open init.lua; return with Space Space.
- [ ] `grep` In init.lua, run :lcd %:p:h, then Space sg and search mapleader; return.
Here :lcd sets THIS window's working directory to init.lua's parent directory.
Run it only while init.lua is current, not while reading the workbook.
- [ ] `tree` Reveal Neo-tree, open a file, then close the tree.

## 5. Buffers aren't windows

A buffer holds a file. A window displays a buffer. Two windows can show one file.
:vsplit opens a side-by-side window; :split opens one below.
Ctrl-h/j/k/l moves between windows. :close closes a window, not the file.
:bnext cycles buffers; Space Space is often easier. :bd removes a buffer
from the buffer list (save first). :wa saves all changed file buffers.

- [ ] `windows` :vsplit this workbook, move with Ctrl-h/l, then :close one view.
- [ ] `buffers` Switch between init.lua and this workbook without reopening either.

## 6. Code intelligence: jump, understand, change

Use a real source file in a project, not this Markdown workbook.
Prerequisite: a language server must be attached to that source buffer.
:checkhealth vim.lsp lists clients; if none attach, leave these tasks unchecked
and move on. Server installation is reserved for Chapter 2, not a failure here.
Try a disposable copy/project file so you don't risk important source code.
LSP is the language server: it understands symbols, references, and errors.
Treesitter handles syntax structure/highlighting; it isn't the language server.
With an attached server: K shows hover docs; grd goes to definition;
grr finds references; gri implementations; grt type definitions.
grn renames a symbol; gra offers code actions. Available results depend on server.
gO lists document symbols; gW workspace symbols. Ctrl-o jumps back.
Space sd searches diagnostics. Space q populates the LOCATION list;
:lopen displays it; :lnext/:lprevious navigate. This is NOT :copen's quickfix list.
Space f formats via Conform; availability depends on formatter/server setup.
Completion uses blink.cmp with the super-tab preset, not the old nvim-cmp setup.
In Insert mode: Ctrl-Space opens completion; Ctrl-n/p selects; Ctrl-e hides it.
Tab accepts the selection in your super-tab preset (also used for snippet jumps).
If your terminal intercepts Ctrl-Space, let typing trigger the completion menu.
:checkhealth vim.lsp and :ConformInfo help when features aren't working.

- [ ] `lsp` Hover a symbol, jump to its definition, and jump back in your project.
- [ ] `rename` Rename a disposable local variable with grn; inspect changes, undo.
- [ ] `format` Format a disposable source file with Space f and inspect the result.
- [ ] `complete` In Insert mode, trigger completion, select a suggestion, accept with Tab.
No formatter available? Leave format unchecked and continue; :ConformInfo tells
you which tools are available. Return to the workbook and mark only completed tasks.

## 7. Git radar: inspect before acting

In a tracked file with unstaged changes, Gitsigns marks changes in the gutter.
Prerequisite: open a file inside a Git repository that already has changes.
No suitable file? Leave git unchecked and return later; don't alter files just
to earn points. :pwd/search uses a directory; Git uses the file's repository.
]c/[c navigate hunks; Space hp previews; Space hb shows blame.
Space hs stages a hunk: this CHANGES the Git index; it doesn't commit.
Space hr resets a hunk and Space hR resets the buffer: these DISCARD edits.
Skip reset keys while learning. Preview is your safe first habit.
Git exercises are self-assessed; this tutorial never runs Git operations.

- [ ] `git` On an existing changed tracked file, navigate and preview a hunk.
Return to the workbook before marking this task with Space tm.

## 8. Read the config like a map

init.lua is divided into SECTION headings. Search /^-- SECTION to tour them.
Section 1: leaders and options. Section 2: core keymaps and autocommands.
Plugin infrastructure: vim.pack.add installs plugins (not Lazy in this config).
Small plugins: which-key, Gitsigns, theme, mini modules.
Telescope: find files/text and LSP pickers.
LSP/Mason: language servers and buffer-specific mappings.
Conform: formatting. Blink/LuaSnip: completion and snippets.
Treesitter: parsers and syntax. Optional examples: extra plugin modules.
lua/custom/plugins/*.lua loads automatically; use it for independent additions.
This workbook's commands live in lua/custom/tutorial.lua, loaded by that folder.
Don't paste an old video's plugin spec blindly: match the local loading style.

- [ ] `config` Find the leader assignment and formatting mapping in init.lua.
- [ ] `help` Use Space sh to find text-objects; read :help iw and return with :close.
Help opens another window: :close closes the help view; Ctrl-h/j/k/l switches
windows. Ctrl-o retraces jumps in the current window, not between windows.

## Graduation: a five-minute real-world lap

Open a project file → find a symbol → inspect its docs → make one ciw edit →
repeat a change with dot → format → inspect the diff → save.
No need to memorize everything. Search mappings and help whenever you're stuck.

- [ ] `lap` Finish the lap in a real project. Mark only what you've actually tried.
If a server/formatter isn't available, skip that step and keep its earlier task
unchecked. Revisit those tasks later; PILOT rank is a long-term goal, not a gate.

For later review, share your saved workbook and ask for feedback on unchecked
tasks. Checked workflow tasks mean self-reported completion, not automated proof.
Run :echo expand('%:p') to find the saved file to attach or paste for review.

## Chapter 2: advanced missions (planned, not yet implemented)

Later: registers and clipboard, macros, advanced Visual mode, terminal workflows,
snippets and mini plugins, installing servers/formatters, and plugin customization.
Optional debugging and linting will follow when those plugins are enabled.
