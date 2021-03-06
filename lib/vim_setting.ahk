class VimSetting Extends VimGui{
  __New(vim) {
    this.Vim := vim
    base.__New(vim, "Vim Ahk Settings")
  }

  MakeGui() {
    global VimRestoreIME, VimJJ, VimJK, VimSD
    global VimDisableUnused, VimSetTitleMatchMode, VimSetTitleMatchModeFS, VimIconCheckInterval, VimVerbose, VimGroup, VimGroupList
    global VimDisableUnusedText, VimSetTitleMatchModeText, VimIconCheckIntervalText, VimIconCheckIntervalEdit, VimVerboseText, VimGroupText, Vimhomepage, VimSettingOK, VimSettingReset, VimSettingCancel
    this.VimVal2V()
    Gui, % this.Hwnd ":-MinimizeBox"
    Gui, % this.Hwnd ":-Resize"
    created := 0
    for i, k in this.Vim.Checkboxes {
      if (created == 0) {
        y := "YM"
      } else {
        y := "Y+10"
      }
      Gui, % this.Hwnd ":Add", Checkbox, % "+HwndHwnd" k " XM+10 " y " v" k, % this.Vim.Conf[k]["description"]
      hwnd := "Hwnd" k
      this.HwndAll.Push(%hwnd%)
      created  := 1
      GuiControl, % this.Hwnd ":", % k, % %k%
    }
    Gui, % this.Hwnd ":Add", Text, % "XM+10 Y+15 g" this.__Class ".DisableUnusedText vVimDisableUnusedText", % this.Vim.Conf["VimDisableUnused"]["description"]
    Gui, % this.Hwnd ":Add", DropdownList, % "+HwndHwndDisableUnused X+5 Y+-16 W30 vVimDisableUnused Choose" VimDisableUnused, 1|2|3
    this.HwndAll.Push(HwndDisableUnused)
    Gui, % this.Hwnd ":Add", Text, % "XM+10 Y+15 g" this.__Class ".SetTitleMatchModeText vVimSetTitleMatchModeText", % this.Vim.Conf["VimSetTitleMatchMode"]["description"]
    if (VimSetTitleMatchMode == "RegEx") {
      matchmode := 4
    } else {
      matchmode := %VimSetTitleMatchMode%
    }
    Gui, % this.Hwnd ":Add", DropdownList, % "+HwndHwndSetTitleMachMode X+5 Y+-16 W60 vVimSetTitleMatchMode Choose" matchmode, 1|2|3|RegEx
    this.HwndAll.Push(HwndSetTitleMachMode)
    if (VimSetTitleMatchModeFS == "Fast") {
      matchmodefs := 1
    } else {
      matchmodefs := 2
    }
    Gui, % this.Hwnd ":Add", DropdownList, % "+HwndHwndSetTitleMachModeFS X+5 Y+-20 W50 vVimSetTitleMatchModeFS Choose" matchmodefs, Fast|Slow
    this.HwndAll.Push(HwndSetTitleMachModeFS)
    Gui, % this.Hwnd ":Add", Text, % "XM+10 Y+10 g" this.__Class ".IconCheckIntervalText vVimIconCheckIntervalText", % this.Vim.Conf["VimIconCheckInterval"]["description"]
    Gui, % this.Hwnd ":Add", Edit, +HwndHwndIconCheckIntervalEdit X+5 Y+-16 W70 vVimIconCheckIntervalEdit
    this.HwndAll.Push(HwndIconCheckIntervalEdit)
    Gui, % this.Hwnd ":Add", updown, +HwndHwndIconCheckInterval vVimIconCheckInterval Range0-1000000, % VimIconCheckInterval
    this.HwndAll.Push(HwndIconCheckInterval)
    Gui, % this.Hwnd ":Add", Text, % "XM+10 Y+10 g" this.__Class ".VerboseText vVimVerboseText", % this.Vim.Conf["VimVerbose"]["description"]
    Gui, % this.Hwnd ":Add", DropdownList, % "+HwndHwndVerbose X+5 Y+-16 W30 vVimVerbose Choose"VimVerbose, 1|2|3|4
    this.HwndAll.Push(HwndVerbose)
    Gui, % this.Hwnd ":Add", Text, % "XM+10 Y+5 g" this.__Class ".GroupText vVimGroupText", % this.Vim.Conf["VimGroup"]["description"]
    Gui, % this.Hwnd ":Add", Edit, +HwndHwndGroupList XM+10 Y+5 R10 W300 Multi vVimGroupList, % VimGroupList
    this.HwndAll.Push(HwndGroupList)
    Gui, % this.Hwnd ":Add", Text, XM+10 Y+10, Check
    Gui, % this.Hwnd ":Font", Underline
    Gui, % this.Hwnd ":Add", Text, X+5 cBlue vVimhomepage, HELP
    homepage := ObjBindMethod(this.Vim.About, "Openhomepage")
    GuiControl, +G, Vimhomepage, % homepage
    Gui, % this.Hwnd ":Font", Norm
    Gui, % this.Hwnd ":Add", Text, X+5, for further information.

    Gui, % this.Hwnd ":Add", Button, +HwndHwndOK vVimSettingOK X10 W100 Y+10 Default, &OK
    this.HwndAll.Push(HwndOK)
    ok := ObjBindMethod(this, "OK")
    GuiControl, +G, VimSettingOK, % ok

    Gui, % this.Hwnd ":Add", Button, +HwndHwndReset vVimSettingReset W100 X+10, &Reset
    this.HwndAll.Push(HwndReset)
    reset := ObjBindMethod(this, "Reset")
    GuiControl, +G, VimSettingReset, % reset

    Gui, % this.Hwnd ":Add", Button, +HwndHwndCancel vVimSettingCancel W100 X+10, &Cancel
    this.HwndAll.Push(HwndCancel)
    this.LastHwnd := Last
    cancel := ObjBindMethod(this, "Cancel")
    GuiControl, +G, VimSettingCancel, % cancel
  }

  updateGui() {
    this.VimVal2V()
    this.updateGuiValue()
  }

  updateGuiValue() {
    global VimRestoreIME, VimJJ, VimJK, VimSD
    global VimDisableUnused, VimSetTitleMatchMode, VimSetTitleMatchModeFS, VimIconCheckInterval, VimVerbose, VimGroup, VimGroupList
    for i, k in this.Vim.Checkboxes {
      GuiControl, % this.Hwnd ":", % k, % %k%
    }
    GuiControl, % this.Hwnd ":Choose", VimDisableUnused, % VimDisableUnused
    GuiControl, % this.Hwnd ":", VimIconCheckInterval, % VimIconCheckInterval
    if (VimSetTitleMatchMode == "RegEx") {
      matchmode := 4
    } else {
      matchmode := VimSetTitleMatchMode
    }
    GuiControl, % this.Hwnd ":Choose", VimSetTitleMatchMode, % matchmode
    if (VimSetTitleMatchModeFS == "Fast") {
      matchmodefs := 1
    } else {
      matchmodefs := 2
    }
    GuiControl, % this.Hwnd ":Choose", VimSetTitleMatchModeFS, % matchmodefs
    GuiControl, % this.Hwnd ":Choose", VimVerbose, % VimVerbose
    GuiControl, % this.Hwnd ":", VimGroupList, % VimGroupList
  }

  ; Dummy Labels, to enable tooltip over the text
  DisableUnusedText() {
  }

  SetTitleMatchModeText() {
  }

  IconCheckIntervalText() {
  }

  VerboseText() {
  }

  GroupText() {
  }

  VimV2Conf() {
    global VimRestoreIME, VimJJ, VimJK, VimSD
    global VimDisableUnused, VimSetTitleMatchMode, VimSetTitleMatchModeFS, VimIconCheckInterval, VimVerbose, VimGroup, VimGroupList
    VimGroup := ""
    tmpArray := []
    Loop, Parse, VimGroupList, `n
    {
      if (! tmpArray.Haskey(A_LoopField)) {
        tmpArray.push(A_LoopField)
        if (VimGroup == "") {
          VimGroup := A_LoopField
        } else {
          VimGroup := VimGroup . this.Vim.GroupDel . A_LoopField
        }
      }
    }
    for k, v in this.Vim.Conf {
      v["val"] := %k%
    }
  }

  VimConf2V(vd) {
    global VimRestoreIME, VimJJ, VimJK, VimSD
    global VimDisableUnused, VimSetTitleMatchMode, VimSetTitleMatchModeFS, VimIconCheckInterval, VimVerbose, VimGroup, VimGroupList
    StringReplace, VimGroupList, % this.Vim.Conf["VimGroup"][vd], % this.Vim.GroupDel, `n, All
    for k, v in this.Vim.Conf {
      %k% := v[vd]
    }
  }

  VimVal2V() {
    this.vimConf2V("val")
  }

  VimDefault2V() {
    this.vimConf2V("default")
  }

  OK() {
    Gui, % this.Hwnd . ":Submit"
    this.VimV2Conf()
    this.Vim.Setup()
    this.vim.Ini.WriteIni()
    this.Hide()
  }

  Cancel() {
    this.Hide()
  }

  Reset() {
    this.VimDefault2V()
    this.updateGuiValue()
  }
}
