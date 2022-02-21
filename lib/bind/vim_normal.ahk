; FOR ENTIRE SUPERMEMO
#if WinActive("ahk_group " . Vim.GroupName) && Vim.State.Mode == "Vim_Normal"
x::  ; OG: same as delete
if WinActive("ahk_class TMsgDialog") || WinActive("ahk_class TChoicesDlg") || WinActive("ahk_class TChecksDlg") {  ; dialogue windows
	send x
	return
}
send {del}
return

+x::send {bs}  ; OG: same as backspace
+p::send ^v  ; SEMI-OG: paste with format
+y::send {home}+{end}^c{right}  ; OG: yank (copy) current line

+d::  ; OG: *d*elete everything from caret to end of paragraph
ControlGetFocus, currentFocus, ahk_class TElWind
if (currentFocus = "Internet Explorer_Server2" || currentFocus = "Internet Explorer_Server1") {  ; editing html
	send ^+{down}+{left}{bs}
} else {
	send +{end}{bs}
}
return

!+d::  ; force deleting from caret to end of line when editing html
ControlGetFocus, currentFocus, ahk_class TElWind
if (currentFocus = "Internet Explorer_Server2" || currentFocus = "Internet Explorer_Server1") {  ; editing html
	send +{end}{bs}
} else {
	send !+d
}
return

p::  ; SEMI-OG: paste without format
if WinActive("ahk_class TMsgDialog") || WinActive("ahk_class TChoicesDlg") || WinActive("ahk_class TChecksDlg") {  ; dialogue windows
	send p
	return
}
Clipboard := Clipboard
send ^v
return

; FOR ELEMENT AND CONTENT WINDOW, AND BROWSER
#if (WinActive("ahk_class TElWind") || WinActive("ahk_class TContents") || WinActive("ahk_class TBrowser")) && Vim.State.Mode == "Vim_Normal"
e::  ; focus to *e*lement window
WinActivate ahk_class TElWind
click 40 380  ; left middle
return

; d: page down  ; also for grading
u::  ; page *u*p
WinActivate ahk_class TElWind
MouseMove 40, 380
send {Wheelup 2}
return

!j::  ; wheel down
WinActivate ahk_class TElWind
MouseMove 40, 380
KeyWait alt
send {Wheeldown}
return

!k::  ; wheel up
WinActivate ahk_class TElWind
MouseMove 40, 380
KeyWait alt
send {Wheelup}
return

; FOR ELEMENT AND CONTENT WINDOW
#if (WinActive("ahk_class TElWind") || WinActive("ahk_class TContents")) && Vim.State.Mode == "Vim_Normal"
b::  ; browser
if WinActive("ahk_class TElWind") {
	ControlGetFocus, currentFocus, ahk_class TElWind
	if (currentFocus = "Internet Explorer_Server2" || currentFocus = "Internet Explorer_Server1" || currentFocus = "TMemo2" || currentFocus = "TMemo1") {  ; editing text
		Vim.Move.Repeat("b")
		return
	}
}
send ^{space}
return

r::  ; VIMIUM: semi-*r*eload
send !{home}
sleep 100
send !{left}
return

c::send !c  ; content window

; FOR ELEMENT WINDOW ONLY
#if WinActive("ahk_class TElWind") && Vim.State.Mode == "Vim_Normal"
n::  ; open hyperlink in current caret position (Open in *n*ew window)
MouseMove, %A_CaretX%, %A_CaretY%
click right
send n
return

