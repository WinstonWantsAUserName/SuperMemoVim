;;;;;;;;;;;;;;;;;;;;;;
; FOR ENTIRE SUPERMEMO
;;;;;;;;;;;;;;;;;;;;;;
#if WinActive("ahk_group " . Vim.GroupName) && Vim.State.Mode == "Vim_Normal"
; space is more useful functioning as space in normal mode
; space::
; if dialogueWindow()
	; return
; send {right}  ; OG
; return

bs::
if dialogueWindow()
	return
Vim.Move.Repeat("h")  ; OG
return

x::  ; OG: same as delete
if dialogueWindow()
	return
send {del}
return

+x::send {bs}  ; OG: same as backspace

+d::  ; OG: *d*elete everything from caret to end of paragraph
ControlGetFocus currentFocus, ahk_class TElWind
if (currentFocus = "Internet Explorer_Server2" || currentFocus = "Internet Explorer_Server1")  ; editing html
	send ^+{down}+{left}{bs}
else
	send +{end}{bs}
return

!+d::  ; force deleting from caret to end of line when editing html
ControlGetFocus currentFocus, ahk_class TElWind
if (currentFocus = "Internet Explorer_Server2" || currentFocus = "Internet Explorer_Server1")  ; editing html
	send +{end}{bs}
else
	send !+d
return

+p::send ^v  ; SEMI-OG: paste with format

p::  ; SEMI-OG: paste without format
if dialogueWindow()
	return
Clipboard := Clipboard
send ^v
return

+y::  ; OG: *y*ank (copy) current paragraph
ControlGetFocus currentFocus, ahk_class TElWind
if (currentFocus = "Internet Explorer_Server2" || currentFocus = "Internet Explorer_Server1")  ; editing html
	send ^{down}^+{up}^c{right}
else
	send {end}+{home}^c{right}
Clipwait 1
sleep 300  ; make sure the tooltip is displayed correctly
SMToolTip("Copied " . Clipboard)
return

+!y::  ; force yank current line when editing html
ControlGetFocus currentFocus, ahk_class TElWind
if (currentFocus = "Internet Explorer_Server2" || currentFocus = "Internet Explorer_Server1") {  ; editing html
	send {end}+{home}^c{right}
	Clipwait 1
	sleep 100
	SMToolTip("Copied " . Clipboard)
} else
	send +!y
return

+j::  ; OG: join with the paragraph below with a space
ControlGetFocus currentFocus, ahk_class TElWind
if (currentFocus = "Internet Explorer_Server2" || currentFocus = "Internet Explorer_Server1") {  ; editing html
	send ^{down}{bs}
	if Vim.State.g {  ; OG: without a space in g state
		Vim.State.SetNormal()
		ToolTip
	} else
		send {space}
} else {
	send {down}{home}{bs}
	if Vim.State.g {  ; OG: without a space in g state
		Vim.State.SetNormal()
		ToolTip
	} else
		send {space}
}
return

!+j::  ; force join with the line below with a space when editing html
ControlGetFocus currentFocus, ahk_class TElWind
if (currentFocus = "Internet Explorer_Server2" || currentFocus = "Internet Explorer_Server1") {  ; editing html
	send {down}{home}{bs}
	if Vim.State.g {  ; OG: without a space in g state
		Vim.State.SetNormal()
		ToolTip
	} else
		send {space}
} else
	send !+{pgdn}  ; go to next sibling
return

+k::  ; join with the paragraph above with a space
ControlGetFocus currentFocus, ahk_class TElWind
if (currentFocus = "Internet Explorer_Server2" || currentFocus = "Internet Explorer_Server1") {  ; editing html
	send ^{down}^+{up}{left}{bs}
	if Vim.State.g {  ; OG: without a space in g state
		Vim.State.SetNormal()
		ToolTip
	} else
		send {space}
} else {
	send {home}{bs}
	if Vim.State.g {  ; OG: without a space in g state
		Vim.State.SetNormal()
		ToolTip
	} else
		send {space}
}
return

