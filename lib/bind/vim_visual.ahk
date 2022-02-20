; FROM NORMAL MODE
#if WinActive("ahk_group " . Vim.GroupName) && (Vim.State.Mode == "Vim_Normal")
v::
if WinActive("ahk_class TMsgDialog") || WinActive("ahk_class TChoicesDlg") || WinActive("ahk_class TChecksDlg") {  ; dialogue windows
	send v
	return
}
Vim.State.SetMode("Vim_VisualChar")
return

+v::
Vim.State.SetMode("Vim_VisualChar")
ControlGetFocus, currentFocus, ahk_class TElWind
if (currentFocus = "Internet Explorer_Server2" || currentFocus = "Internet Explorer_Server1") {  ; editing html
	send ^{down}^+{up}{left}^+{down}  ; select entire paragraph
} else {
	send {home}+{end}  ; select entire line
}
return

~^a::Vim.State.SetMode("Vim_VisualChar")

; FOR ENTIRE SUPERMEMO
#if WinActive("ahk_group " . Vim.GroupName) && (Vim.State.StrIsInCurrentVimMode("Visual"))
~^+i::  ; ignore
~^c::  ; copy
~^b::  ; bold
~^i::  ; italic
~^u::  ; underline
Vim.State.SetMode("Vim_Normal")
send {right}
return

v::send {home}+{end}  ; select entire line

.::  ; selected text becomes [...]
Vim.State.SetMode("Vim_Normal", 0, 0, 0)
Clip("<span class=""Cloze"">[...]</span>")
send +^{left 8}^+1
return

f::  ; parse html (*f*ormat)
^+1::
Vim.State.SetMode("Vim_Normal")
send ^+1
return

x::
bs::  ; backspace
Vim.State.SetMode("Vim_Normal")
send {bs}
return

y::  ; *y*ank (copy without format)
Vim.State.SetMode("Vim_Normal")
send ^c
ClipWait 1
send {right}
sleep 100
Clipboard := Clipboard
return

+y::  ; yank
Vim.State.SetMode("Vim_Normal")
send ^c{right}
return

+p::
^v::  ; paste
Vim.State.SetMode("Vim_Normal")
send ^v
return

p::  ; paste without format
Vim.State.SetMode("Vim_Normal")
Clipboard := Clipboard
send ^v
return

+d::
^x::  ; cut
Vim.State.SetMode("Vim_Normal")
send ^x
return

d::  ; cut without format
Vim.State.SetMode("Vim_Normal")
Clipboard := Clipboard
send ^x
return

g::  ; select everything above
if (A_PriorHotkey != "g" or A_TimeSincePriorHotkey > 400) {  ; Too much time between presses, so this isn't a double-press.
    KeyWait g
    return
}
send +^{home}
return

u::  ; lowercase conversion
Vim.State.SetMode("Vim_Normal")
ConvertLower()
send {right}
return

shift & u::  ; uppercase conversion
Vim.State.SetMode("Vim_Normal")
ConvertUpper()
send {right}
return

s::  ; sentence case conversion
Vim.State.SetMode("Vim_Normal")
ConvertSentence()
send {right}
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

; FOR ELEMENT WINDOW ONLY
!x:: ; default SuperMemo shortcut
e::
Vim.State.SetMode("Vim_Normal", 0, 0, 0)
send !x
return

!z:: ; default SuperMemo shortcut
c::
Vim.State.SetMode("Vim_Normal", 0, 0, 0)
send !z
return

#if WinActive("ahk_class TElWind") && (Vim.State.StrIsInCurrentVimMode("Visual"))
t::  ; highligh*t*
Vim.State.SetMode("Vim_Normal")
ControlGetFocus, currentFocus, ahk_class TElWind
if (currentFocus = "Internet Explorer_Server2" || currentFocus = "Internet Explorer_Server1") {
	send !{f12}rh
}
return