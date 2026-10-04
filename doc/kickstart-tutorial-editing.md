# Chapter 2: power editing — fewer keystrokes, better habits

Open with `:tut 2` after Chapter 1's modes, operators, selections, and undo.
45–75 minutes. Seven challenges check edited text live; Space tm marks the other tasks.

## Controls

Space tn continues, Space ti hints, and `:w` saves. Start each sequence with Esc
unless the steps say to remain in Insert or Visual mode.
Edit between exercise/end markers, leaving the markers intact. PASS means the text matches the goal.
This chapter saves in `chapter-2.md`; Space twice lists buffers when you need to return from another file.

## 1. Registers: keep useful text in a named pocket

A **register** stores copied text or a recorded sequence of commands.
Choosing a named register protects that text from later ordinary copies/deletes.
The prefix `"a` selects register a for the next operation:

- `"ayy` copies a whole line into register a.
- `"ap` pastes that stored line below the current one.
- `:registers a` displays what's currently stored there.

Ordinary deletes also put text in registers. The prefix `"_` selects the
**black-hole register**, which throws text away without replacing useful copies.
For example, `"_dd` deletes a line while preserving register a and the clipboard.
This task overwrites register a; choose another letter if it contains something
you need. Use that replacement letter consistently in the steps.

- [ ] `named_register` Keep treasure and replace the unwanted lines with a second treasure.
  1. On the first exercise line, press `"ayy` to store treasure.
  2. Press `j` to reach rubbish, then `"_dd` to delete that line.
  3. The cursor is now on empty. Press `"_dd` again to delete it.
  4. Press `k` to return to treasure, then `"ap` to paste below it.
  5. Only two treasure lines should remain inside the exercise markers.
<!-- exercise:named_register -->
treasure
rubbish
empty
<!-- end -->

### Inspect a register

The yank register, `0`, keeps the latest ordinary copy. To inspect several
registers at once, give their names to `:registers`.
If you used another letter instead of a, use it in the command below too.

- [ ] `register_inspect` Inspect the copied text without pasting it.
  1. Run `:registers a 0`. Find the stored treasure in register a.
  2. Notice that the registers may contain different text; they aren't one clipboard.

### Copy outside Neovim

The `+` register is the system clipboard. After selecting text, `"+y` copies
it there; `"+p` pastes it back. This config sets `clipboard=unnamedplus`, so
ordinary copies and deletes can affect the system clipboard too.
Clipboard support depends on the OS/terminal. If it fails, the report opened by
`:checkhealth vim.provider` can help. Skip this task if no provider is ready.

- [ ] `clipboard` Copy a harmless word into another application.
  1. On a word, press `viw` to select it, then `"+y` to copy it.
  2. Paste into a harmless text field outside Neovim and check the text.
  3. Return to this workbook before marking the task.

For later: in Insert mode, Ctrl-r then a inserts register a. Uppercase `"A`
appends to a instead of replacing it; for example, `"Ayy` adds another line.

## 2. Visual blocks: make the same column edit on several lines

Visual mode has three selection shapes: `v` selects characters, `V` selects
whole lines, and Ctrl-v selects a rectangle. In that rectangle, `I` inserts
text at the left edge of every selected line.
You type on the first line; Esc applies the change to the rest. If your terminal
intercepts Ctrl-v, Ctrl-q is Neovim's alternative for starting block selection.

- [ ] `block_comments` Add // and one space before each tree name.
  1. Put the cursor on oak and press `0` to reach column one.
  2. Press Ctrl-v, then `2j`, to select the first column across three lines.
  3. Press uppercase `I`, type `// ` (including its trailing space), then Esc.
  4. All three lines should now have the same prefix.
<!-- exercise:block_comments -->
oak
elm
ash
<!-- end -->

### Reselect without editing

After a selection ends, `gv` selects that same area again. While selecting,
`o` moves the cursor to its other end, letting you adjust the opposite edge.

- [ ] `reselect` Inspect your previous rectangle without changing the text.
  1. Press `gv` after the block edit. The old selection should return.
  2. Press `o` and watch the cursor change ends. Esc cancels the selection.

For later: uppercase `A` appends text at the right edge of a Visual block.

## 3. Macros: record a repeatable edit sequence

A **macro** records keystrokes, including movements and edits. Dot repeats
one change; a macro can repeat a whole sequence.
The sequence `qq` starts recording in register q; a single `q` stops it.
The sequence `@q` replays that recording; `@@` replays the last macro again.
This overwrites q. Choose another letter consistently if you need its contents.

The recording will add a prefix and suffix, then move to the next line. That final
movement matters: replay must begin on a fresh line, not the line just edited.
The first result should be `item: red;`; the color stays lowercase.

- [ ] `macro` Turn the three colors into inventory records.
  1. On red, press `qq` to start recording. Press `0` to reach line start.
  2. Press `I`, type `item: ` with its trailing space, then Esc.
  3. Press `A`, type `;`, then Esc to add the suffix.
  4. Press `j`, then `0`, to reach the next line. Press `q` to stop recording.
  5. On blue, press `@q`. Inspect the result before continuing.
  6. On gold, press `@@`. All three lines should now have the same format.
<!-- exercise:macro -->
red
blue
gold
<!-- end -->

### Read the recording

The command `:registers q` shows the recorded keystrokes.
Replace q with your chosen letter if you recorded into a different register.