!+k::  ; force join with the line above with a space
ControlGetFocus currentFocus, ahk_class TElWind
if (currentFocus = "Internet Explorer_Server2" || currentFocus = "Internet Explorer_Server1") {  ; editing html
	send {home}{bs}
	if Vim.State.g {  ; OG: without a space in g state
		Vim.State.SetNormal()
		ToolTip
	} else
		send {space}
} else
	send !+{pgup}  ; go to previous sibling
return
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; FOR ELEMENT WINDOW / CONTENT WINDOW / BROWSER
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
#if (WinActive("ahk_class TElWind") || WinActive("ahk_class TContents") || WinActive("ahk_class TBrowser")) && Vim.State.Mode == "Vim_Normal"
; f: *f*ocus to element window; also for grading

; d: page down; also for grading

u::  ; page *u*p
WinActivate ahk_class TElWind
MouseMove 40, 380
Vim.Move.Repeat("u")
return

!j::  ; wheel down
KeyWait alt
WinActivate ahk_class TElWind
MouseMove 40, 380
Vim.Move.Repeat("!j")
return

!k::  ; wheel up
KeyWait alt
WinActivate ahk_class TElWind
MouseMove 40, 380
Vim.Move.Repeat("!k")
return

!h::  ; wheel left
KeyWait alt
WinActivate ahk_class TElWind
MouseMove 40, 380
Vim.Move.Repeat("!h")
return

!l::  ; wheel right
KeyWait alt
WinActivate ahk_class TElWind
MouseMove 40, 380
Vim.Move.Repeat("!l")
return
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; FOR ELEMENT WINDOW / CONTENT WINDOW
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
#if (WinActive("ahk_class TElWind") || WinActive("ahk_class TContents")) && Vim.State.Mode == "Vim_Normal"
c::send !c  ; content window

; b: browser; also for movement

+u::send ^{up}

r::  ; VIMIUM: semi-*r*eload
send !{home}
sleep 100
if !WinActive("ahk_class TElWind") {  ; exiting YT videos may have warning
	send {esc}!{home}
	sleep 100
}
send !{left}
return
;;;;;;;;;;;;;;;;;;;;;;;;;
; FOR ELEMENT WINDOW ONLY
;;;;;;;;;;;;;;;;;;;;;;;;;

; no need for checking dialogue window because it's for element window only

#if WinActive("ahk_class TElWind") && Vim.State.Mode == "Vim_Normal"
n::  ; open hyperlink in current caret position (Open in *n*ew window)
ControlGetFocus currentFocus, ahk_class TElWind
if (currentFocus != "Internet Explorer_Server2" && currentFocus != "Internet Explorer_Server1")  ; not editing html
	return
clipSave := Clipboardall
Clipboard =
send +{right}^c{left}
ClipWait 1
sleep 100

ClipboardGet_HTML( byref Data ) {  ; https://www.autohotkey.com/boards/viewtopic.php?t=13063
 If CBID := DllCall( "RegisterClipboardFormat", Str,"HTML Format", UInt )
  If DllCall( "IsClipboardFormatAvailable", UInt,CBID ) <> 0
   If DllCall( "OpenClipboard", UInt,0 ) <> 0
    If hData := DllCall( "GetClipboardData", UInt,CBID, UInt )
       DataL := DllCall( "GlobalSize", UInt,hData, UInt )
     , pData := DllCall( "GlobalLock", UInt,hData, UInt )
     , Data := StrGet( pData, dataL, "UTF-8" )
     , DllCall( "GlobalUnlock", UInt,hData )
 DllCall( "CloseClipboard" )
Return dataL ? dataL : 0
}

