Huge thanks to MasterHowToLearn, who wrote the [original SuperMemoVim](https://github.com/MasterHowToLearn/SuperMemoVim), which this version is based on.

# SuperMemoVim: The keyboard SuperMemo experience

Disclaimer: I have been simultaneously developing and using this script since January 2022. Nothing happened to my collection so far, but I can't guarantee the same thing for the future. Please make sure you have proper backup strategy in place.

You need AutoHotkey for this. Double click SuperMemoVim.ahk, and you shall see a new icon popping up on your taskbar.

Please add your scripts in lib\\bind\\personal.ahk so you can update easily. See the comments in the file for tips for writing your own scripts.

# Modes

You can see which mode you are in via the icon in your taskbar.

## Normal mode

For navigating. Press `ctrl` or `esc` to return to normal mode in **all** other modes.

## Insert mode

For text editing. Press `shift` in **all** modes to enter insert mode, and press `i` to enter insert mode in **normal** or **visual** mode.

## Visual mode

For selecting text and editing selected text. Press `v` in **normal** mode to enter visual mode.

## Command mode

For longer scripts. In **normal** mode, press `;` or `:` to enter command mode, press it again to return to normal mode. In **insert** mode, press `ctrl+;` to enter command mode.

# Keystrokes and shortcuts

Paragraph means a paragraph in html components; it means a line in every other place.

Typically, adding an `alt` to the hotkey relating to paragraph operations force it to operate on a line (e.g. in html components, `shift+d`: delete to end of paragraph; `alt+shift+d`: delete to end of line).

There are some limitations in html that makes adding line between paragraphs doesn't work well. Currently, what described above is mostly used in html text that has one line only.

## Navigation

For both normal and visual mode. Pressing any of the `1-9` keys beforehand repeats the action for the corresponding times.

### Up/down

`h`: left

`j`: down

`k`: up

`l`: right

(`j` and `k`, while in element window and not focused on text, function as `pgdn` and `pgup`)

`shift+j`: down 5 times (works for content window and browser too)

`shift+k`: up 5 times

`[1-9]->g`: go to xth line (e.g. press 4 followed by g goes to the 4th line)

### Left/right

`0`: go to start of line (= `home`)

`$` (`shift+4`): go to end of line (= `end`)

`w`: go forward a **w**ord (= `ctrl+right`)

`b`: go **b**ack a word (= `ctrl+left`)

`shift+w`: go forward 5 words

`shift+b`: go back 5 words

### Previous/next block

`[`: go to start of previous line

`]`: go to start of next line

`{` (`shift+[`): go to previous paragraph

`}` (`shift+]`): go to next paragraph (= `ctrl+down`)

`gg` (press `g` twice): **g**o to top (= `ctrl+home`)

`shift+g`: go to bottom (= `ctrl+end`)

## Normal mode

### Basic operation

`x` : delete forward 1 character (= `del`)

`shift+x` = `backspace`

`shift+d`: **d**elete everything from caret to end of paragraph (`alt+shift+d` for end of line)

`p`: **p**aste without format

`shift+p`: **p**aste with format (= `ctrl+v`)

`shift+y`: **y**ank (copy) current paragraph (`alt+shift+y` for current line)

### SuperMemo functions

`e`: focus to **e**lement window

`u`: page **u**p

`d` (while not grading): page **d**own

`r`: semi-**r**eload  (= `alt+home` and `alt+left`)

`n`: open hyperlink in current caret position (open in **n**ew window)

`m`: set read point (**m**ark)(= `ctrl+f7`)

`` ` ``: go to read point (= `alt+f7`)

`shift+m`: clear read point (= `ctrl+shift+f7`)

`c`: **c**ontent window (= `alt+c`)

`b` (while not editing text): **b**rowser (= `ctrl+space`)

### Element navigation

`alt+shift+j`: previous sibling (= `alt+shift+pgdn`)

`alt+shift+k`: next sibling (= `alt+shift+pgup`)

`shift+h`: go back (= `alt+left`)

`shift+l`: go forward (= `alt+right`)

`shift+u`: go up (= `ctrl+up`)

### Grading

`asdfg`: correspond to 12345, but after grading, learning continues (just like anki)

### Go to insert mode

`o`: add (**o**pen) a new line below current paragraph and enter insert mode (`alt+o` for current line)

`shift+o`: add a new line above current paragraph and enter insert mode (`alt+shift+o` for current line)

`s`: delete character and substitue text (`alt+s` for line)

`shift+s`: delete paragraph and **s**ubstitue text

`shift+i`: go to beginning of paragraph and enter **i**nsert mode (`alt+shift+i` for line)

`shift+a`: go to end of paragraph (**a**ppend) and enter insert mode (`alt+shift+a` for line)

### Go to visual mode

`vv` (press `v` twice): select entire line and enter visual mode

`shift+v`: select entire paragraph and enter visual mode

`alt+0`: select from caret to start of line

`alt+shift+4` / `alt+$`: select from caret to end of line

`alt+shift+[` / `alt+{`: select from caret to start of paragraph

`alt+shift+]` / `alt+}`: select from caret to end of paragraph

## Insert mode

`ctrl+w`: deleting back a **w**ord (= `ctrl+backspace`)

`ctrl+e`: d**e**leting forward a word (= `ctrl+del`)

`ctrl+h` = `backspace`

`ctrl+l` = `del` (delete forward one character)

`ctrl+j`: add new line below current paragraph (`alt+ctrl+j` for current line)

`ctrl+k`: add new line above current paragraph (`alt+ctrl+k` for current line)


## Visual mode

### SuperMemo functions

`e`: **e**xtract (= `alt+x`)

`c`: **c**loze (= `alt+z`)

`.`: seleted text becomes `[...]`

`t`: highligh**t**

`f`: clear **f**ormat

### Basic operations

`alt+d`: page **d**own

`alt+u`: page **u**p

`x` = `backspace`

`y`: copy without format (**y**ank)

`shift+y`: copy (= `ctrl+c`)

`p`: **p**aste without format

`shift+p`: **p**aste (= `ctrl+v`)

`d`: cut without format

`shift+d`: cut (= `ctrl+x`)

### Case conversion

`u`: convert to lowercase

`shift+u`: convert to uppercase 

`s`: convert to sentence case

`` ` ``: cycle through cases

## Command mode

`c`: change the default **c**oncept group

`shift+c`: add new concept

`b`: delete everything **b**efore cursor

`a`: delete everything **a**fter cursor

`f`: clean **f**ormat using f6 (keeping tables, clearing fonts and styles)

`g`: change current element's concept **g**roup

`l`: **l**ink concept

`w`: prepare **w**ikipedia articles that are not in English

`i`: learn outstanding **i**tems only

`r`: set **r**eference's link to what's on clipboard

number pad:
- in main windows: [priority script by Naess](https://youtu.be/OwV5HPKMrbg) (also works with shift+number, for laptop users)
- in task parameter window: quick task value

## Additional hotkeys

### Caveat

ctrl+m is remapped to `ctrl+shift+alt+m`, and ctrl+shift+j is remapped to `ctrl+shift+alt+j`.

`ctrl+shift+f12` doesn't show notification.

### Additional functions

`ctrl+alt+s`: go to **s**ource (works differently for element window / browser)

`ctrl+alt+.`: go to end of `[...]` and enter insert mode

`right alt + .`, `right alt + ,`: in local video elements, open the video in default video player (= `ctrl+t` \* 2 (navigate to video component) -> `f9`)

`right alt + right shift + backspace`, `right ctrl + right shift + backspace`: delete element and keep learning (similar to anki)

`right alt + right shift + /`, `right ctrl + right shift + /`: Done! and keep learning

More intuitive inter-element linking, inspired by obsidian:
1. Go to the element you want to link to and press `ctrl+alt+g`
2. Go to the element you want to have the hyperlin**k**, select text and press `ctrl+alt+k`

### For Plan window specifically

`alt+a`: **a**dd accident activity