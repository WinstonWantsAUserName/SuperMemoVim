#if WinActive("ahk_group " . Vim.GroupName) && !WinActive("ahk_class TChecksDlg")
~^a::Vim.State.SetMode("Vim_VisualChar")

#if WinActive("ahk_group " . Vim.GroupName) && Vim.State.StrIsInCurrentVimMode("Insert")
!v::Vim.State.SetMode("Vim_VisualChar")
;;;;;;;;;;;;;;;;;;
; FROM NORMAL MODE
;;;;;;;;;;;;;;;;;;
#if WinActive("ahk_group " . Vim.GroupName) && Vim.State.Mode == "Vim_Normal"
v::
if dialogueWindow()
	return
Vim.State.SetMode("Vim_VisualChar")
return

+v::
Vim.State.SetMode("Vim_VisualChar")
ControlGetFocus currentFocus, ahk_class TElWind
if (currentFocus = "Internet Explorer_Server2" || currentFocus = "Internet Explorer_Server1")  ; editing html
	send ^{down}^+{up}{left}^+{down}  ; select entire paragraph
else
	send {end}+{home}  ; select entire line
return

!0::
Vim.State.SetMode("Vim_VisualChar")
send +{home}
return

!$::
Vim.State.SetMode("Vim_VisualChar")
send +{end}
return

!{::
Vim.State.SetMode("Vim_VisualChar")
send ^+{up}
return

!}::
Vim.State.SetMode("Vim_VisualChar")
send ^+{down}
return
;;;;;;;;;;;;;;;;;;;;;;
; FOR ENTIRE SUPERMEMO
;;;;;;;;;;;;;;;;;;;;;;
#if WinActive("ahk_group " . Vim.GroupName) && Vim.State.StrIsInCurrentVimMode("Visual")
~^b::  ; bold
~^i::  ; italic
~^u::  ; underline
Vim.State.SetNormal()  ; this function has send {right} built in
return

~^+i::Vim.State.SetMode("Vim_Normal")  ; ignore
v::send {home}+{end}  ; select entire line

.::  ; selected text becomes [...]
Vim.State.SetMode("Vim_Normal", 0, 0, 0)
Clip("<span class=""Cloze"">[...]</span>")
send +^{left 8}^+1
return

f::  ; parse html (*f*ormat)
^+1::
send ^+1
Vim.State.SetMode("Vim_Normal")
return

s::  ; OG: *s*ubstitue
send {bs}
Vim.State.SetMode("Insert")
return

x::  ; backspace
bs::
send {bs}
Vim.State.SetMode("Vim_Normal")
return

y::  ; *y*ank (copy without format)
send ^c
Vim.State.SetNormal()
ClipWait 1
sleep 100
Clipboard := Clipboard
return

+y::  ; yank
send ^c{right}
Vim.State.SetMode("Vim_Normal")
return

+p::  ; paste
^v::
send ^v
Vim.State.SetMode("Vim_Normal")
return

p::  ; paste without format
Clipboard := Clipboard
send ^v
Vim.State.SetMode("Vim_Normal")
return

+d::  ; cut
^x::
send ^x
Vim.State.SetMode("Vim_Normal")
return

d::  ; cut without format
Clipboard := Clipboard
send ^x
Vim.State.SetMode("Vim_Normal")
return

u::  ; lowercase conversion
ConvertLower()
Vim.State.SetNormal()
return

+u::  ; uppercase conversion
ConvertUpper()
Vim.State.SetNormal()
return

n::  ; se*n*tence case conversion
ConvertSentence()
Vim.State.SetNormal()
return

