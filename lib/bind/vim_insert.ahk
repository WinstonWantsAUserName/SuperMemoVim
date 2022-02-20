#if WinActive("ahk_group " . Vim.GroupName) && Vim.State.StrIsInCurrentVimMode("Insert")
^w::send ^+{left}{bs}  ; delete back a word
^e::send ^{del}  ; delete forward a word
^h::send {bs}  ; backspace
; ^l: send {del}  ; also for learning

; ^j: new line below current paragraph  ; also for reschedule
^!j::  ; force new line below current line when editing html
ControlGetFocus, currentFocus, ahk_class TElWind
if (currentFocus = "Internet Explorer_Server2" || currentFocus = "Internet Explorer_Server1") {  ; editing html
	send {end}{enter}
}
return

^k::  ; new line above current paragraph
ControlGetFocus, currentFocus, ahk_class TElWind
if (currentFocus = "Internet Explorer_Server2" || currentFocus = "Internet Explorer_Server1") {  ; editing html
	send ^+{up}{left}{enter}{up}
} else {
	send {home}{enter}{up}
}
return
; ^!k: force new line above current line when editing html  ; also for hyperlinking elements