m::send ^{f7}  ; VIMIUM: set read point (*m*ark)
`::send !{f7}  ; VIMIUM: go to read point
+m::send ^+{f7}  ; clear read point
!+j::send !+{pgdn}  ; go to next sibling
!+k::send !+{pgup}  ; go to previous sibling

; pgdn/pgup when not focused on text
j::
ControlGetFocus, currentFocus, ahk_class TElWind
if (currentFocus = "Internet Explorer_Server2" || currentFocus = "Internet Explorer_Server1" || currentFocus = "TMemo2" || currentFocus = "TMemo1") {  ; editing text
	Vim.Move.Repeat("j")
} else {
	send {pgdn}
}
return

k::
ControlGetFocus, currentFocus, ahk_class TElWind
if (currentFocus = "Internet Explorer_Server2" || currentFocus = "Internet Explorer_Server1" || currentFocus = "TMemo2" || currentFocus = "TMemo1") {  ; editing text
	Vim.Move.Repeat("k")
} else {
	send {pgup}
}
return

; GRADING
#if WinActive("ahk_group " . Vim.GroupName) && Vim.State.Mode == "Vim_Normal"
a::
ControlGetFocus, currentFocus, ahk_class TElWind
; if focused on either 5 of the grading buttons or the cancel button
if (currentFocus = "TBitBtn4" || currentFocus = "TBitBtn5" || currentFocus = "TBitBtn6" || currentFocus = "TBitBtn7" || currentFocus = "TBitBtn8" || currentFocus = "TBitBtn9") {
    send 1
    sleep 40
    send {space}  ; next item
; send a in: dialogue windows; not focused on text components (focus to answer field)
} else if (WinActive("ahk_class TMsgDialog") || WinActive("ahk_class TChoicesDlg") || WinActive("ahk_class TChecksDlg")) || !(currentFocus = "Internet Explorer_Server2" || currentFocus = "Internet Explorer_Server1" || currentFocus = "TMemo2" || currentFocus = "TMemo1") {
	send a
} else {
	send {right}  ; OG: *a*ppend
	Vim.State.SetMode("Insert")
}
return	

#if WinActive("ahk_group " . Vim.GroupName) && Vim.State.Mode == "Vim_Normal"
s::
ControlGetFocus, currentFocus, ahk_class TElWind
; if focused on either 5 of the grading buttons or the cancel button
if (currentFocus = "TBitBtn4" || currentFocus = "TBitBtn5" || currentFocus = "TBitBtn6" || currentFocus = "TBitBtn7" || currentFocus = "TBitBtn8" || currentFocus = "TBitBtn9") {
	send 2
	sleep 40
	send {space}  ; next item
} else if WinActive("ahk_class TPlanDlg") {  ; *s*witch plan
	coord_x := 253 * A_ScreenDPI / 96
	coord_y := 48 * A_ScreenDPI / 96
	click %coord_x% %coord_y%
} else {
	send {del}  ; OG: delete character and *s*ubstitue text
	Vim.State.SetMode("Insert")
}
return

#if (WinActive("ahk_class TElWind") || WinActive("ahk_class TContents") || WinActive("ahk_class TBrowser")) && Vim.State.Mode == "Vim_Normal"
d::
ControlGetFocus, currentFocus, ahk_class TElWind
; if focused on either 5 of the grading buttons or the cancel button
if (currentFocus = "TBitBtn4" || currentFocus = "TBitBtn5" || currentFocus = "TBitBtn6" || currentFocus = "TBitBtn7" || currentFocus = "TBitBtn8" || currentFocus = "TBitBtn9") {
	send 3
	sleep 40
	send {space}  ; next item
	return
} else {
	WinActivate ahk_class TElWind
}
MouseMove 40, 380
send {Wheeldown 2}
return

#if WinActive("ahk_class TElWind") && Vim.State.Mode == "Vim_Normal"
f::
ControlGetFocus, currentFocus, ahk_class TElWind
; if focused on either 5 of the grading buttons or the cancel button
if (currentFocus = "TBitBtn4" || currentFocus = "TBitBtn5" || currentFocus = "TBitBtn6" || currentFocus = "TBitBtn7" || currentFocus = "TBitBtn8" || currentFocus = "TBitBtn9") {
    send 4
    sleep 40
    send {space}  ; next item
} else {
	send f
}
return

#if WinActive("ahk_group " . Vim.GroupName) && Vim.State.Mode == "Vim_Normal"
g::
if WinActive("ahk_class TMsgDialog") || WinActive("ahk_class TChoicesDlg") || WinActive("ahk_class TChecksDlg") {  ; dialogue windows
	send g
	return
}
ControlGetFocus, currentFocus, ahk_class TElWind
; if focused on either 5 of the grading buttons or the cancel button
if (currentFocus = "TBitBtn4" || currentFocus = "TBitBtn5" || currentFocus = "TBitBtn6" || currentFocus = "TBitBtn7" || currentFocus = "TBitBtn8" || currentFocus = "TBitBtn9") {
	send 5
	sleep 40
	send {space}  ; next item
	return
}
if (A_PriorHotkey != "g" or A_TimeSincePriorHotkey > 400) {  ; Too much time between presses, so this isn't a double-press.
	KeyWait g
	return
}
send ^{home}
return