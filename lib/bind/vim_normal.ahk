; FOR ENTIRE SUPERMEMO
#if WinActive("ahk_group " . Vim.GroupName) && (Vim.State.Mode == "Vim_Normal")
x::  ; OG: same as delete
if WinActive("ahk_class TMsgDialog") || WinActive("ahk_class TChoicesDlg") || WinActive("ahk_class TChecksDlg") {  ; dialogue windows
	send x
	return
}
send {del}
return

+x::  ; OG: same as backspace
send {bs}
return

+d::  ; OG: *d*elete everything from caret to end of paragraph
ControlGetFocus, currentFocus, ahk_class TElWind
if (currentFocus = "Internet Explorer_Server2" || currentFocus = "Internet Explorer_Server1") {  ; editing html
	send ^+{down}+{left}{bs}
} else {
	send +{end}{bs}
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

+p::  ; SEMI-OG: paste with format
send ^v
return

+y::  ; OG: yank (copy) current line
send {home}+{end}^c{right}
return

; FOR ELEMENT AND CONTENT WINDOW, AND BROWSER
#if (WinActive("ahk_class TElWind") || WinActive("ahk_class TContents") || WinActive("ahk_class TBrowser")) && (Vim.State.Mode == "Vim_Normal")
e::  ; focus to *e*lement window
WinActivate ahk_class TElWind
click 40 380  ; left middle
return

u::  ; page *u*p
WinActivate ahk_class TElWind
MouseMove, 40, 380
send {Wheelup 2}
return

; FOR ELEMENT AND CONTENT WINDOW
#if (WinActive("ahk_class TElWind") || WinActive("ahk_class TContents")) && (Vim.State.Mode == "Vim_Normal")
b::  ; b to open browser
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

; FOR CONTENT WINDOW AND BROWSER
; 5 lines/elements down/up
#if (WinActive("ahk_class TContents") || WinActive("ahk_class TBrowser")) && (Vim.State.Mode == "Vim_Normal")
+j::
if WinActive("ahk_class TContents") {
	click 295 45  ; turning off the content-element window sync
	send {down 5}
	click 295 45  ; and turning it back on
} else if WinActive("ahk_class TBrowser") {
	click 640 45  ; turning off the browser-element window sync
	send {down 5}
	click 640 45  ; and turning it back on
}
return

+k::
if WinActive("ahk_class TContents") {
	click 295 45  ; turning off the content-element window sync
	send {up 5}
	click 295 45  ; and turning it back on
} else if WinActive("ahk_class TBrowser") {
	click 640 45  ; turning off the browser-element window sync
	send {up 5}
	click 640 45  ; and turning it back on
}
return

; FOR ELEMENT WINDOW AND BROWSER
#if (WinActive("ahk_class TElWind") || WinActive("ahk_class TBrowser")) && (Vim.State.Mode == "Vim_Normal")
c::  ; c for content window
send !c
return

; FOR ELEMENT WINDOW ONLY
#if WinActive("ahk_class TElWind") && (Vim.State.Mode == "Vim_Normal")
n::  ; open hyperlink in current caret position (Open in *n*ew window)
MouseMove, %A_CaretX%, %A_CaretY%
click right
send n
return

m::  ; VIMIUM: set read point (*m*ark)
send ^{f7}
return

`::  ; VIMIUM: go to read point
send !{f7}
return

+m::  ; clear read point
send ^+{f7}
return

; go to next/previous sibling
!+j::
send !+{pgdn}
return

!+k::
send !+{pgup}
return

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
#if WinActive("ahk_group " . Vim.GroupName) && (Vim.State.Mode == "Vim_Normal")
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

#if WinActive("ahk_group " . Vim.GroupName) && (Vim.State.Mode == "Vim_Normal")
s::
if WinActive("ahk_class TElWind") {
	ControlGetFocus, currentFocus, ahk_class TElWind
	; if focused on either 5 of the grading buttons or the cancel button
	if (currentFocus = "TBitBtn4" || currentFocus = "TBitBtn5" || currentFocus = "TBitBtn6" || currentFocus = "TBitBtn7" || currentFocus = "TBitBtn8" || currentFocus = "TBitBtn9") {
		send 2
		sleep 40
		send {space}  ; next item
	}
} else if WinActive("ahk_class TPlanDlg") {  ; *s*witch plan
	click 255 50
} else {
	send s
}
return

#if (WinActive("ahk_class TElWind") || WinActive("ahk_class TContents") || WinActive("ahk_class TBrowser")) && (Vim.State.Mode == "Vim_Normal")
d::
if WinActive("ahk_class TElWind") {
	ControlGetFocus, currentFocus, ahk_class TElWind
	; if focused on either 5 of the grading buttons or the cancel button
	if (currentFocus = "TBitBtn4" || currentFocus = "TBitBtn5" || currentFocus = "TBitBtn6" || currentFocus = "TBitBtn7" || currentFocus = "TBitBtn8" || currentFocus = "TBitBtn9") {
		send 3
		sleep 40
		send {space}  ; next item
		return
	}
} else {
	WinActivate ahk_class TElWind
}
MouseMove, 40, 380
send {Wheeldown 2}
return

#if WinActive("ahk_class TElWind") && (Vim.State.Mode == "Vim_Normal")
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

#if WinActive("ahk_group " . Vim.GroupName) && (Vim.State.Mode == "Vim_Normal")
g::
if WinActive("ahk_class TMsgDialog") || WinActive("ahk_class TChoicesDlg") || WinActive("ahk_class TChecksDlg") {  ; dialogue windows
	send g
	return
}
if WinActive("ahk_class TElWind") {
	ControlGetFocus, currentFocus, ahk_class TElWind
	; if focused on either 5 of the grading buttons or the cancel button
	if (currentFocus = "TBitBtn4" || currentFocus = "TBitBtn5" || currentFocus = "TBitBtn6" || currentFocus = "TBitBtn7" || currentFocus = "TBitBtn8" || currentFocus = "TBitBtn9") {
		send 5
		sleep 40
		send {space}  ; next item
		return
	}
}
if (A_PriorHotkey != "g" or A_TimeSincePriorHotkey > 400) {  ; Too much time between presses, so this isn't a double-press.
	KeyWait g
	return
}
send ^{home}
return