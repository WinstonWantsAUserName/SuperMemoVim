class VimAbout Extends VimGui{
  __New(vim) {
    this.Vim := vim

    this.Version := ""
    this.Date := ""
    this.Author := ""
    this.Description := ""
    this.homepage := ""

    base.__New(vim, "Vim Ahk")
  }

  MakeGui() {
    global Vimhomepage, VimAboutOK
    Gui, % this.Hwnd ":-MinimizeBox"
    Gui, % this.Hwnd ":-Resize"
    Gui, % this.Hwnd ":Add", Text, , % "Vim Ahk (vim_ahk):`n" this.Description
    Gui, % this.Hwnd ":Font", Underline
    Gui, % this.Hwnd ":Add", Text, Y+0 cBlue vVimhomepage, homepage
    VimGuiAboutOpenhomepage := ObjBindMethod(this, "Openhomepage")
    GuiControl, +G, Vimhomepage, % VimGuiAboutOpenhomepage
    Gui, % this.Hwnd ":Font", Norm
    Gui, % this.Hwnd ":Add", Text, , % "Author: " this.Author
    Gui, % this.Hwnd ":Add", Text, , % "Version: " this.Version
    Gui, % this.Hwnd ":Add", Text, Y+0, % "Last update: " this.Date
    Gui, % this.Hwnd ":Add", Text, , Script path:`n%A_LineFile%
    Gui, % this.Hwnd ":Add", Text, , % "Setting file:`n" this.Vim.Ini.IniDir "\" this.Vim.Ini.Ini
    Gui, % this.Hwnd ":Add", Button, +HwndOK X200 W100 Default vVimAboutOK, &OK
    this.HwndAll.Push(OK)
    ok := ObjBindMethod(this, "OK")
    GuiControl, +G, VimAboutOK, % ok
  }

  Openhomepage() {
    this.Vim.VimToolTip.RemoveToolTip()
    Run % this.homepage
  }
}
