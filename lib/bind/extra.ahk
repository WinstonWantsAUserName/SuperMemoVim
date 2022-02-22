exceptionDialogueWindow() {
	if WinActive("Choices") {
		ControlGetText, currentText1, TGroupButton1
		ControlGetText, currentText2, TGroupButton2
		ControlGetText, currentText3, TGroupButton3
		ControlGetText, currentText4, TGroupButton4
		; when you change the reference of an element that shares the reference with other elements
		; no shortcuts there, so movement keys are used for up/down navigation
		; if more windows are found without shortcuts in the future, they will be all added here
		if (currentText1 = "Cancel (i.e. restore the old version of references)") || (currentText2 = "Combine old and new references for this element") || (currentText3 = "Change references in all elements produced from the original article") || (currentText4 = "Change only the references of the currently displayed element") {
			return true  ; use movement keys
		}
	}
}

dialogueWindow() {
	if exceptionDialogueWindow() {
		return false  ; use movement keys
	}
	if WinActive("ahk_class TMsgDialog") || WinActive("ahk_class TChoicesDlg") || WinActive("ahk_class TChecksDlg") {  ; dialogue windows
		send {%A_ThisHotkey%}
		return true
	}
}

gradingAndDialogueWindow() {
	if exceptionDialogueWindow() {
		return false  ; use movement keys
	}
	; grading buttons and dialogue windows
	ControlGetFocus, currentFocus, ahk_class TElWind
	if (currentFocus = "TBitBtn4" || currentFocus = "TBitBtn5" || currentFocus = "TBitBtn6" || currentFocus = "TBitBtn7" || currentFocus = "TBitBtn8" || currentFocus = "TBitBtn9" || WinActive("ahk_class TMsgDialog") || WinActive("ahk_class TChoicesDlg") || WinActive("ahk_class TChecksDlg")) {
		send {%A_ThisHotkey%}
		return true
	}
}