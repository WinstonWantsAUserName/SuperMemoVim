; Clip() - Send and Retrieve Text Using the Clipboard
; https://www.autohotkey.com/boards/viewtopic.php?f=6&t=62156

Clip(Text="", Reselect="")
{
	Static BackupClip, Stored, LastClip
	If (A_ThisLabel = A_ThisFunc) {
		If (Clipboard == LastClip)
			Clipboard := BackupClip
		BackupClip := LastClip := Stored := ""
	} Else {
		If !Stored {
			Stored := True
			BackupClip := ClipboardAll ; ClipboardAll must be on its own line
		} Else
			SetTimer, %A_ThisFunc%, Off
		LongCopy := A_TickCount, Clipboard := "", LongCopy -= A_TickCount ; LongCopy gauges the amount of time it takes to empty the clipboard which can predict how long the subsequent clipwait will need
		If (Text = "") {
			SendInput, ^c
			ClipWait, LongCopy ? 0.6 : 0.2, True
		} Else {
			Clipboard := LastClip := Text
			ClipWait, 10
			SendInput, ^v
		}
		SetTimer, %A_ThisFunc%, -700
		Sleep 20 ; Short sleep in case Clip() is followed by more keystrokes such as {enter}
		If (Text = "")
			return LastClip := Clipboard
		Else If ReSelect and ((ReSelect = True) or (StrLen(Text) < 3000))
			SendInput, % "{shift down}{left " StrLen(StrReplace(Text, "`r")) "}{shift up}"
	}
	return
	Clip:
	return Clip()
}