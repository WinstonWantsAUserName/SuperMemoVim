; gg
#if WinActive("ahk_group " . Vim.GroupName) && Vim.State.StrIsInCurrentVimMode("Vim_") && !Vim.State.g
g::
if (Vim.State.Mode == "Vim_Normal")  ; ignore all this in visual mode
	if dialogueWindow()
		return
	ControlGetFocus currentFocus, ahk_class TElWind
	; if focused on either 5 of the grading buttons or the cancel button
	if (currentFocus = "TBitBtn4" || currentFocus = "TBitBtn5" || currentFocus = "TBitBtn6" || currentFocus = "TBitBtn7" || currentFocus = "TBitBtn8" || currentFocus = "TBitBtn9") {
		send 5
		sleep 40
		send {space}  ; next item
		return
	}
	if Vim.State.n > 0 {
		Vim.State.SetMode("", 1, -1)
		SMToolTip(n_repeat . "g", "p")
		return
	}
Vim.State.SetMode("", 1)
SMToolTip("g", "p")
return
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; G STATE: VISUAL AND NORMAL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
#if WinActive("ahk_group " . Vim.GroupName) && Vim.State.StrIsInCurrentVimMode("Vim_") && Vim.State.g
g::
if Vim.State.n > 0 {
	n_repeat -= 1
	Vim.State.SetMode("", 0, n_repeat)
	ControlGetFocus currentFocus, ahk_class TElWind
	if (currentFocus = "Internet Explorer_Server2" || currentFocus = "Internet Explorer_Server1" || currentFocus = "TMemo2" || currentFocus = "TMemo1")  ; editing text
		send ^{home}
	else {
		send ^t{esc}q
		sleep 100
		ControlGetFocus currentFocus, ahk_class TElWind
		if (currentFocus = "Internet Explorer_Server2" || currentFocus = "Internet Explorer_Server1" || currentFocus = "TMemo2" || currentFocus = "TMemo1")  ; editing text
			send ^{home}
	}
	if Vim.State.n > 0
		Vim.Move.Repeat("j")  ; go down x lines from top of article
	ToolTip
	Vim.State.SetMode("", 0, 0)
	return
}
Vim.Move.Move("g")  ; OG: move to top
ToolTip
return

e::
Vim.Move.Repeat("ge")  ; SEMI-OG: move to end of previous word
ToolTip
return
;;;;;;;;;;;;;;;;;;;;;;;;;;;
; G STATE: NORMAL MODE ONLY
;;;;;;;;;;;;;;;;;;;;;;;;;;;
#if WinActive("ahk_group " . Vim.GroupName) && Vim.State.Mode == "Vim_Normal" && Vim.State.g
u::  ; lowercase conversion
ControlGetFocus currentFocus, ahk_class TElWind
if (currentFocus = "Internet Explorer_Server2" || currentFocus = "Internet Explorer_Server1")  ; editing html
	send ^{down}{left}^+{up}
else
	send {end}+{home}
ConvertLower()
Vim.State.SetNormal()
send {right}
ToolTip
return

!u::  ; lowercase conversion
ControlGetFocus currentFocus, ahk_class TElWind
if (currentFocus = "Internet Explorer_Server2" || currentFocus = "Internet Explorer_Server1") {  ; editing html
	send {end}+{home}
	ConvertLower()
	send {right}
}
Vim.State.SetNormal()
ToolTip
return

+u::  ; uppercase conversion
ControlGetFocus currentFocus, ahk_class TElWind
if (currentFocus = "Internet Explorer_Server2" || currentFocus = "Internet Explorer_Server1")  ; editing html
	send ^{down}{left}^+{up}
else
	send {end}+{home}
ConvertUpper()
Vim.State.SetNormal()
send {right}
ToolTip
return

!+u::  ; uppercase conversion
ControlGetFocus currentFocus, ahk_class TElWind
if (currentFocus = "Internet Explorer_Server2" || currentFocus = "Internet Explorer_Server1") {  ; editing html
	send {end}+{home}
	ConvertUpper()
	send {right}
}
Vim.State.SetNormal()
ToolTip
return

n::  ; se*n*tence case conversion
ControlGetFocus currentFocus, ahk_class TElWind
if (currentFocus = "Internet Explorer_Server2" || currentFocus = "Internet Explorer_Server1")  ; editing html
	send ^{down}{left}^+{up}
else
	send {end}+{home}
ConvertSentence()
Vim.State.SetNormal()
send {right}
ToolTip
return

!n::  ; se*n*tence case conversion
ControlGetFocus currentFocus, ahk_class TElWind
if (currentFocus = "Internet Explorer_Server2" || currentFocus = "Internet Explorer_Server1") {  ; editing html
	send {end}+{home}
	ConvertSentence()
	send {right}
}
Vim.State.SetNormal()
ToolTip
return