- [ ] `macro_inspect` Inspect the recording and explain its final movement.
  1. Run `:registers q`. Locate the final `j0` sequence.
  2. Explain to yourself why the next replay needs the cursor on the next line.

A count can repeat a macro: `2@q` runs it twice. Don't use large counts in a
workbook; they can run past the exercise and edit its markers or instructions.

## 4. mini.surround: add or replace matching wrappers

The already-enabled mini.surround plugin changes pairs such as quotes and brackets.
For the word edit below, combine its **add** action `sa`, the text object `iw`, and a wrapper character.
For example, `saiw)` adds tight parentheses around the inner word.
The closing bracket `)` produces `(word)`; the opening bracket `(` produces `( word )`.

- [ ] `surround_add` Wrap parcel in tight parentheses.
  1. Move onto parcel in the exercise, not in the instructions.
  2. Press `saiw)`: add (`sa`), inside word (`iw`), tight parentheses (`)`).
  3. You should see `(parcel)`, without spaces inside the parentheses.
<!-- exercise:surround_add -->
parcel
<!-- end -->

### Replace a wrapper

The **replace** action is `sr`, followed by the old and new wrapper characters.
For example, `sr)"` replaces enclosing parentheses with double quotes.

- [ ] `surround_replace` Replace cargo's parentheses with double quotes.
  1. Put the cursor inside `(cargo)`.
  2. Press `sr)"`. The result should be `"cargo"`, without parentheses.
<!-- exercise:surround_replace -->
(cargo)
<!-- end -->

For later: `sd"` deletes surrounding double quotes. These are mini.surround's
keys, not vim-surround's `ys` / `ds` / `cs`. More examples are in `:help mini.surround`.

## 5. mini.ai: select an argument, not the whole expression

The already-enabled mini.ai plugin adds text objects. Its `ia` object selects
inside a function argument, excluding its separator and outer spaces.
Combine it with `c` to change just that argument: `cia`.
In the exercise, `42` is the second argument. Commas inside the nested table
don't split that table into additional outer arguments.

- [ ] `ai_argument` Replace 42 with 99 without changing the rest of the call.
  1. Put the cursor on 42 in the exercise.
  2. Press `cia`, type `99`, then Esc.
  3. The quotes, table, commas, and spacing should remain intact.
<!-- exercise:ai_argument -->
paint("red", 42, { x = 1, y = 2 })
<!-- end -->

### Select a whole call

The `af` object selects a whole function **call**, not a function definition body.
Combine it with `v` to inspect the selection without changing anything.

- [ ] `call_object` Select the whole paint call, then cancel.
  1. On that expression, press `vaf`. Inspect what is highlighted.
  2. Press Esc without typing a replacement or deleting anything.

For later: `iq` selects inside quotes without naming their type. Start inside
the intended object: mini.ai can look nearby if nothing covers the cursor.
Read `:help mini.ai` before trying its advanced next-object selections; this
config uses `aa` / `ii` as their prefixes rather than the defaults `an` / `in`.

## 6. Case and substitutions: scope a powerful edit

The operator `gU` uppercases text covered by a movement. Thus `gU$` uppercases
from the cursor to line end; `0` first puts the cursor at line start.

- [ ] `case` Uppercase the entire launch message.
  1. Move onto the exercise line. Press `0`, then `gU$`.
  2. You should see READY FOR LAUNCH, with its spaces unchanged.
<!-- exercise:case -->
ready for launch
<!-- end -->

### Confirm each replacement

A substitution's `c` flag asks before replacing each match. At the prompt,
`y` accepts, `n` skips, and `q` stops. We'll deliberately skip this replacement.
As in Chapter 1, select a line first to keep the command out of the rest of the file.

- [ ] `confirm` Inspect a proposed replacement and decline it.
  1. On the launch line, press `V` to select only that line, then `:`.
  2. Keep the supplied `'<,'>` range; append `s/LAUNCH/ORBIT/gc` and press Enter.
  3. Press `n` at the prompt. The text should still say READY FOR LAUNCH.

For later: `gu` lowercases, and `~` flips one character's case. A substitution's
`a` response accepts all remaining matches. Avoid `:%s` on the workbook:
the percent sign means the entire file, not your small exercise.

## Recap: choose the smallest tool that works

Use an operator for one edit, dot for one repeated change, a macro for a repeated
sequence, and a Visual block for a column edit. Surround is useful for wrappers;
a scoped, confirmed substitution is useful for delicate bulk changes.

Save the workbook, then use `:enew` to create an unnamed practice buffer for the next task.
Add a few lines there, not inside the workbook's exercise markers.

- [ ] `editing_lap` Combine three skills in that practice buffer.
  1. Store a useful line in a named register and paste it after another edit.
  2. Record and replay a short macro. Inspect one replay before repeating it.
  3. Add a prefix to several lines with a Visual block and inspect the changed lines.
  4. Return to chapter-2.md with Space twice and mark the task there. The practice buffer needn't be saved.

Save with `:w`. To share this workbook, `:echo expand('%:p')` prints its path.
Space tp goes back; Space tc checks manually. `:tut! 2` refreshes only the intro.
For all rewritten lessons, use `:tutupdate`: it keeps answers and ticks, makes
a backup, and replaces lesson prose. Personal notes outside exercises stay in the backup.
Next, `:tut 3` uses a separate Lua lab for language tooling and workflow.
