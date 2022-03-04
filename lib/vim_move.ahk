class VimMove{
	__New(vim) {
		this.Vim := vim
	}
	Move(key="") {
		shift = 0
		if this.Vim.State.StrIsInCurrentVimMode("Visual") {
		  shift := 1
		}
		if (shift == 1) {
		  send {shift down}
		}
		; left/right
		if !this.Vim.State.StrIsInCurrentVimMode("Line") {
		  ; For some cases, need '+' directly to continue to select
		  ; especially for cases using shift as original keys
		  ; For now, caret does not work even add + directly
		  if (key == "h") {
			send {left}
		  } else if (key == "l") {
			send {right}
		  } else if (key == "0") {
			send {home}
		  } else if (key == "$") {
			if (shift == 1) {
			  send +{end}
			} else {
			  send {end}
			}
		  ; Words
		  } else if (key == "w") {
			if (shift == 1) {
			  send ^+{right}
			} else {
			  send ^{right}
			}
		  } else if (key == "e") {
			if (shift == 1) {
			  if this.Vim.State.StrIsInCurrentVimMode("VisualFirst") {
				send ^+{right}+{left}
				this.Vim.State.SetMode("Vim_VisualChar")
			  } else
				send ^+{right 2}+{left}
			} else {
			  send ^{right 2}{left}
			}
		  } else if (key == "ge") {
			if (shift == 1) {
			  send ^+{left}+{left}
			} else {
			  send ^{left}{left}
			}
		  } else if (key == "b") {
			if (shift == 1) {
			  send ^+{left}
			} else {
			  send ^{left}
			}
		  }
		}
		; 1 character
		if (key == "j") {
			send {down}
		} else if (key == "k") {
			send {up}
		} else if (key == "g") {
			send ^{home}  ; sometimes this doesn't work, yet the MsgBox works
			; MsgBox !  ; mystery.
		} else if (key == "+g") {
			if (shift == 1) {
			  send ^+{end}+{home}
			} else {
			  send ^{end}{home}
			}
		} else if (key == "[") {
			if (shift == 1) {
			  send +{up}+{home}
			} else {
			  send {up}{home}
			}
		} else if (key == "]") {
			if (shift == 1) {
			  send +{down}+{home}
			} else {
			  send {down}{home}
			}
		} else if (key == "{") {  ; previous paragraph: cannot use ctrl+up, has to select first (ctrl+shift+up)
			if (shift == 1) {
			  send ^+{up}
			} else {
			  send ^+{up}{left}
			}
		} else if (key == "}") {  ; next paragraph
			if (shift == 1) {
			  send ^+{down}
			} else {
			  send ^{down}
			}
		} else if (key == "d") {
			send {WheelDown 2}
		} else if (key == "u") {
			send {WheelUp 2}
		} else if (key == "!j") {
			send {WheelDown}
		} else if (key == "!k") {
			send {WheelUp}
		} else if (key == "!h") {
			send {WheelLeft}
		} else if (key == "!l") {
			send {WheelRight}
		}
		send {shift up}
		this.Vim.State.SetMode("", 0, 0)
	}
	Repeat(key="") {
		if this.Vim.State.n != 0
			repeat_tooltip = 1
		; a single up/down in element window / browser doesn't need to turn off the browser-element window sync
		if WinActive("ahk_class TContents") && (key = "j" || key = "k") && this.Vim.State.n > 1 {
			coord_x := 295 * A_ScreenDPI / 96
			coord_y := 46 * A_ScreenDPI / 96
			click %coord_x% %coord_y%  ; turning off the content-element window sync
			loop % this.Vim.State.n {
			  this.Vim.Move.Move(key)
			}
			click %coord_x% %coord_y%  ; and turning it back on
		} else if WinActive("ahk_class TBrowser") && (key = "j" || key = "k") && this.Vim.State.n > 1 {
			coord_x := 638 * A_ScreenDPI / 96
			coord_y := 40 * A_ScreenDPI / 96
			click %coord_x% %coord_y%  ; turning off the browser-element window sync
			loop % this.Vim.State.n {
			  this.Vim.Move.Move(key)
			}
			click %coord_x% %coord_y%  ; and turning it back on
		} else {
			if this.Vim.State.n = 0
				this.Vim.Move.Move(key)
			else {
				loop % this.Vim.State.n {
				  this.Vim.Move.Move(key)
				}
			}
		}
		if repeat_tooltip = 1
			ToolTip
	}
}