If ClipboardGet_HTML( Data ){
	RegExMatch(data, "(<A((.|\r\n)*)href="")\K[^""]+", current_link)
	if (current_link == "")
		SMToolTip("No link found")
	else IfInString current_link, SuperMemoElementNo=(, {  ; goes to a supermemo element
		click %A_CaretX% %A_CaretY%, right
		send n
	} else
		run % current_link
}
Clipboard := clipSave
return

m::  ; VIMIUM: set read point (*m*ark)
send ^{f7}
SMToolTip("Read point set")
return

`::  ; VIMIUM: go to read point
send !{f7}
SMToolTip("Go to read point")
return

+m::  ; clear read point
send ^+{f7}
SMToolTip("Read point cleared")
return

t::send ^t  ; cycle through components

*/::  ; better search
GetKeyState ctrl_state, ctrl  ; visual
GetKeyState shift_state, RShift  ; caret on the right
GetKeyState alt_state, RAlt  ; followed by a cloze
if (ctrl_state = "D" && shift_state = "D" && alt_state = "D") || (ctrl_state = "D" && alt_state = "D") {
	MsgBox Which one do you want??
	return
}
ControlGetFocus currentFocus, ahk_class TElWind
if (currentFocus = "TMemo2" || currentFocus = "TMemo1") {  ; editing plain text
	MsgBox Sorry, SuperMemo doesn't support f3 search on text components.
	return
}
if (currentFocus != "Internet Explorer_Server2" && currentFocus != "Internet Explorer_Server1") {  ; also not editing html; so no text component is focused
	send ^t{esc}q  ; focus to question field if no field is focused
	sleep 100  ; make sure currentFocus is updated
}
ControlGetFocus currentFocus, ahk_class TElWind
if (currentFocus = "TMemo2" || currentFocus = "TMemo1") {  ; question field is plain text
	MsgBox Sorry, SuperMemo doesn't support f3 search on text components.
	return
}
if (ctrl_state = "D")
	InputBox userInput, Search, Find text in current field. Enter nothing to repeat the last search (highlights will be automatically removed). SMVim will go to visual mode after the search,, 256, 180
else if (alt_state = "D")
	InputBox userInput, Search, Find text in current field. Enter nothing to repeat the last search (highlights will be automatically removed). Your search result will be clozed,, 256, 180
else
	InputBox userInput, Search, Find text in current field. Enter nothing to repeat the last search (highlights will be automatically removed),, 256, 160
if ErrorLevel
	return
if !userInput  ; entered nothing
	userInput := last_search  ; repeat last search
else
	last_search := userInput  ; register userInput into last_search
if !userInput  ; still empty
	return
send {esc}{f3}  ; esc to exit field, so it can return to the same field later
; WinWaitNotActive ahk_class TELWind,, 0  ; double insurance to make sure the enter below does not trigger learn (which sometimes happens in slow computers)
WinWaitActive ahk_class TMyFindDlg,, 0
clip(userInput)  ; clip() has some delay in itself so no need for double insurance
send {enter}
; cannot wait both for element window and message dialogue to be active, nor wait for find window to not be active
; because as soon as you press enter, the find window is gone and element window is active
; and there's nothing to detect if the search is successful or not
; therefore if it behaves weirdly, nothing is found
WinWaitNotActive ahk_class TMyFindDlg,, 0  ; faster than wait for element window to be active
; WinWaitActive ahk_class TELWind,, 0  ; if problematic, use this one
if (shift_state = "D")
	send {right}  ; put caret on right of searched text
else if (ctrl_state = "D")
	Vim.State.SetMode("Vim_VisualChar")
else if (alt_state = "U")  ; all modifier keys are not pressed
	send {left}  ; put caret on right of searched text
send ^{enter}  ; to open commander; convienently, if a "not found" window pops up, this would close it
WinWaitActive ahk_class TCommanderDlg,, 0
if ErrorLevel {
	send {esc}
	SMToolTip("Not found.")
	return
}
send h{enter}
if (alt_state = "D")
	send !z  ; cloze
else if (ctrl_state = "U")  ; alt is up and ctrl is up; shift can be up or down
	send {esc}^t  ; to return to the same field
else if (ctrl_state = "D") {  ; sometimes sm doesn't focus to anything after the search
	WinWaitActive ahk_class TElWind,, 0
	ControlGetFocus currentFocus_after, ahk_class TElWind
	if !currentFocus_after
		ControlFocus %currentFocus%, ahk_class TElWind
}
if WinExist("ahk_class TMyFindDlg") {  ; clears search box window
	WinActivate
	WinWaitActive ahk_class TMyFindDlg,, 0
	send {esc}
}
return
;;;;;;;;;
; GRADING
;;;;;;;;;
#if WinActive("ahk_group " . Vim.GroupName) && Vim.State.Mode == "Vim_Normal"
a::
ControlGetFocus currentFocus, ahk_class TElWind
; if focused on either 5 of the grading buttons or the cancel button
if (currentFocus = "TBitBtn4" || currentFocus = "TBitBtn5" || currentFocus = "TBitBtn6" || currentFocus = "TBitBtn7" || currentFocus = "TBitBtn8" || currentFocus = "TBitBtn9") {
    send 1
    sleep 40
    send {space}  ; next item
; send a in: dialogue windows; not focused on text components (focus to answer field)
} else if (WinActive("ahk_class TMsgDialog") || WinActive("ahk_class TChoicesDlg") || WinActive("ahk_class TChecksDlg")) || (WinActive("ahk_class TElWind") && !(currentFocus = "Internet Explorer_Server2" || currentFocus = "Internet Explorer_Server1" || currentFocus = "TMemo2" || currentFocus = "TMemo1"))
	send a
else {
	send {right}  ; OG: *a*ppend
	Vim.State.SetMode("Insert")
}
return	

s::
if dialogueWindow()
	return
ControlGetFocus currentFocus, ahk_class TElWind
; if focused on either 5 of the grading buttons or the cancel button
if (currentFocus = "TBitBtn4" || currentFocus = "TBitBtn5" || currentFocus = "TBitBtn6" || currentFocus = "TBitBtn7" || currentFocus = "TBitBtn8" || currentFocus = "TBitBtn9") {
	send 2
	sleep 40
	send {space}  ; next item
} else if WinActive("ahk_class TPlanDlg") {  ; *s*witch plan
	coord_x := 253 * A_ScreenDPI / 96
	coord_y := 48 * A_ScreenDPI / 96
	click %coord_x% %coord_y%
} else if WinActive("ahk_class TTaskManager") {  ; *s*witch tasklist
	coord_x := 153 * A_ScreenDPI / 96
	coord_y := 52 * A_ScreenDPI / 96
	click %coord_x% %coord_y%
} else {
	send {del}  ; OG: delete character and *s*ubstitue text
	Vim.State.SetMode("Insert")
}
return

#if (WinActive("ahk_class TElWind") || WinActive("ahk_class TContents") || WinActive("ahk_class TBrowser")) && Vim.State.Mode == "Vim_Normal"
d::
ControlGetFocus currentFocus, ahk_class TElWind
; if focused on either 5 of the grading buttons or the cancel button
if (currentFocus = "TBitBtn4" || currentFocus = "TBitBtn5" || currentFocus = "TBitBtn6" || currentFocus = "TBitBtn7" || currentFocus = "TBitBtn8" || currentFocus = "TBitBtn9") {
	send 3
	sleep 40
	send {space}  ; next item
	return
} else
	WinActivate ahk_class TElWind
MouseMove 40, 380
Vim.Move.Repeat("d")  ; page *d*own
return

f::
ControlGetFocus currentFocus, ahk_class TElWind
; if focused on either 5 of the grading buttons or the cancel button
if (currentFocus = "TBitBtn4" || currentFocus = "TBitBtn5" || currentFocus = "TBitBtn6" || currentFocus = "TBitBtn7" || currentFocus = "TBitBtn8" || currentFocus = "TBitBtn9") {
    send 4
    sleep 40
    send {space}  ; next item
} else {
	WinActivate ahk_class TElWind
	click 40 380  ; left middle
}
return

; g: also for g state