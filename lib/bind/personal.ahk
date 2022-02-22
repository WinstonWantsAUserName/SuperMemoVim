; putting your scripts in this file makes it easier for updating smvim
; it's good to devide your file into sections, with each one headed by a #if WinActive statement
; make sure you at least have:
; #if WinActive("ahk_group " . Vim.GroupName)
; which is for entire supermemo

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
coord_x := 83 * A_ScreenDPI / 96
coord_y := 708 * A_ScreenDPI / 96
click %coord_x% %coord_y%
return

!f::  ; YT: pause and focus on the 2nd html component (note editing)
KeyWait alt
Vim.State.SetMode("Insert")
coord_x := 74 * A_ScreenDPI / 96
coord_y := 628 * A_ScreenDPI / 96
click %coord_x% %coord_y%
send ^{t 2}
return

!y::  ; YT: focus onto 1st html component (YT video)
KeyWait alt
Vim.State.SetMode("Insert")
coord_x := 193 * A_ScreenDPI / 96
coord_y := 640 * A_ScreenDPI / 96
click %coord_x% %coord_y%
return

^!+y::  ; YT: close "More videos"
Vim.State.SetMode("Insert")
coord_x := 907 * A_ScreenDPI / 96
coord_y := 460 * A_ScreenDPI / 96
click %coord_x% %coord_y%
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