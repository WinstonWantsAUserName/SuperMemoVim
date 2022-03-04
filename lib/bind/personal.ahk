; putting your scripts in this file makes it easier for updating smvim
; this file is on top in lib\vim_bind.ahk, so what you have in this file will overwrite all other bindings

; but make sure to do this to avoid duplication detection:

; autohotkey detects duplicates using conditions (the #if line above scripts)
; therefore, if you want to remap, always add a "&& true"
; so the conditions are considered different in the eyes of autohotkey

; examples:
; tilde means sending the key itself (see more in ahk documents)
; remove the /* below to enable the following scripts
/*
#if WinActive("ahk_group " . Vim.GroupName) && true
~e::  ; disabling smvim's e everywhere
return

#if WinActive("ahk_class TPlanDlg") && true
~j::  ; disabling smvim's j in Plan window
~k::  ; disabling smvim's k in Plan window
return

#if WinActive("ahk_group " . Vim.GroupName) && true
~^m::  ; enabling ctrl+m everywhere
^+!m::  ; disabling smvim's remapping of ctrl+m
return

#if WinActive("ahk_group " . Vim.GroupName) && Vim.State.Mode == "Vim_Normal" && true
p::  ; rewriting p in normal mode
send ^v
sleep 600
send ^z
MsgBox Pranked!
return
*/

; if you have any issues writing your own scripts, don't hesitate to find me in supermemo.wiki discord: https://discord.com/invite/vUQhqCT
; my name there is Winston#1395, with an avatar of a meditating cat
; you can also join #sm-ahk channel in #welcome, where you can ask questions there

/* below are scripts that I use personally
;;;;;;;;;;;;;;;;;;;;;;;;;
; FOR ELEMENT WINDOW ONLY
;;;;;;;;;;;;;;;;;;;;;;;;;
#if WinActive("ahk_class TElWind")
^!m::  ; YT: set start point
Vim.State.SetNormal()
if A_ScreenDPI = 96
	click 83 708
return

!f::  ; YT: pause and focus on the 2nd html component (note editing)
KeyWait alt
Vim.State.SetMode("Insert")
if A_ScreenDPI = 96
	click 74 628
send ^{t 2}
return

!y::  ; YT: focus onto 1st html component (YT video)
KeyWait alt
Vim.State.SetMode("Insert")
if A_ScreenDPI = 96
	click 193 640
return

^!+y::  ; YT: close "More videos"
Vim.State.SetMode("Insert")
if A_ScreenDPI = 96
	click 907 460
send ^{t 2}
return
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; FOR ELEMENT WINDOW AND COMMAND MODE ONLY
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
#if WinActive("ahk_class TElWind") && Vim.State.Mode == "Command"
s::  ; turn active language item to passive (*s*witch)
Vim.State.SetMode("Vim_Normal")
send ^t{esc}  ; de-select every component
ControlGetText, currentText, TBitBtn3
if (currentText != "Learn")  ; if learning
	send {esc}
send ^+s
sleep 450  ; delay to make sure the switch works; also to update the title
send q
sleep 10
send en:{space}{tab}
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
} else
	continue_learning = 0
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