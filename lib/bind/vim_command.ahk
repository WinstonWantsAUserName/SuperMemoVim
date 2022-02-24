setPriority(min, max) {
    send !p
    Random, OutputVar, %min%, %max%
    send %OutputVar%
    send {enter}
}

setTaskValue(min, max) {
	send !v
    Random, OutputVar, %min%, %max%
    send %OutputVar%
	send {tab}
}
;;;;;;;;;;;;;;;;;;;;
; ENTER COMMAND MODE
;;;;;;;;;;;;;;;;;;;;
#if WinActive("ahk_group " . Vim.GroupName) && Vim.State.Mode == "Vim_Normal"
:::
`;::
Vim.State.SetMode("Command")
return

#if WinActive("ahk_group " . Vim.GroupName) && Vim.State.StrIsInCurrentVimMode("Insert")
^`;::Vim.State.SetMode("Command")
;;;;;;;;;;;;;;;;;;;;;;
; FOR ENTIRE SUPERMEMO
;;;;;;;;;;;;;;;;;;;;;;
#if WinActive("ahk_group " . Vim.GroupName) && Vim.State.Mode == "Command"
:::
`;::
Vim.State.SetMode("Vim_Normal")
return
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; FOR ELEMENT WINDOW / CONTENT WINDOW / BROWSER
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
#if (WinActive("ahk_class TElWind") || WinActive("ahk_class TContents") || WinActive("ahk_class TBrowser")) && Vim.State.Mode == "Command"
c::  ; change default *c*oncept group
Vim.State.SetMode("Insert")
WinActivate ahk_class TElWind
coord_x := 724 * A_ScreenDPI / 96
coord_y := 68 * A_ScreenDPI / 96
click %coord_x% %coord_y%
back_to_normal = 1
return

+c::  ; add new concept
Vim.State.SetMode("Insert")
WinActivate ahk_class TElWind
send {alt}er
back_to_normal = 1
return

; priority script
; made by Naess from SuperMemo.wiki discord server, modified by Guillem
; details: https://www.youtube.com/watch?v=OwV5HPKMrbg
; picture explaination: https://raw.githubusercontent.com/rajlego/supermemo-ahk/main/naess%20priorities%2010-25-2020.png

+0::  ; shift+number: for laptop users
NumpadIns::
Vim.State.SetMode("Vim_Normal")
setPriority(0.00,3.6076)
return

+1::
NumpadEnd::
Vim.State.SetMode("Vim_Normal")
setPriority(3.6077,8.4131)
return

+2::
NumpadDown::
Vim.State.SetMode("Vim_Normal")
setPriority(8.4132,18.4917)
return

+3::
NumpadPgdn::
Vim.State.SetMode("Vim_Normal")
setPriority(18.4918,28.0885)
return

+4::
NumpadLeft::
Vim.State.SetMode("Vim_Normal")
setPriority(28.0886,37.2103)
return

+5::
NumpadClear::
Vim.State.SetMode("Vim_Normal")
setPriority(37.2104,46.24)
return

+6::
NumpadRight::
Vim.State.SetMode("Vim_Normal")
setPriority(46.25,57.7575)
return

+7::
NumpadHome::
Vim.State.SetMode("Vim_Normal")
setPriority(57.7576,70.5578)
return

+8::
NumpadUp::
Vim.State.SetMode("Vim_Normal")
setPriority(70.5579,90.2474)
return

+9::
NumpadPgup::
Vim.State.SetMode("Vim_Normal")
setPriority(90.2474,99.99)
return
;;;;;;;;;;;;;;;;;;;;;;;;;
; FOR ELEMENT WINDOW ONLY
;;;;;;;;;;;;;;;;;;;;;;;;;
#if WinActive("ahk_class TElWind") && Vim.State.Mode == "Command"
b::  ; remove all text *b*efore cursor
Vim.State.SetMode("Vim_Normal")
send !\\
WinWaitActive, ahk_class TMsgDialog,, 0
if !ErrorLevel {
	send {enter}
}
return

a::  ; remove all text *a*fter cursor
Vim.State.SetMode("Vim_Normal")
send !.
WinWaitActive, ahk_class TMsgDialog,, 0
if !ErrorLevel {
	send {enter}
}
return

f::  ; clean *f*ormat: using f6 (retaining tables)
Vim.State.SetMode("Vim_Normal")
send {f6}^arbs{enter}
return

g::  ; change element's concept *g*roup
Vim.State.SetMode("Insert")
send ^+p!g
back_to_normal = 1
return

l::  ; *l*ink concept
Vim.State.SetMode("Insert")
send !{f10}cl
back_to_normal = 1
return

w::  ; prepare *w*ikipedia articles in languages other than English
Vim.State.SetMode("Vim_Normal")
send !{f10}fs  ; show reference
WinWaitActive, ahk_class TMsgDialog,, 0
send p{esc}  ; copy reference
IfNotInString, Clipboard, wikipedia.org/wiki, {
	MsgBox not wikipedia!
	return
}
IfInString, Clipboard, en.wikipedia.org, {
	MsgBox English wikipedia doesn't need to be prepared!
	return
}
RegExMatch(Clipboard, "(?<=Link: https:\/\/)(.*?)(?=\/wiki\/)", wiki_link)
send ^t{esc}  ; de-select all components
send ^+{f6}
WinWaitActive, ahk_exe notepad.exe,, 2
if ErrorLevel {
	return
}
send ^h  ; replace
WinWaitActive, Replace,, 0
Clip("en.wikipedia.org")  ; supermemo for some reason replaces the links for English wikipedia ones
send {tab}
sleep 50
Clip(wiki_link)  ; so this script replaces them back
sleep 50
send !a
sleep 200
send ^s
sleep 200
send ^w
if (wiki_link = "zh.wikipedia.org") {
	WinWaitActive, ahk_class TElWind,, 0
	send ^t
	sleep 200
	send ^{home}+{end}
	send +{left 2}+{right}
	send !t
	WinWaitActive, ahk_class TChoicesDlg,, 2
	send 2{enter}
	send {esc}
}
return

i::  ; learn outstanding *i*tems only
Vim.State.SetMode("Vim_Normal")
WinActivate ahk_class TElWind
send !{home}
sleep 100
send {esc 4}{alt}vo
sleep 1200
send {AppsKey}ci
sleep 1000
send ^l
return

r::  ; set *r*eference's link to what's in the clipboard
Vim.State.SetMode("Vim_Normal")
new_link = #Link: %Clipboard%
send !{f10}fe
WinWaitActive, ahk_class TInputDlg,, 0
send ^a^c
ClipWait 1
sleep 100  ; making sure copy works
IfInString, Clipboard, #Link: , {
	ref_link_updated := RegExReplace(Clipboard, "(\n\K|^)#Link: .*", new_link)
	clip(ref_link_updated)
} else {
	send ^{end}{enter}
	clip(new_link)
}
send !{enter}
WinWaitActive, ahk_class TELWind,, 0
if !ErrorLevel {
	send ^t{esc}q
	sleep 50
	send ^{home}{esc}  ; put caret in the start of question component and unfocus every component
}
return
;;;;;;;;;;;;;;;;;
; FOR TASK WINDOW
;;;;;;;;;;;;;;;;;
#if WinActive("ahk_class TElParamDlg") && Vim.State.Mode == "Command"
+0::  ; shift+number: for laptop users
NumpadIns::
setTaskValue(9024.74,9999)
Vim.State.SetMode("Insert")
return

+1::
NumpadEnd::
setTaskValue(7055.79,9024.74)
Vim.State.SetMode("Insert")
return

+2::
NumpadDown::
setTaskValue(5775.76,7055.78)
Vim.State.SetMode("Insert")
return

+3::
NumpadPgdn::
setTaskValue(4625,5775.75)
Vim.State.SetMode("Insert")
return

+4::
NumpadLeft::
setTaskValue(3721.04,4624)
Vim.State.SetMode("Insert")
return

+5::
NumpadClear::
setTaskValue(2808.86,3721.03)
Vim.State.SetMode("Insert")
return

+6::
NumpadRight::
setTaskValue(1849.18,2808.85)
Vim.State.SetMode("Insert")
return

+7::
NumpadHome::
setTaskValue(841.32,1849.17)
Vim.State.SetMode("Insert")
return

+8::
NumpadUp::
setTaskValue(360.77,841.31)
Vim.State.SetMode("Insert")
return

+9::
NumpadPgup::
setTaskValue(0,360.76)
Vim.State.SetMode("Insert")
return