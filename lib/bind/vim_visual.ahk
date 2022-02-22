#if WinActive("ahk_group " . Vim.GroupName)
~^a::Vim.State.SetMode("Vim_VisualChar")
;;;;;;;;;;;;;;;;;;
; FROM NORMAL MODE
;;;;;;;;;;;;;;;;;;
#if WinActive("ahk_group " . Vim.GroupName) && Vim.State.Mode == "Vim_Normal"
v::
if dialogueWindow() {
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
~^c::  ; copy
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
Vim.State.SetMode("Vim_Normal")
send ^+1
return

x::  ; backspace
bs::
Vim.State.SetMode("Vim_Normal")
send {bs}
return

y::  ; *y*ank (copy without format)
send ^c
Vim.State.SetNormal()
ClipWait 1
sleep 100
Clipboard := Clipboard
return

+y::  ; yank
Vim.State.SetMode("Vim_Normal")
send ^c{right}
return

+p::  ; paste
^v::
Vim.State.SetMode("Vim_Normal")
send ^v
return

p::  ; paste without format
Vim.State.SetMode("Vim_Normal")
Clipboard := Clipboard
send ^v
return

+d::  ; cut
^x::
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
ConvertLower()
Vim.State.SetNormal()
return

; +u: uppercase conversion  ; also for going up

s::  ; sentence case conversion
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
;;;;;;;;;;;;;;;;;;;;;;;;;
; FOR ELEMENT WINDOW ONLY
;;;;;;;;;;;;;;;;;;;;;;;;;
#if WinActive("ahk_class TElWind") && Vim.State.StrIsInCurrentVimMode("Visual")
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

t::  ; highligh*t*
Vim.State.SetMode("Vim_Normal")
ControlGetFocus, currentFocus, ahk_class TElWind
if (currentFocus = "Internet Explorer_Server2" || currentFocus = "Internet Explorer_Server1") {
	send !{f12}rh
}
return

; !d: page *d*own  ; also need to enter normal mode

!u::  ; page *u*p
KeyWait alt
MouseMove 40, 380
send {Wheelup 2}
return