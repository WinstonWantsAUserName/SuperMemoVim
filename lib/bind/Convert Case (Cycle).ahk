; Huge thanks to:
; https://geekdrop.com/content/super-handy-autohotkey-ahk-script-to-change-the-case-of-text-in-line-or-wrap-text-in-quotes
; J. Scott Elblein | GeekDrop.com

#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%

cycleNumber := 1

#IfWinNotActive ahk_class XLMAIN

ConvertUpper()
{
	clipSave := Clipboard
	Clipboard = ; Empty the clipboard so that ClipWait has something to detect
	SendInput, ^c ; Copies selected text
	ClipWait
	StringReplace, Clipboard, Clipboard, `r`n, `n, All ; Fix for SendInput sending Windows linebreaks 
	StringUpper, Clipboard, Clipboard
	Len:= Strlen(Clipboard)
    SendInput, ^v ; Pastes new text
	Send +{left %Len%}
    VarSetCapacity(clipSave, 0) ; Free memory
	Clipboard := clipSave
}

ConvertLower()
{
	clipSave := Clipboard
	Clipboard = ; Empty the clipboard so that ClipWait has something to detect
	SendInput, ^c ; Copies selected text
	ClipWait
	StringReplace, Clipboard, Clipboard, `r`n, `n, All ; Fix for SendInput sending Windows linebreaks
	StringLower, Clipboard, Clipboard
	Len:= Strlen(Clipboard)
    SendInput, ^v ; Pastes new text
	Send +{left %Len%}
    VarSetCapacity(clipSave, 0) ; Free memory
	Clipboard := clipSave
}

ConvertSentence()
{
	clipSave := Clipboard
	Clipboard = ; Empty the clipboard so that ClipWait has something to detect
	SendInput, ^c ; Copies selected text
	ClipWait
	StringReplace, Clipboard, Clipboard, `r`n, `n, All ; Fix for SendInput sending Windows linebreaks
	StringLower, Clipboard, Clipboard
	Clipboard := RegExReplace(Clipboard, "(((^|([.!?]+\s+))[a-z])| i | i')", "$u1")
	Len:= Strlen(Clipboard)
    SendInput, ^v ; Pastes new text
	Send +{left %Len%}
    VarSetCapacity(clipSave, 0) ; Free memory
	Clipboard := clipSave
}

ConvertMixed()
{
	clipSave := Clipboard
	Clipboard = ; Empty the clipboard so that ClipWait has something to detect
	SendInput, ^c ; Copies selected text
	ClipWait
	StringReplace, Clipboard, Clipboard, `r`n, `n, All ; Fix for SendInput sending Windows linebreaks
	StringUpper Clipboard, Clipboard, T
	Len:= Strlen(Clipboard)
    SendInput, ^v ; Pastes new text
	Send +{left %Len%}
    VarSetCapacity(clipSave, 0) ; Free memory
	Clipboard := clipSave
}
/*
#IfWinNotActive

; CTRL + ALT + Q: Wrap selected text in double quotes
^!q::
	clipSave := Clipboard
	Clipboard = ; Empty the clipboard so that ClipWait has something to detect
	SendInput, ^c ; Copies selected text
	ClipWait
	StringReplace, Clipboard, Clipboard, `r`n, `n, All ; Fix for SendInput sending Windows linebreaks
	Clipboard := Chr(34) . Clipboard . Chr(34)
	Len:= Strlen(Clipboard)
    SendInput, ^v ; Pastes new text
	Send +{left %Len%}
    VarSetCapacity(clipSave, 0) ; Free memory
	Clipboard := clipSave
Return

; RELOAD
!+^x::
   SplashTextOn,,,Updated script,
   Sleep,200
   SplashTextOff
   Reload
   Send, ^s
Return