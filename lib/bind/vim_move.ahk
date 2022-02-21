#if WinActive("ahk_group " . Vim.GroupName) && (Vim.State.StrIsInCurrentVimMode("Vim_"))
+j::
+k::
+w::
+b::
+g::
Vim.Move.Repeat(A_ThisHotkey)
return

; SINGLE KEY
h::
j::
k::
l::
w::
b::
[::
]::
{::
}::
if dialogueWindow() {
	return
}
Vim.Move.Repeat(A_ThisHotkey)
return

0::
if gradingAndDialogueWindow() {
	return
}
Vim.Move.Move("0")
return

$::
if dialogueWindow() {
	return
}
Vim.Move.Move("$")
return