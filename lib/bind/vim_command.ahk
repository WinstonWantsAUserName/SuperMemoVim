﻿; FOR NORMAL MODE: ENTER COMMAND MODE
#if WinActive("ahk_group " . Vim.GroupName) && (Vim.State.Mode == "Vim_Normal")
:::Vim.State.SetMode("Command")
`;::Vim.State.SetMode("Command")

; FOR ENTIRE SUPERMEMO
#if WinActive("ahk_group " . Vim.GroupName) && (Vim.State.Mode == "Command")
:::
`;::
Vim.State.SetMode("Vim_Normal")
return

; FOR ELEMENT AND CONTENT WINDOW, AND BROWSER
#if (WinActive("ahk_class TElWind") || WinActive("ahk_class TContents") || WinActive("ahk_class TBrowser")) && (Vim.State.Mode == "Command")
c::  ; change default *c*oncept group
Vim.State.SetMode("Insert")
WinActivate ahk_class TElWind
click 725 65
back_to_normal = 1
return

+c::  ; add new concept
Vim.State.SetMode("Insert")
WinActivate ahk_class TElWind
send {alt}er
back_to_normal = 1
return

; PRIORITY SCRIPT
; made by Naess from supermemo.wiki discord server, modified by Guillem
; details in video: https://www.youtube.com/watch?v=OwV5HPKMrbg
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

; FOR ELEMENT WINDOW ONLY
#if WinActive("ahk_class TElWind") && (Vim.State.Mode == "Command")
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
ControlGetText, currentText, TBitBtn3
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
sleep 100  ; make sure copy works
IfInString, Clipboard, #Link: , {
	ref_link_updated := RegExReplace(Clipboard, "\n\K#Link: .*", new_link)
	clip(ref_link_updated)
} else {
	send ^{end}{enter}
	clip(new_link)
}
send !{enter}
WinWaitActive, ahk_class TELWind,, 0
if ErrorLevel {
	return
}
send ^t{esc}q^{home}{esc}  ; put caret in the start of question component unfocus every component
return

; /*  ; personal
s::  ; turn active language item to passive (*s*witch)
Vim.State.SetMode("Vim_Normal")
send ^t{esc}  ; de-select every component
ControlGetText, currentText, TBitBtn3
if (currentText != "Learn") {  ; if learning
	send {esc}
}
send ^+s
sleep 350  ; delay to make sure the switch works
send qen:{space}{tab}
sleep 150
send ^{del 2}{esc}
return

p::  ; hyperlink to scri*p*t component
Vim.State.SetMode("Vim_Normal")
send !{home}
sleep 100
send !{f10}u  ; uncheck autoplay
send !n
; send ^+m  ; disable if default topic template is script
; sleep 100
; send script{enter}
sleep 460  ; some delay to avoid autoplay
send {ctrl down}v{ctrl up}  ; so the link is clickable
sleep 20
send ^t{f9}{enter}  ; opens script editor
sleep 20
send url{space}
send ^v
send !o{esc}
send !{f10}u  ; check
return

m::  ; co*m*ment current element "audio"
Vim.State.SetMode("Vim_Normal")
ControlGetText, currentText, TBitBtn3
if (currentText = "Next repetition") {
	continue_learning = 1
	send !{f10}u
} else {
	continue_learning = 0
}
send ^+p
send ^a
send audio{enter}
if (continue_learning = 1) {
	continue_learning = 0
	send {enter}
	sleep 500
	send !{f10}u
}
return

d::  ; learn all elements with the comment "au*d*io"
Vim.State.SetMode("Vim_Normal")
send !{home}
sleep 100
send !{f10}u  ; uncheck autoplay
send {esc 4}  ; escape potential hidden window
send {alt}soc  ; open comment registry
sleep 500
send audio!b
sleep 1000
send {AppsKey}co  ; outstanding
sleep 500
send ^s  ; sort
sleep 500
send ^l  ; learn
sleep 500
send !{f10}u  ; check autoplay
send ^{f10}
return