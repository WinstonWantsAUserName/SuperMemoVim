#if WinActive("ahk_group " . Vim.GroupName) && (Vim.State.Mode == "Vim_Normal" || Vim.State.StrIsInCurrentVimMode("Visual"))
i::
if dialogueWindow()
	return
Vim.State.SetMode("Insert")
return
;;;;;;;;;;;;;;;;;;;;;;
; FOR ENTIRE SUPERMEMO
;;;;;;;;;;;;;;;;;;;;;;
#if WinActive("ahk_group " . Vim.GroupName)
shift::  ; shift: always go to insert mode
~AppsKey::  ; menu key
~RButton::  ; right click
~^+a::  ; select all: differs from ^a (which enters visual), this one enters insert
Vim.State.SetMode("Insert")
return

~^f::  ; search
~^r::  ; replace
Vim.State.SetMode("Insert")
back_to_normal = 1
return

alt::  ; for access keys
; can't use KeyWait alt, any hotkeys that use modifier alt would trigger this script
Vim.State.SetMode("Insert")
send {alt}  ; cannot use tilde, because you wouldn't want other keys like alt+d to go to insert
return

LAlt & RAlt::  ; for laptop
KeyWait LAlt
KeyWait RAlt
send {AppsKey}
Vim.State.SetMode("Insert")
return

f3::  ; search in article / repeat last search
send {f3}
Vim.State.SetMode("Insert")
WinWaitActive ahk_class TMyFindDlg,, 0
if !ErrorLevel
	back_to_normal = 1
else
	Vim.State.SetMode("Vim_Normal")
return

^j::  ; change interval
if Vim.State.StrIsInCurrentVimMode("Insert") {  ; new line below current paragraph in insert mode
	KeyWait ctrl
	ControlGetFocus currentFocus, ahk_class TElWind
	if (currentFocus = "Internet Explorer_Server2" || currentFocus = "Internet Explorer_Server1")  ; editing html
		send ^{down}{left}{enter}
	else
		send {end}{enter}
} else if WinActive("ahk_class TElWind") {
	Vim.State.SetMode("Insert")
	send ^j
	back_to_normal = 1
}
return

~!r::  ; rename
WinWaitActive ahk_class TInputDlg,, 0
if !ErrorLevel
	Vim.State.SetMode("Insert")
return
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; FOR ENTIRE SUPERMEMO & NORMAL MODE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
#if WinActive("ahk_group " . Vim.GroupName) && Vim.State.Mode == "Vim_Normal"
~!p::  ; change priority
Vim.State.SetMode("Insert")
back_to_normal = 1
return

o::  ; OG: new line below current paragraph and insert
if dialogueWindow()
	return
ControlGetFocus currentFocus, ahk_class TElWind
if (currentFocus = "Internet Explorer_Server2" || currentFocus = "Internet Explorer_Server1")  ; editing html
	send ^{down}{left}{enter}
else
	send {end}{enter}
Vim.State.SetMode("Insert")
return

!o::  ; force new line below current line when editing html
ControlGetFocus currentFocus, ahk_class TElWind
if (currentFocus = "Internet Explorer_Server2" || currentFocus = "Internet Explorer_Server1") {  ; editing html
	send {end}{enter}
	Vim.State.SetMode("Insert")
} else
	send !o
return

+o::  ; OG: new line above current paragraph and insert
ControlGetFocus currentFocus, ahk_class TElWind
if (currentFocus = "Internet Explorer_Server2" || currentFocus = "Internet Explorer_Server1")  ; editing html
	send ^{down}^+{up}{left}{enter}{up}
else
	send {home}{enter}{up}
Vim.State.SetMode("Insert")
return

!+o::  ; force new line above current line when editing html
ControlGetFocus currentFocus, ahk_class TElWind
if (currentFocus = "Internet Explorer_Server2" || currentFocus = "Internet Explorer_Server1") {  ; editing html
	send {home}{enter}{up}
	Vim.State.SetMode("Insert")
} else
	send !+o
return

+s::  ; OG: delete paragraph and substitute
ControlGetFocus currentFocus, ahk_class TElWind
if (currentFocus = "Internet Explorer_Server2" || currentFocus = "Internet Explorer_Server1")  ; editing html
	send ^{down}{left}{enter}^+{up}{bs}
else
	send {end}+{home}{bs}
Vim.State.SetMode("Insert")
return

!s::  ; force substitute line when editing html
ControlGetFocus currentFocus, ahk_class TElWind
if (currentFocus = "Internet Explorer_Server2" || currentFocus = "Internet Explorer_Server1") {  ; editing html
	send {end}+{home}{bs}
	Vim.State.SetMode("Insert")
} else
	send +!s
return

+i::  ; OG: go to start of paragraph and *i*nsert
ControlGetFocus currentFocus, ahk_class TElWind
if (currentFocus = "Internet Explorer_Server2" || currentFocus = "Internet Explorer_Server1")  ; editing html
	send ^+{up}{left}
else
	send {home}
Vim.State.SetMode("Insert")
return

