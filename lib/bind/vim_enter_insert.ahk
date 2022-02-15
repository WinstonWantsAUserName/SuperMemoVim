﻿#if WinActive("ahk_group " . Vim.GroupName) && (Vim.State.Mode == "Vim_Normal" || Vim.State.StrIsInCurrentVimMode("Visual"))
i::
if (Vim.State.Mode == "Vim_Normal") && (WinActive("ahk_class TMsgDialog") || WinActive("ahk_class TChoicesDlg") || WinActive("ahk_class TChecksDlg")) {  ; dialogue windows
	send i
	return
}
Vim.State.SetMode("Insert")
return

; FOR ENTIRE SUPERMEMO
#if WinActive("ahk_group " . Vim.GroupName)
shift::Vim.State.SetMode("Insert")

alt::  ; for access keys
Vim.State.SetMode("Insert")
send {alt}
return

AppsKey::  ; menu key
Vim.State.SetMode("Insert")
send {AppsKey}
return

^f::  ; search
Vim.State.SetMode("Insert")
send ^f
back_to_normal = 1
return

^r::  ; replace
Vim.State.SetMode("Insert")
send ^r
back_to_normal = 1
return

RButton::  ; right click
Vim.State.SetMode("Insert")
click right
return

f3::  ; search in article / repeat last search
Vim.State.SetMode("Insert")
send {f3}
WinWaitActive, ahk_class TMyFindDlg,, 0
if !ErrorLevel {
	back_to_normal = 1
} else {
	Vim.State.SetMode("Vim_Normal")
}
return

^j::  ; change interval
if Vim.State.StrIsInCurrentVimMode("Insert") {
	ControlGetFocus, currentFocus, ahk_class TElWind
	if (currentFocus = "Internet Explorer_Server2" || currentFocus = "Internet Explorer_Server1") {  ; editing html
		send ^{down}{left}{enter}
	} else {
		send {end}{enter}
	}
} else if WinActive("ahk_class TElWind") {
	Vim.State.SetMode("Insert")
	send ^j
	back_to_normal = 1
}
return

; FOR ENTIRE SUPERMEMO AND NORMAL MODE
#if WinActive("ahk_group " . Vim.GroupName) && (Vim.State.Mode == "Vim_Normal")
o::  ; OG: new line below current paragraph and insert
if WinActive("ahk_class TMsgDialog") || WinActive("ahk_class TChoicesDlg") || WinActive("ahk_class TChecksDlg") {  ; dialogue windows
	send o
	return
}
ControlGetFocus, currentFocus, ahk_class TElWind
if (currentFocus = "Internet Explorer_Server2" || currentFocus = "Internet Explorer_Server1") {  ; editing html
	send ^{down}{left}{enter}
} else {
	send {end}{enter}
}
Vim.State.SetMode("Insert")
return

+o::  ; OG: new line above current paragraph and insert
ControlGetFocus, currentFocus, ahk_class TElWind
if (currentFocus = "Internet Explorer_Server2" || currentFocus = "Internet Explorer_Server1") {  ; editing html
	send ^+{up}{left}{enter}{up}
} else {
	send {home}{enter}{up}
}
Vim.State.SetMode("Insert")
return

+s::  ; OG: delete paragraph and substitute
ControlGetFocus, currentFocus, ahk_class TElWind
if (currentFocus = "Internet Explorer_Server2" || currentFocus = "Internet Explorer_Server1") {  ; editing html
	send ^{down}{left}{enter}^+{up}{bs}
} else {
	send {end}+{home}{bs}
}
Vim.State.SetMode("Insert")
return

+i::  ; OG: go to beginning of paragraph and *i*nsert
ControlGetFocus, currentFocus, ahk_class TElWind
if (currentFocus = "Internet Explorer_Server2" || currentFocus = "Internet Explorer_Server1") {  ; editing html
	send ^+{up}{left}
} else {
	send {home}
}
Vim.State.SetMode("Insert")
return

+a::  ; OG: go to end of paragraph and insert (*a*ppend)
ControlGetFocus, currentFocus, ahk_class TElWind
if (currentFocus = "Internet Explorer_Server2" || currentFocus = "Internet Explorer_Server1") {  ; editing html
	send ^{down}{left}
} else {
	send {end}
}
Vim.State.SetMode("Insert")
return

