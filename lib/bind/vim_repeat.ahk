#if WinActive("ahk_group " . Vim.GroupName) && Vim.State.StrIsInCurrentVimMode("Vim_")
1::
2::
3::
4::
5::
6::
7::
8::
9::
if gradingAndDialogueWindow()
	return
n_repeat := Vim.State.n*10 + A_ThisHotkey
Vim.State.SetMode("", 0, n_repeat)
SMToolTip(n_repeat, "p")
return

#if WinActive("ahk_group " . Vim.GroupName) && Vim.State.StrIsInCurrentVimMode("Vim_") && Vim.State.n > 0
0::  ; 0 is used as {home} for Vim.State.n=0
n_repeat := Vim.State.n*10
Vim.State.SetMode("", 0, n_repeat)
SMToolTip(n_repeat, "p")
return