!+i::  ; force go to start of line and insert when editing html
ControlGetFocus currentFocus, ahk_class TElWind
if (currentFocus = "Internet Explorer_Server2" || currentFocus = "Internet Explorer_Server1") {  ; editing html
	send {home}
	Vim.State.SetMode("Insert")
} else
	send +!s
return

+a::  ; OG: go to end of paragraph and insert (*a*ppend)
ControlGetFocus currentFocus, ahk_class TElWind
if (currentFocus = "Internet Explorer_Server2" || currentFocus = "Internet Explorer_Server1")  ; editing html
	send ^{down}{left}
else
	send {end}
Vim.State.SetMode("Insert")
return

!+a::  ; force go to end of paragraph and insert when editing html
ControlGetFocus currentFocus, ahk_class TElWind
if (currentFocus = "Internet Explorer_Server2" || currentFocus = "Internet Explorer_Server1") {  ; editing html
	send {end}
	Vim.State.SetMode("Insert")
} else
	send +!a
return
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; FOR ELEMENT WINDOW / CONTENT WINDOW / BROWSER
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
#if WinActive("ahk_class TElWind") || WinActive("ahk_class TContents") || WinActive("ahk_class TBrowser")
^!.::  ; find [...] and insert
WinActivate ahk_class TElWind
send ^t{esc}q
sleep 10
send {f3}
WinWaitNotActive ahk_class TELWind,, 0  ; double insurance to make sure the enter below does not trigger learn (which sometimes happens in slow computers)
WinWaitActive ahk_class TMyFindDlg,, 0
SendInput {raw}[...]
send {enter}
WinWaitNotActive ahk_class TMyFindDlg,, 0  ; faster than wait for element window to be active
; WinWaitActive ahk_class TELWind,, 0  ; if problematic, use this one
send {right}^{enter}
WinWaitActive ahk_class TCommanderDlg,, 0
if ErrorLevel
	return
send h{enter}q
if WinExist("ahk_class TMyFindDlg") {  ; clears search box window
	WinActivate
	WinWaitActive ahk_class TMyFindDlg,, 0
	send {esc}
}
Vim.State.SetMode("Insert")
return

^!+j::  ; later today: remapped to ctrl+shift+alt+J
Vim.State.SetMode("Insert")
send ^+j
back_to_normal = 1
return

^!+m::  ; remember: remapped to ctrl+shift+alt+M
Vim.State.SetMode("Insert")
send ^m
back_to_normal = 1
return

^!+g::  ; change element's concept *g*roup
Vim.State.SetMode("Insert")
send ^+p!g
back_to_normal = 1
return
;;;;;;;;;;;;;;;;;;;;;;;;;
; FOR ELEMENT WINDOW ONLY
;;;;;;;;;;;;;;;;;;;;;;;;;
#if WinActive("ahk_class TElWind")
~^o::  ; switch collection
~f6::  ; format
~^+m::  ; change template
~^enter::  ; commander
~!q::  ; add references
~!f10::  ; element menu
~!f12::  ; component menu
~!a::  ; add new item
~!n::  ; add new topic
~!+x::  ; extract with priority
Vim.State.SetMode("Insert")
back_to_normal = 1
return

^f3::  ; search
#if WinActive("ahk_class TElWind") && Vim.State.StrIsInCurrentVimMode("Vim_")
\::
send ^{f3}
Vim.State.SetMode("Insert")
back_to_normal = 2
return
;;;;;;;;;;;;;;;;;;;;;;;;;;
; FOR IMPORT DIALOGUE ONLY
;;;;;;;;;;;;;;;;;;;;;;;;;;
#if WinActive("ahk_class TWebDlg")
~!t::  ; edit title during import
~!g::  ; choose concept group during import
~!m::  ; change minimum priority during import
~!x::  ; change maximum priority during import
Vim.State.SetMode("Insert")
return
;;;;;;;;;;;;;;;;;;;;;;
; FOR PLAN WINDOW ONLY
;;;;;;;;;;;;;;;;;;;;;;
#if WinActive("ahk_class TPlanDlg")
~insert::
~NumpadIns::
~!m::  ; plan manu
Vim.State.SetMode("Insert")
return

~^t::  ; split activity
Vim.State.SetMode("Insert")
back_to_normal = 1
return
;;;;;;;;;;;;;;;
; OTHER WINDOWS
;;;;;;;;;;;;;;;
#if WinActive("ahk_class TContents") || WinActive("ahk_class TPlanDlg")
~f2::  ; rename
Vim.State.SetMode("Insert")
if WinActive("ahk_class TContents")
	back_to_normal = 1
return

#if WinActive("ahk_class TElWind") || WinActive("ahk_class TTaskManager")
~!f1::  ; add task
#if WinActive("ahk_class TElWind") || WinActive("ahk_class TContents") || WinActive("ahk_class TBrowser") || WinActive("ahk_class TTaskManager")
~^+p::  ; element parameter
#if WinActive("ahk_class TElParamDlg")
~!t::  ; task time
Vim.State.SetMode("Insert")
back_to_normal = 1
return