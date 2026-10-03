# Chapter 2: power editing — fewer keystrokes, better habits

Open with :tut 2. Prerequisite: Chapter 1's modes, operators, objects, and undo.
Plan roughly 45–75 minutes, excluding extra practice; this is not a timed course.
Seven editing challenges have live checks. Other tasks are self-assessed.
Your Chapter 1 progress stays in its own file; this chapter saves as chapter-2.md.

## Flight controls

The controls are the same: Space tn to continue, Space ti for a hint, :w to save.
Read each lesson before trying its missions. Press Esc before a Normal-mode command.
Edit inside the exercise markers; leave the markers themselves alone.
Checkboxes and PASS badges follow your result live; :w saves the ticks to the file.
PASS checks your result, not your technique. For other tasks, Space tm is your
"I tried this" check-in. Complete the chapter to earn ACE — no rush.

## 1. Registers: named pockets, not one fragile clipboard

A register stores text or recorded commands. "a selects register a for the next
operation: "ayy copies a line into a; "ap pastes it. :registers shows contents.
Deleting normally also changes registers. "_dd deletes into the black hole,
preserving your useful text. "0p pastes the latest yank from the yank register.
In Insert mode, Ctrl-r then a inserts register a without leaving Insert mode.
Uppercase register names append: "Ayy adds to a rather than replacing it.

This config sets clipboard=unnamedplus: ordinary yanks/deletes may affect the
system clipboard too. "+y explicitly copies a selection there; "+p pastes it.
Clipboard providers depend on the OS/terminal. :checkhealth vim.provider helps
if it fails. Use named registers for editing tasks, not the system clipboard.
Registers a and q will be overwritten in this chapter; choose other letters if
you have saved something important there. Workbook progress does not save macros.

Mission: keep treasure, remove rubbish and empty, and paste a second treasure.
Hint, starting on treasure: "ayy, j"_dd, "_dd, k to return to treasure, then "ap.
- [ ] `named_register` Protect the treasure in a named register.
<!-- exercise:named_register -->
treasure
rubbish
empty
<!-- end -->

- [ ] `register_inspect` Run :registers a 0 and identify the line you copied.
- [ ] `clipboard` Copy a harmless word with viw"+y, paste outside Neovim, then return.
If your provider isn't available, leave clipboard unchecked and continue.

## 2. Visual mode: paint a rectangle, not a thousand edits

v selects characters; V selects lines; Ctrl-v selects a rectangle.
o swaps the selection's active end; gv reselects the previous selection.
In a block selection, I inserts at its left edge; A appends at its right edge.
Type on the first line, then Esc: the edit is applied to all selected lines.
Use Normal-mode 0 to begin at column one, not the first nonblank character.
If your terminal intercepts Ctrl-v, try Ctrl-q (Neovim's block-mode alternative).

Mission: add // and ONE space at the start of each tree line.
Hint: cursor on oak; 0, Ctrl-v, 2j, I, type // and a space, Esc.
- [ ] `block_comments` Comment the entire grove with one rectangular edit.
<!-- exercise:block_comments -->
oak
elm
ash
<!-- end -->

- [ ] `reselect` Use gv on that block, press o to move its active end, then Esc.

## 3. Macros: teach the editor one lap

qq starts recording into q; q stops recording; @q replays; @@ replays the last
macro. 2@q runs it twice. :registers q reveals the recorded keystrokes.
Dot repeats one change; a macro replays a sequence of movements AND changes.
Record repeatable motions (0, $, w), not "move right exactly nine times".
Start on a known line and end on the NEXT line. Replay once before using a count.
Large counts can escape your selection and damage markers: don't use them here.

Mission: wrap each color as item: COLOR; without changing the color's case.
On red, record qq0Iitem: <Esc>A;<Esc>j0q. You finish on blue.
Run @q once on blue; inspect it, then @@ on gold. Or use 2@q on blue after
you understand why two repetitions stay inside the three-line exercise.
Esc notation means press the actual Escape key, not type the characters <Esc>.
- [ ] `macro` Build three inventory records using one recorded lap.
<!-- exercise:macro -->
red
blue
gold
<!-- end -->

- [ ] `macro_inspect` Inspect :registers q and explain why j0 belongs at the end.

## 4. mini.surround: wrap, unwrap, swap

This plugin is already enabled in init.lua; it is not vim-surround's ys/ds/cs.
sa adds a surrounding to an operator target: saiw) wraps the inner word.
Closing bracket ) makes tight (word); opening bracket ( makes padded ( word ).
sd" removes double quotes; sr)" replaces parentheses with double quotes.
Keep the cursor inside the intended surrounding, not in the instructions.
:help mini.surround documents more targets, including tags and function calls.

Mission: wrap parcel in tight parentheses (no interior spaces).
- [ ] `surround_add` Pack the parcel with saiw).
<!-- exercise:surround_add -->
parcel
<!-- end -->

Mission: replace the parentheses around cargo with double quotes.
- [ ] `surround_replace` Swap the packaging with sr)".
<!-- exercise:surround_replace -->
(cargo)
<!-- end -->

## 5. mini.ai: arguments and calls are text objects too

mini.ai extends targets for c/d/y/v. ia means inside an argument; aa includes
its separator. iq selects inside quotes without naming the quote character.
af selects a function CALL, such as paint(...), not a function definition body.
Nested commas in tables don't count as separate outer arguments here.
This config uses aa/ii for next-object mappings, avoiding newer Neovim's an/in.
Start inside the desired object: the plugin may search nearby if nothing covers
your cursor. Always inspect a Visual selection before deleting it.

Mission: replace just the second argument 42 with 99, preserving everything else.
Hint: on 42, cia99 then Esc. You are changing ia, not the entire function call.
- [ ] `ai_argument` Tune one argument without breaking the nested table.
<!-- exercise:ai_argument -->
paint("red", 42, { x = 1, y = 2 })
<!-- end -->

- [ ] `call_object` On that expression, vaf to inspect the selected call; Esc cancels.

## 6. Case + confirmed substitutions: powerful, but scoped

gU uppercases a motion/selection; gu lowercases; ~ flips a character's case.
0gU$ uppercases this line from column one through the end.
A Visual-line range limits :s to selected lines. The g flag affects every match
on each line; c asks for confirmation (y yes, n no, q stop, a all remaining).
% means the entire file. Never use it on a workbook full of instructions.

Mission: uppercase the whole launch message.
- [ ] `case` Broadcast the launch message with 0gU$.
<!-- exercise:case -->
ready for launch
<!-- end -->

- [ ] `confirm` Select that one line with V, run :s/LAUNCH/ORBIT/gc, answer n, then Esc.
The line should remain unchanged. Confirmation lets you inspect before acting.

## Graduation: choose the smallest tool that works

Single edit → operator + object. Repeated change → dot. Repeated sequence → macro.
Column edits → Visual block. Structural wrappers → surround. Delicate bulk edits
→ scoped substitution with confirmation. Use u when the result isn't what you meant.

- [ ] `editing_lap` In a disposable note, combine a named register, a macro, and a block edit.

Save with :w. Share this saved file for review (:echo expand('%:p') shows its path).
Space tp goes back and Space tc checks manually. :tut! 2 refreshes only the intro
above section 1, replacing any personal notes there while keeping exercise edits.
Next: :tut 3 for a practice project, language tooling, snippets, terminal workflows,
quickfix, Git review, plugin customization, and optional linting/debugging.