`::  ; cycle through cases
ControlGetFocus currentFocus, ahk_class TElWind
if (currentFocus = "Internet Explorer_Server2" || currentFocus = "Internet Explorer_Server1")  ; editing html
	send ^{down}{left}^+{up}
else
	send {end}+{home}
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
Vim.State.SetNormal()
send {right}
ToolTip
Return

!`::  ; cycle through cases
ControlGetFocus currentFocus, ahk_class TElWind
if (currentFocus = "Internet Explorer_Server2" || currentFocus = "Internet Explorer_Server1") {  ; editing html
	send {end}+{home}
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
	send {right}
}
Vim.State.SetNormal()
ToolTip
Return

; for enter repeat numbers like 40
#if WinActive("ahk_group " . Vim.GroupName) && Vim.State.StrIsInCurrentVimMode("Vim_") && Vim.State.n = 0
0::
if gradingAndDialogueWindow()
	return
Vim.Move.Move("0")
return

#if WinActive("ahk_group " . Vim.GroupName) && Vim.State.StrIsInCurrentVimMode("Vim_")
h::
l::
w::
e::  ; SEMI-OG; not perfect
[::
]::
if dialogueWindow()
	return
Vim.Move.Repeat(A_ThisHotkey)
return

$::
if dialogueWindow()
	return
Vim.Move.Move("$")
return

+g::  ; OG: go to start of last line
if (WinActive("ahk_class TElWind") || WinActive("ahk_class TContents") || WinActive("ahk_class TBrowser")) && Vim.State.n = 0 {
	ControlGetFocus currentFocus, ahk_class TElWind
	if (currentFocus != "Internet Explorer_Server2" && currentFocus != "Internet Explorer_Server1" && currentFocus != "TMemo2" && currentFocus != "TMemo1") {  ; not editing text
		send {end}
		return
	}
}
if Vim.State.n > 0 {
	n_repeat -= 1
	Vim.State.SetMode("", 0, n_repeat)
	coord_x := 40 * A_ScreenDPI / 96
	coord_y := 115 * A_ScreenDPI / 96
	click %coord_x% %coord_y%
	send {home}
	if Vim.State.n > 0
		Vim.Move.Repeat("j")  ; go down x lines from top of article
	ToolTip
	Vim.State.SetMode("", 0, 0)
	return
} else {
	Vim.Move.Move("+g")
	ControlGetFocus currentFocus, ahk_class TElWind
	if (currentFocus = "Internet Explorer_Server2" || currentFocus = "Internet Explorer_Server1") {  ; editing html
		send ^+{up}  ; if there are references this would select (or deselect in visual mode) them all
		if Vim.State.StrIsInCurrentVimMode("Visual")
			send +{down}  ; go down one line, if there are references this would include the #SuperMemo Reference
		selection := clip()
		IfInString selection, #SuperMemo Reference:
			if Vim.State.StrIsInCurrentVimMode("Visual")
				send +{up 4}  ; select until start of last line
			else
				send {up 3}  ; go to start of last line
		else
			Vim.Move.Move("+g")
	}
}
return

; pgdn/pgup when not focused on text
j::
ControlGetFocus currentFocus, ahk_class TElWind
if WinActive("ahk_class TElWind") && (currentFocus != "Internet Explorer_Server2" && currentFocus != "Internet Explorer_Server1" && currentFocus != "TMemo2" && currentFocus != "TMemo1")  ; not editing text
	send {pgdn}
else
	Vim.Move.Repeat("j")
return

k::
ControlGetFocus currentFocus, ahk_class TElWind
if WinActive("ahk_class TElWind") && (currentFocus != "Internet Explorer_Server2" && currentFocus != "Internet Explorer_Server1" && currentFocus != "TMemo2" && currentFocus != "TMemo1")  ; not editing text
	send {pgup}
else
	Vim.Move.Repeat("k")
return

b::  ; browser
ControlGetFocus currentFocus, ahk_class TElWind
if WinActive("ahk_class TElWind") && (currentFocus != "Internet Explorer_Server2" && currentFocus != "Internet Explorer_Server1" && currentFocus != "TMemo2" && currentFocus != "TMemo1") {  ; editing text
	send ^{space}
	return
}
ControlGetFocus currentFocus, ahk_class TContents
if WinActive("ahk_class TContents") && (currentFocus = "TVirtualStringTree1") {
	send ^{space}
	return
}
Vim.Move.Repeat("b")
return

; disable { and } if not focused on html
{::  ; requires ctrl+shift+up; clashes with turning up priority
}::  ; in text component, this would also mess with the priority if not disabled
; after all, going up/down a paragraph only makes sense in html
ControlGetFocus currentFocus, ahk_class TElWind
if (currentFocus != "Internet Explorer_Server2" && currentFocus != "Internet Explorer_Server1")  ; not editing html
	return
Vim.Move.Repeat(A_ThisHotkey)
return