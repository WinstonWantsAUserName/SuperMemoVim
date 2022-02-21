dialogueWindow() {
	if WinActive("ahk_class TMsgDialog") || WinActive("ahk_class TChoicesDlg") || WinActive("ahk_class TChecksDlg") {  ; dialogue windows
		send {%A_ThisHotkey%}
		return true
	} else {
		return false
	}
}

gradingAndDialogueWindow() {
	; grading buttons and dialogue windows
	ControlGetFocus, currentFocus, ahk_class TElWind
	if (currentFocus = "TBitBtn4" || currentFocus = "TBitBtn5" || currentFocus = "TBitBtn6" || currentFocus = "TBitBtn7" || currentFocus = "TBitBtn8" || currentFocus = "TBitBtn9" || WinActive("ahk_class TMsgDialog") || WinActive("ahk_class TChoicesDlg") || WinActive("ahk_class TChecksDlg")) {
		send {%A_ThisHotkey%}
		return true
	} else {
		return false
	}
}