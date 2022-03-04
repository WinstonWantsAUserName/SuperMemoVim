;;;;;;;;;;;;;;;;;;;;;;
; FOR ENTIRE SUPERMEMO
;;;;;;;;;;;;;;;;;;;;;;
#if WinActive("ahk_group " . Vim.GroupName)
ctrl::
if Vim.State.n > 0 || Vim.State.g  ; show tooltip "normal" if there exits a repeat times or g state tooltip
	ToolTip
Vim.State.SetMode("Vim_Normal")  ; ctrl: always go to normal mode. If in visual mode, doesn't cancel selection
return

RCtrl::Vim.State.SetNormal()  ; this cancels selection in visual mode

esc::
if Vim.State.StrIsInCurrentVimMode("Vim_") && (Vim.State.n > 0 || Vim.State.g) {  ; clear repeat times tooltip
	n_repeat = 0
	Vim.State.SetMode("", 0)
	ToolTip
} else {
	send {esc}
	back_to_normal = 0
	Vim.State.SetMode("Vim_Normal")  ; using SetNormal() here would add an extra {right} in visual mode
}
return

^l::  ; learn
ControlGetFocus currentFocus, ahk_class TElWind
; in element window: learn if not in insert mode, or in insert mode and not focused on text components
if WinActive("ahk_class TElWind") && (!Vim.State.StrIsInCurrentVimMode("Insert") || (Vim.State.StrIsInCurrentVimMode("Insert") && currentFocus != "Internet Explorer_Server2" && currentFocus != "Internet Explorer_Server1" && currentFocus != "TMemo2" && currentFocus != "TMemo1")) {  ; not editing text
	KeyWait ctrl
	Vim.State.SetMode("Vim_Normal")
	send {alt}{l 2}  ; to avoid weird IE window
	return
} else if WinActive("ahk_group " . Vim.GroupName) && Vim.State.StrIsInCurrentVimMode("Insert") {
	KeyWait ctrl
	send {del}
	return
}
send ^l
return

enter::
if (back_to_normal = 1) {
	back_to_normal = 0
	Vim.State.SetMode("Vim_Normal")
} else if (back_to_normal > 1)
	back_to_normal -= 1
else
	back_to_normal = 0
; in Plan window enter simply goes to the next field; no need to go back to normal
if !WinActive("ahk_class TPlanDlg") && WinActive("ahk_class TElWind") {  ; in element window pressing enter (learn) sets the mode normal
	ControlGetFocus currentFocus, ahk_class TElWind
	if (currentFocus != "Internet Explorer_Server2" && currentFocus != "Internet Explorer_Server1" && currentFocus != "TMemo2" && currentFocus != "TMemo1")  ; not editing text
		Vim.State.SetMode("Vim_Normal")
	; OG feature, but quite dumb frankly
	; else if Vim.State.StrIsInCurrentVimMode("Vim_") {
		; Vim.Move.Repeat("j")  ; OG
		; return  ; enter for going down only in text components since input window doesn't really need this (enter itself would be more useful)
	; }
} else if WinActive("ahk_class TTitleEdit")  ; when done editing title
	Vim.State.SetMode("Vim_Normal")
send {enter}
return
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; FOR ELEMENT WINDOW / CONTENT WINDOW / BROWSER
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
#if WinActive("ahk_class TElWind") || WinActive("ahk_class TContents") || WinActive("ahk_class TBrowser")
^!c::  ; change default *c*oncept group
Vim.State.SetMode("Insert")
WinActivate ahk_class TElWind
coord_x := 724 * A_ScreenDPI / 96
coord_y := 68 * A_ScreenDPI / 96
click %coord_x% %coord_y%
back_to_normal = 1
return