; FOR ELEMENT AND CONTENT WINDOW, AND BROWSER
#if WinActive("ahk_class TElWind") || WinActive("ahk_class TContents") || WinActive("ahk_class TBrowser")
^!.::  ; find [...] and insert
Vim.State.SetMode("Insert")
WinActivate ahk_class TElWind
send {f3}
WinWaitActive, ahk_class TMyFindDlg,, 0
clip("[...]")
send {enter}
WinWaitActive, ahk_class TElWind,, 0
send {right}^{enter}
WinWaitActive, ahk_class TCommanderDlg,, 0
send h{enter}q
if WinExist("ahk_class TMyFindDlg") {  ; clears search box window
	WinActivate
	WinWaitActive, ahk_class TMyFindDlg,, 0
	send {esc}
}
return

!p::  ; change priority
Vim.State.SetMode("Insert")
send !p
back_to_normal = 1
return

^!+j::  ; later today: remapped to ctrl+shift+alt+J
Vim.State.SetMode("Insert")
ControlGetText, currentText, TBitBtn3
send ^+j
back_to_normal = 1
return

^!+m::  ; remember: remapped to ctrl+shift+alt+M
Vim.State.SetMode("Insert")
send ^m
back_to_normal = 1
return

; FOR ELEMENT WINDOW ONLY
#if WinActive("ahk_class TElWind")
^o::  ; switch collection
Vim.State.SetMode("Insert")
send ^o
back_to_normal = 1
return

f6::  ; format
Vim.State.SetMode("Insert")
send {f6}
back_to_normal = 1
return

^+p::  ; comments
Vim.State.SetMode("Insert")
send ^+p
back_to_normal = 1
return

^+m::  ; change template
Vim.State.SetMode("Insert")
send ^+m
back_to_normal = 1
return

^enter::  ; commander
Vim.State.SetMode("Insert")
send ^{enter}
back_to_normal = 1
return

!q::  ; add references
Vim.State.SetMode("Insert")
send !q
back_to_normal = 1
return

^f3::  ; search
Vim.State.SetMode("Insert")
send ^{f3}
back_to_normal = 2
return

!f10::  ; element menu
Vim.State.SetMode("Insert")
KeyWait alt  ; without this the menu disappears
send !{f10}
return

!f12::  ; component menu
Vim.State.SetMode("Insert")
KeyWait alt  ; without this the menu disappears
send !{f12}
return

!a::  ; add new item
Vim.State.SetMode("Insert")
send !a
return

!n::  ; add new topic
Vim.State.SetMode("Insert")
send !n
return

!k::  ; YT: pause and focus on the 2nd html component (note editing)
KeyWait alt
Vim.State.SetMode("Insert")
click 75 630
send ^{t 2}
return

!y::  ; YT: focus onto 1st html component (YT video)
KeyWait alt
Vim.State.SetMode("Insert")
click 195 645
return

!r::  ; rename
send !r
WinWaitActive, ahk_class TInputDlg,, 0
if !ErrorLevel {
	Vim.State.SetMode("Insert")
}
return

!f1::  ; add task
Vim.State.SetMode("Insert")
send !{f1}
back_to_normal = 1
return

; FOR IMPORT DIALOGUE ONLY
#if WinActive("ahk_class TWebDlg")
!t::  ; edit title during import
Vim.State.SetMode("Insert")
send !t
return

!g::  ; choose concept group during import
Vim.State.SetMode("Insert")
send !g
return

!m::  ; change minimum priority during import
Vim.State.SetMode("Insert")
send !m
return

!x::  ; change maximum priority during import
Vim.State.SetMode("Insert")
send !x
return

; FOR PLAN WINDOW ONLY
#if WinActive("ahk_class TPlanDlg")
insert::
NumpadIns::
Vim.State.SetMode("Insert")
send {insert}
return

^t::  ; split activity
Vim.State.SetMode("Insert")
send ^t
back_to_normal = 1
return

!m::  ; plan manu
Vim.State.SetMode("Insert")
KeyWait alt  ; without this the menu disappears
send !m
return

; FOR CONTENT WINDOW ONLY
#if WinActive("ahk_class TContents")
f2::  ; rename element in content window
Vim.State.SetMode("Insert")
send {f2}
back_to_normal = 1
return