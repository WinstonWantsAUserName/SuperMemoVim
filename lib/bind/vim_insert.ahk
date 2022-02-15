#if WinActive("ahk_group " . Vim.GroupName) && (Vim.State.StrIsInCurrentVimMode("Insert"))
^w::  ; delete back a word
send ^+{left}{bs}
return

^e::  ; delete forward a word
send ^{del}
return

^h::  ; backspace
send {bs}
return

^j::  ; new line below
ControlGetFocus, currentFocus, ahk_class TElWind
if (currentFocus = "Internet Explorer_Server2" || currentFocus = "Internet Explorer_Server1") {  ; editing html
	send ^{down}{left}{enter}
} else {
	send {end}{enter}
}
return

^k::  ; new line above
ControlGetFocus, currentFocus, ahk_class TElWind
if (currentFocus = "Internet Explorer_Server2" || currentFocus = "Internet Explorer_Server1") {  ; editing html
	send ^+{up}{left}{enter}{up}
} else {
	send {home}{enter}{up}
}
return