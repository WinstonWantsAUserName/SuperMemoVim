#if WinActive("ahk_group " . Vim.GroupName) && (Vim.State.StrIsInCurrentVimMode("Vim_"))
+j::Vim.Move.Repeat("+j")
+k::Vim.Move.Repeat("+k")
+w::Vim.Move.Repeat("+w")
+b::Vim.Move.Repeat("+b")
+g::Vim.Move.Repeat("+g")

; SINGLE KEY
h::
if WinActive("ahk_class TMsgDialog") || WinActive("ahk_class TChoicesDlg") || WinActive("ahk_class TChecksDlg") {  ; dialogue windows
	send h
	return
}
Vim.Move.Repeat("h")
return

j::
if WinActive("ahk_class TMsgDialog") || WinActive("ahk_class TChoicesDlg") || WinActive("ahk_class TChecksDlg") {  ; dialogue windows
	send j
	return
}
Vim.Move.Repeat("j")
return

k::
if WinActive("ahk_class TMsgDialog") || WinActive("ahk_class TChoicesDlg") || WinActive("ahk_class TChecksDlg") {  ; dialogue windows
	send k
	return
}
Vim.Move.Repeat("k")
return

l::
if WinActive("ahk_class TMsgDialog") || WinActive("ahk_class TChoicesDlg") || WinActive("ahk_class TChecksDlg") {  ; dialogue windows
	send l
	return
}
Vim.Move.Repeat("l")
return

w::
if WinActive("ahk_class TMsgDialog") || WinActive("ahk_class TChoicesDlg") || WinActive("ahk_class TChecksDlg") {  ; dialogue windows
	send w
	return
}
Vim.Move.Repeat("w")
return

b::
if WinActive("ahk_class TMsgDialog") || WinActive("ahk_class TChoicesDlg") || WinActive("ahk_class TChecksDlg") {  ; dialogue windows
	send b
	return
}
Vim.Move.Repeat("b")
return

0::
if WinActive("ahk_class TMsgDialog") || WinActive("ahk_class TChoicesDlg") || WinActive("ahk_class TChecksDlg") {  ; dialogue windows
	send 0
	return
}
Vim.Move.Move("0")
return

$::
if WinActive("ahk_class TMsgDialog") || WinActive("ahk_class TChoicesDlg") || WinActive("ahk_class TChecksDlg") {  ; dialogue windows
	send $
	return
}
Vim.Move.Move("$")
return

[::
if WinActive("ahk_class TMsgDialog") || WinActive("ahk_class TChoicesDlg") || WinActive("ahk_class TChecksDlg") {  ; dialogue windows
	send [
	return
}
Vim.Move.Repeat("[")
return

]::
if WinActive("ahk_class TMsgDialog") || WinActive("ahk_class TChoicesDlg") || WinActive("ahk_class TChecksDlg") {  ; dialogue windows
	send ]
	return
}
Vim.Move.Repeat("]")
return

{::
if WinActive("ahk_class TMsgDialog") || WinActive("ahk_class TChoicesDlg") || WinActive("ahk_class TChecksDlg") {  ; dialogue windows
	send {
	return
}
Vim.Move.Repeat("{")
return

}::
if WinActive("ahk_class TMsgDialog") || WinActive("ahk_class TChoicesDlg") || WinActive("ahk_class TChecksDlg") {  ; dialogue windows
	send }
	return
}
Vim.Move.Repeat("}")
return