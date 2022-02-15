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
    if (not this.Vim.State.StrIsInCurrentVimMode("Line")) {
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
          send +^{right}
        } else {
          send ^{right}
        }
      } else if (key == "+w") {
        if (shift == 1) {
          send +^{right 5}
        } else {
          send ^{right 5}
        }
      } else if (key == "b") {
        if (shift == 1) {
          send +^{left}
        } else {
          send ^{left}
        }
      } else if (key == "+b") {
        if (shift == 1) {
          send +^{left 5}
        } else {
          send ^{left 5}
        }
      }
    }
    ; 1 character
    if (key == "j") {
		send {down}
	} else if (key == "+j") {
        if (shift == 1) {
          send +{down 5}
        } else {
          send {down 5}
        }
    } else if (key = "k") {
        send {up}
	} else if (key == "+k") {
        if (shift == 1) {
          send +{up 5}
        } else {
          send {up 5}
        }
    } else if (key == "g") {
		send ^{home}
    } else if (key == "+g") {
        if (shift == 1) {
          send +^{end}
        } else {
          send ^{end}
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
          send +^{down}
        } else {
          send ^{down}
        }
	}
    send {shift up}
    this.Vim.State.SetMode("", 0, 0)
  }
  Repeat(key="") {
    if (this.Vim.State.n == 0) {
      this.Vim.State.n := 1
    }
    Loop, % this.Vim.State.n {
      this.Vim.Move.Move(key)
    }
  }
}