`::  ; cycle through cases
If (cycleNumber==1)
{
ConvertUpper()
cycleNumber:= 2
}
Else If (cycleNumber==2)
{
ConvertLower()
cycleNumber:= 3
}
Else If (cycleNumber==3)
{
ConvertSentence()
cycleNumber:= 4
}
Else
{
ConvertMixed()
cycleNumber:= 1
}
Return

o::  ; OG: move to other end of marked area; not perfect with line breaks
selection_len := StrLen(StrReplace(clip(), "`r"))
; selection_len := StrLen(StrReplace(clip(), "`r`n", "`n"))
send +{right}
selection_right_len := StrLen(StrReplace(clip(), "`r"))
; selection_right_len := StrLen(StrReplace(clip(), "`r`n", "`n"))
send +{left}
if (selection_len < selection_right_len) {  ; moving point of selection is on the right
	send {right}
	; SendInput +{left %selection_len%}
	SendInput % "{shift down}{left " selection_len "}{shift up}"
} else {
	send {left}
	; SendInput +{right %selection_len%}
	SendInput % "{shift down}{right " selection_len "}{shift up}"
}
return
;;;;;;;;;;;;;;;;;;;;;;;;;
; FOR ELEMENT WINDOW ONLY
;;;;;;;;;;;;;;;;;;;;;;;;;
#if WinActive("ahk_class TElWind") && Vim.State.StrIsInCurrentVimMode("Visual")
!x:: ; default SuperMemo shortcut
r::  ; ext*r*act
send !x
Vim.State.SetMode("Vim_Normal")
return

!z:: ; default SuperMemo shortcut
c::  ; *c*loze
send !z
Vim.State.SetMode("Vim_Normal")
return

m::  ; highlight: *m*ark
ControlGetFocus currentFocus, ahk_class TElWind
if (currentFocus = "Internet Explorer_Server2" || currentFocus = "Internet Explorer_Server1")
	send !{f12}rh
Vim.State.SetMode("Vim_Normal")
return

; !d: page *d*own  ; also need to enter normal mode

!u::  ; page *u*p
KeyWait alt
MouseMove 40, 380
send {Wheelup 2}
return

#if WinActive("ahk_class TElWind")
*!+z::
#if WinActive("ahk_class TElWind") && Vim.State.StrIsInCurrentVimMode("Visual")
*!+z::
*+c::  ; cloze hinter
GetKeyState ctrl_state, ctrl
InputBox userInput, Cloze hinter, Please enter your cloze hint.`nIf you enter "hint1/hint2"`, your cloze will be [hint1/hint2]`nIf you enter "hint1/hint2/"`, your cloze will be [...](hint1/hint2),, 256, 196
if ErrorLevel
	return
send !z
Vim.State.SetMode("Vim_Normal")
if !userInput
	return
WinWaitActive ahk_class TMsgDialog,, 0
if !ErrorLevel
	return
SMToolTip("Cloze hinting...", "p")
sleep 1200  ; tried several detection method here, like detecting when the focus control changes or when title changes
send !{left}  ; none of them seems to be stable enough
sleep 300  ; so I had to resort to good old sleep
send q
sleep 50
IfInString userInput, /, {
	cloze := RegExReplace(userInput, "/$")  ; removing the last /
	if (cloze = userInput)  ; no replacement
		cloze = %cloze%]
	else
		cloze = ...](%cloze%)
} else
	cloze = ...](%userInput%)
ControlGetFocus currentFocus, ahk_class TElWind
if (currentFocus = "TMemo2" || currentFocus = "TMemo1") {  ; editing plain text
	send ^a
	clip(StrReplace(clip(), "[...]", cloze))
} else {
	send {f3}
	WinWaitActive ahk_class TMyFindDlg,, 0
	SendInput {raw}[...]
	send {enter}
	WinWaitNotActive ahk_class TMyFindDlg,, 0  ; faster than wait for element window to be active
	; WinWaitActive ahk_class TELWind,, 0  ; if problematic, use this one
	send ^{enter}
	WinWaitActive ahk_class TCommanderDlg,, 0
	if ErrorLevel
		return
	Send h{enter}q{left}{right}  ; put the caret after the [ of [...]
	clip(cloze)
	send {del 4}  ; delete ...]
	if WinExist("ahk_class TMyFindDlg") {  ; clears search box window
		WinActivate
		WinWaitActive ahk_class TMyFindDlg,, 0
		send {esc}
	}
}
if (ctrl_state = "U")  ; only goes back to topic if ctrl is up
	send !{right}  ; add a ctrl to keep editing the clozed item
ToolTip
return