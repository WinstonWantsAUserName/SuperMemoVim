#if WinActive("ahk_group " . Vim.GroupName) && Vim.State.StrIsInCurrentVimMode("Insert")

; for all hotkeys here involving ctrl, I had to add keywait ctrl because if not, somehow ctrl is pressed
; this problem has something to do with supermemo or autohotkey, I'm not sure

^w::  ; delete back a word
KeyWait ctrl
send ^+{left}{bs}
return

^e::  ; delete forward a word
KeyWait ctrl
send ^{del}
return

^h::  ; backspace
KeyWait ctrl
send {bs}
return

; ^l: send {del}; also for learning

; ^j: new line below current paragraph; also for reschedule

^!j::  ; force new line below current line when editing html
KeyWait ctrl
ControlGetFocus currentFocus, ahk_class TElWind
if (currentFocus = "Internet Explorer_Server2" || currentFocus = "Internet Explorer_Server1")  ; editing html
	send {end}{enter}
return

^k::  ; new line above current paragraph
KeyWait ctrl
ControlGetFocus currentFocus, ahk_class TElWind
if (currentFocus = "Internet Explorer_Server2" || currentFocus = "Internet Explorer_Server1")  ; editing html
	send ^+{up}{left}{enter}{up}
else
	send {home}{enter}{up}
return

; ^!k: force new line above current line when editing html; also for hyperlinking elements

#if WinActive("ahk_class TElParamDlg") && Vim.State.StrIsInCurrentVimMode("Insert")
~!s::back_to_normal += 1  ; select tasklist

#if WinActive("ahk_class TPriorityDlg") && Vim.State.StrIsInCurrentVimMode("Insert")
.::SendInput ^a0.  ; because supermemo is dumb and enter .5 in priority window doesn't work properly