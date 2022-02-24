#if WinActive("ahk_group " . Vim.GroupName) && Vim.State.StrIsInCurrentVimMode("Insert")
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

; ^l: send {del}  ; also for learning

; ^j: new line below current paragraph  ; also for reschedule

^!j::  ; force new line below current line when editing html
KeyWait ctrl
ControlGetFocus, currentFocus, ahk_class TElWind
if (currentFocus = "Internet Explorer_Server2" || currentFocus = "Internet Explorer_Server1") {  ; editing html
	send {end}{enter}
}
return

^k::  ; new line above current paragraph
KeyWait ctrl
ControlGetFocus, currentFocus, ahk_class TElWind
if (currentFocus = "Internet Explorer_Server2" || currentFocus = "Internet Explorer_Server1") {  ; editing html
	send ^+{up}{left}{enter}{up}
} else {
	send {home}{enter}{up}
}
return

; ^!k: force new line above current line when editing html  ; also for hyperlinking elements