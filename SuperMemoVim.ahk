#NoEnv
SendMode Input

; Auto-execute section
Vim := new VimAhk()
Vim.State.SetNormal()
return

#include %A_LineFile%\..\lib\vim_ahk.ahk

#if WinActive("ahk_class Notepad++") || WinActive("ahk_group " . Vim.GroupName)
^!r::reload