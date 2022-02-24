;;;;;;;;;;;;;;;;;;;;;;
; FOR ENTIRE SUPERMEMO
;;;;;;;;;;;;;;;;;;;;;;
#if WinActive("ahk_group " . Vim.GroupName)
ctrl::Vim.State.SetNormal()  ; ctrl: always go to normal mode

~esc::
back_to_normal = 0
Vim.State.SetNormal()
return

^l::  ; learn
if WinActive("ahk_class TElWind") && !(Vim.State.StrIsInCurrentVimMode("Insert")) {
	KeyWait ctrl
	Vim.State.SetNormal()
	send {alt}{l 2}  ; to avoid weird IE window
	return
} else if WinActive("ahk_group " . Vim.GroupName) && (Vim.State.StrIsInCurrentVimMode("Insert")) {
	KeyWait ctrl
	send {del}
	return
}
send ^l
return

+u::  ; go up
if Vim.State.StrIsInCurrentVimMode("Visual") {
	ConvertUpper()
	Vim.State.SetNormal()
	return
} else if WinActive("ahk_class TElWind") || WinActive("ahk_class TContents") {
	if (Vim.State.Mode == "Vim_Normal") {
		send ^{up}
		return
	} else if !WinActive("ahk_class TContents") {  ; in content window, it only works in normal mode
		ControlGetFocus, currentFocus, ahk_class TElWind
		if (currentFocus != "Internet Explorer_Server2" && currentFocus != "Internet Explorer_Server1" && currentFocus != "TMemo2" && currentFocus != "TMemo1") {  ; not editing text
			Vim.State.SetNormal()
			send ^{up}  ; so it works even in element window and in insert mode when not editing text
			return
		}
	}
}
send +u
return

enter::
if (back_to_normal = 1) {
	back_to_normal = 0
	Vim.State.SetNormal()
} else if (back_to_normal > 1) {
	back_to_normal -= 1
} else {
	back_to_normal = 0
}
; in Plan window enter simply goes to the next field; no need to go back to normal
if !WinActive("ahk_class TPlanDlg") && WinActive("ahk_class TElWind") {  ; in element window pressing enter (learn) sets the mode normal
	ControlGetFocus, currentFocus, ahk_class TElWind
	if (currentFocus != "Internet Explorer_Server2" && currentFocus != "Internet Explorer_Server1" && currentFocus != "TMemo2" && currentFocus != "TMemo1") {  ; not editing text
		Vim.State.SetNormal()
	}
} else if WinActive("ahk_class TTitleEdit") {  ; when done editing title
	Vim.State.SetNormal()
}
send {enter}
return
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; FOR ELEMENT WINDOW / CONTENT WINDOW / BROWSER
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
#if WinActive("ahk_class TElWind") || WinActive("ahk_class TContents") || WinActive("ahk_class TBrowser")
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
	ControlGetFocus, currentFocus, ahk_class TElWind
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
	ControlGetFocus, currentFocus, ahk_class TElWind
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
ControlGetFocus, currentFocus, ahk_class TElWind
if (currentFocus != "Internet Explorer_Server2" && currentFocus != "Internet Explorer_Server1" && currentFocus != "TMemo2" && currentFocus != "TMemo1") {  ; not editing text
	Vim.State.SetNormal()
}
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
WinWaitActive, ahk_class TMsgDialog,, 0  ; wait for "Delete element?"
send {enter}
WinWaitActive, ahk_class TElWind,, 0  ; wait for element window to become focused again
send {enter}
return

>!>+/::  ; for laptop
>^>+/::  ; done! and keep learning
Vim.State.SetNormal()
send ^+{enter}
WinWaitActive, ahk_class TMsgDialog,, 0  ; "Do you want to remove all element contents from the collection?"
send {enter}
WinWaitActive, ahk_class TMsgDialog,, 0  ; wait for "Delete element?"
send {enter}
WinWaitActive, ahk_class TElWind,, 0  ; wait for element window to become focused again
sleep 300  ; leaves time for "Warning! The last child of the displayed element has been moved or deleted" to pop up
ControlGetText, currentText, TBitBtn3
if (currentText = "Learn") {
	send {enter}
}
return

; more intuitive inter-element linking, inspired by obsidian
; 1. go to the element you want to link to and press ctrl+alt+g
; 2. go to the element you want to have the hyperlink, select text and press ctrl+alt+k
^!g::
Vim.State.SetNormal()
send ^g
WinWaitActive, ahk_class TInputDlg,, 0
send ^c{esc}
return

^!k::
ControlGetFocus, currentFocus, ahk_class TElWind
if Vim.State.StrIsInCurrentVimMode("Insert") && (currentFocus = "Internet Explorer_Server2" || currentFocus = "Internet Explorer_Server1") {  ; in insert mode and editing html
	KeyWait ctrl
	send {home}{enter}{up}  ; force new line above current line
} else {
	Vim.State.SetNormal()
	if (currentFocus != "Internet Explorer_Server2" && currentFocus != "Internet Explorer_Server1") {  ; not editing html
		return
	}
	element_number := RegExReplace(Clipboard, "^#")
	hyperlink = SuperMemoElementNo=(%element_number%)
	send ^k
	WinWaitActive, ahk_class Internet Explorer_TridentDlgFrame,, 2  ; a bit more delay since everybody knows how slow IE can be
	clip(hyperlink)
	send {enter}
}
return

; back to normal after various hotkeys
~!x::  ; extract
~!z::  ; cloze
~^n::  ; paste new topic
~^p::  ; plan
~!t::  ; set title
Vim.State.SetNormal()
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
~^s::Vim.State.SetMode("Vim_Normal")

!a::  ; insert the accident activity
Vim.State.SetMode("Vim_Normal")
InputBox, UserInput, Accident activity, Please enter the name of the activity. Add ! at the beginning if you don't want to split the current activity., , 256, 164
if ErrorLevel {
	return
}
replacement := RegExReplace(UserInput, "^!")  ; remove the "!"
if (replacement != UserInput) {  ; you entered an "!"
	split = 0
	UserInput := replacement
} else {
	split = 1
}
if (UserInput = "b") {  ; shortcuts
	UserInput = Break
} else if (UserInput = "g") {
	UserInput = Gaming
} else if (UserInput = "c") {
	UserInput = Coding
} else if (UserInput = "s") {
	UserInput = Sports
} else if (UserInput = "o") {
	UserInput = Social
} else if (UserInput = "w") {
	UserInput = Writing
} else if (UserInput = "f") {
	UserInput = Family
} else if (UserInput = "p") {
	UserInput = Passive
} else if (UserInput = "m") {
	UserInput = Meal
} else if (UserInput = "r") {
	UserInput = Rest
} else if (UserInput = "h") {
	UserInput = School
}
if (split = 1) {
	send ^t  ; split
	WinWaitActive, ahk_class TInputDlg,, 0
	send {enter}
	WinWaitActive, ahk_class TPlanDlg,, 0
}
send {down}{Insert}  ; inserting one activity below the current selected activity and start editing
SendInput %UserInput%  ; SendInput is faster than clip() here
send !b  ; begin
sleep 250  ; wait for "Mark the slot with the drop to efficiency?"
if WinActive("ahk_class TMsgDialog") {
	send y
}
WinWaitActive, ahk_class TPlanDlg,, 0
send ^s{esc}  ; save and exits
WinWaitActive, ahk_class TElWind,, 0
send ^{enter}  ; commander
WinWaitActive, ahk_class TCommanderDlg,, 0
send {enter}  ; cancel alarm
WinWaitActive, ahk_class TElWind,, 0
send ^p  ; open plan
return