^!s::  ; go to *s*ource
Vim.State.SetNormal()
if WinActive("ahk_class TBrowser") {  ; browser: keeps source elements only
	coord_x := 293 * A_ScreenDPI / 96
	coord_y := 44 * A_ScreenDPI / 96
	click %coord_x% %coord_y%
} else if WinExist("ahk_class TElWind") {  ; go to source (root element / hyperlink)
	WinActivate
	coord_x := 556 * A_ScreenDPI / 96
	coord_y := 67 * A_ScreenDPI / 96
	click %coord_x% %coord_y%
}
return
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; FOR ELEMENT WINDOW / CONTENT WINDOW
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
#if WinActive("ahk_class TElWind") || WinActive("ahk_class TContents")
+h::  ; VIMIUM: go back (= alt+left)
if (Vim.State.Mode == "Vim_Normal") {
	send !{left}
	return
} else if !WinActive("ahk_class TContents") {  ; in content window, it only works in normal mode
	ControlGetFocus currentFocus, ahk_class TElWind
	if (currentFocus != "Internet Explorer_Server2" && currentFocus != "Internet Explorer_Server1" && currentFocus != "TMemo2" && currentFocus != "TMemo1") {  ; not editing text
		Vim.State.SetNormal()
		send !{left}   ; so it works even in element window and in insert mode when not editing text
		return
	}
}
send +h
return

+l::  ; VIMIUM: go forward (= alt+right)
if (Vim.State.Mode == "Vim_Normal") {
	send !{right}
	return
} else if !WinActive("ahk_class TContents") {  ; in content window, it only works in normal mode
	ControlGetFocus currentFocus, ahk_class TElWind
	if (currentFocus != "Internet Explorer_Server2" && currentFocus != "Internet Explorer_Server1" && currentFocus != "TMemo2" && currentFocus != "TMemo1") {  ; not editing text
		Vim.State.SetNormal()
		send !{right}  ; so it works even in element window and in insert mode when not editing text
		return
	}
}
send +l
return

; +u: go up  ; see above (also for uppercase conversion in visual mode)

;;;;;;;;;;;;;;;;;;;;;;;;;
; FOR ELEMENT WINDOW ONLY
;;;;;;;;;;;;;;;;;;;;;;;;;
#if WinActive("ahk_class TElWind")
space::  ; space: for Learn button
ControlGetFocus currentFocus, ahk_class TElWind
if (currentFocus != "Internet Explorer_Server2" && currentFocus != "Internet Explorer_Server1" && currentFocus != "TMemo2" && currentFocus != "TMemo1")  ; not editing text
	Vim.State.SetNormal()
send {space}
return

~^+f12::  ; bomb format with no confirmation
Vim.State.SetNormal()
send {enter}
return

>!>+bs::  ; for laptop
>^>+bs::  ; for processing pending queue Advanced English 2018: delete element and keep learning
Vim.State.SetNormal()
send ^+{del}
WinWaitActive ahk_class TMsgDialog,, 0  ; wait for "Delete element?"
send {enter}
WinWaitActive ahk_class TElWind,, 0  ; wait for element window to become focused again
send {enter}
return

>!>+/::  ; for laptop
>^>+/::  ; done! and keep learning
Vim.State.SetNormal()
send ^+{enter}
WinWaitActive ahk_class TMsgDialog,, 0  ; "Do you want to remove all element contents from the collection?"
send {enter}
WinWaitActive ahk_class TMsgDialog,, 0  ; wait for "Delete element?"
send {enter}
WinWaitActive ahk_class TElWind,, 0  ; wait for element window to become focused again
sleep 150
ControlGetText, currentText, TBitBtn3
if (currentText = "Learn")
	send {enter}
return

; more intuitive inter-element linking, inspired by obsidian
; 1. go to the element you want to link to and press ctrl+alt+g
; 2. go to the element you want to have the hyperlink, select text and press ctrl+alt+k
^!g::
Vim.State.SetNormal()
send ^g
WinWaitActive ahk_class TInputDlg,, 0
send ^c{esc}
return

