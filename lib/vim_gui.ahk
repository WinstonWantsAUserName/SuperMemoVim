class VimGui{
  __New(vim, title) {
    this.Vim := vim
    this.Hwnd := 0
    this.HwndAll := []
    this.Title := title
  }

  ShowGui() {
    if (this.hwnd == 0) {
      Gui, New, +HwndGuiHwnd
      this.Hwnd := GuiHwnd
      this.HwndAll.Push(GuiHwnd)
      this.MakeGui()
      Gui, % this.Hwnd ":Show", , % this.Title
      OnMessage(0x112, ObjBindMethod(this, "OnClose"))
      OnMessage(0x100, ObjBindMethod(this, "Onescape"))
    }
    this.updateGui()
    Gui, % this.Hwnd . ":Show", , % this.Title
    return
  }

  MakeGui() {
    Gui, % this.Hwnd ":Add", Button, +HwndOK X200 W100 Default, &OK
    this.HwndAll.Push(OK)
    ok := ObjBindMethod(this, "OK")
    GuiControl, +G, % OK, % ok
  }

  updateGui() {
  }

  Hide() {
    this.Vim.VimToolTip.RemoveToolTip()
    Gui, % this.Hwnd ":Hide"
  }

  OK() {
    this.Hide()
  }

  IsThisWindow(hwnd) {
    for i, h in this.HwndAll {
      if (hwnd == h) {
        return True
      }
    }
    return False
  }

  OnClose(wp, lp, msg, hwnd) {
    if (wp == 0xF060 && hwnd == this.Hwnd) {
      this.Hide()
    }
  }

  Onescape(wp, lp, msg, hwnd) {
    if (wp == 27 && this.IsThisWindow(hwnd)) {
      this.Hide()
    }
  }
}
