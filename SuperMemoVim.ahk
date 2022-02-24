#NoEnv
SendMode Input
SetKeyDelay, 20, 20

; Auto-execute section
Vim := new VimAhk()
Vim.State.SetNormal()
Return

#Include %A_LineFile%\..\lib\vim_ahk.ahk

#if WinActive("ahk_class Notepad++") || WinActive("ahk_group " . Vim.GroupName)
^!r::Reload