^!k::
ControlGetFocus currentFocus, ahk_class TElWind
if Vim.State.StrIsInCurrentVimMode("Insert") && (currentFocus = "Internet Explorer_Server2" || currentFocus = "Internet Explorer_Server1") {  ; in insert mode and editing html
	KeyWait ctrl
	send {home}{enter}{up}  ; force new line above current line
} else {
	if (currentFocus != "Internet Explorer_Server2" && currentFocus != "Internet Explorer_Server1")  ; not editing html
		return
	element_number := RegExReplace(Clipboard, "^#")
	hyperlink = SuperMemoElementNo=(%element_number%)
	send ^k
	WinWaitActive ahk_class Internet Explorer_TridentDlgFrame,, 2  ; a bit more delay since everybody knows how slow IE can be
	clip(hyperlink)
	send {enter}
	Vim.State.SetNormal()
}
return

; back to normal after various hotkeys
~!x::  ; extract
~!z::  ; cloze
~^n::  ; paste new topic
~^p::  ; plan
~!t::  ; set title
Vim.State.SetMode("Vim_Normal")  ; using SetNormal() here would add an extra {right} in visual mode
return

!d::  ; duplicate
if Vim.State.StrIsInCurrentVimMode("Visual") {
	KeyWait alt
	MouseMove 40, 380
	send {Wheeldown 2}
} else {
	send !d
	Vim.State.SetNormal()
}
return

>!.::  ; for laptop
>!,::  ; play video in default system player / edit script component
Vim.State.SetNormal()
send ^{t 2}{f9}
return
;;;;;;;;;;;;;;;
; OTHER WINDOWS
;;;;;;;;;;;;;;;
#if WinActive("ahk_class TWebDlg")
~!i::Vim.State.SetNormal()  ; normal mode after import

#if WinActive("ahk_class TInputDlg")
~!enter::Vim.State.SetNormal()
;;;;;;;;;;;;;;;;;;;;;;
; FOR PLAN WINDOW ONLY
;;;;;;;;;;;;;;;;;;;;;;
#if WinActive("ahk_class TPlanDlg")
~^s::  ; save
~^+a::  ; move current schedule to archive
Vim.State.SetMode("Vim_Normal")
return

!a::  ; insert the accident activity
Vim.State.SetMode("Vim_Normal")
InputBox userInput, Accident activity, Please enter the name of the activity. Add ! at the beginning if you don't want to split the current activity.,, 256, 164
if ErrorLevel
	return
replacement := RegExReplace(userInput, "^!")  ; remove the "!"
if (replacement != userInput) {  ; you entered an "!"
	split = 0
	userInput := replacement
} else
	split = 1
if (userInput = "b")  ; shortcuts
	userInput = Break
else if (userInput = "g")
	userInput = Gaming
else if (userInput = "c")
	userInput = Coding
else if (userInput = "s")
	userInput = Sports
else if (userInput = "o")
	userInput = Social
else if (userInput = "w")
	userInput = Writing
else if (userInput = "f")
	userInput = Family
else if (userInput = "p")
	userInput = Passive
else if (userInput = "m")
	userInput = Meal
else if (userInput = "r")
	userInput = Rest
else if (userInput = "h")
	userInput = School
else if (userInput = "l")
	userInput = Planning
if (split = 1) {
	send ^t  ; split
	WinWaitActive ahk_class TInputDlg,, 0
	send {enter}
	WinWaitActive ahk_class TPlanDlg,, 0
}
send {down}{Insert}  ; inserting one activity below the current selected activity and start editing
SendInput {raw}%userInput%  ; SendInput is faster than clip() here
send !b  ; begin
sleep 400  ; wait for "Mark the slot with the drop to efficiency?"
if WinActive("ahk_class TMsgDialog")
	send y
WinWaitActive ahk_class TPlanDlg,, 0
send ^s{esc}  ; save and exits
WinWaitActive ahk_class TElWind,, 0
send ^{enter}  ; commander
WinWaitActive ahk_class TCommanderDlg,, 0
send {enter}  ; cancel alarm
WinWaitActive ahk_class TElWind,, 0
send ^p  ; open plan
return