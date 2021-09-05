MyListBox:
If A_GuiControlEvent <> Normal
    return

; ListBox Item Click
GuiControlGet, MyListBox
    resetList()
    listItem := MyListBox
    items := StrSplit(listItem, " --- ",,2)
    If items.Length() == 2 {
        ahkID := items[2]
        WinActivate, ahk_id %ahkID%
    }

    Gui %switchgui%: Hide
    return

; GUI Close
GuiClose:
    resetList()
    Gui %switchgui%: Hide
    return

; Toggle Switch GUI
!Esc::
    WinGetClass, currentClass, A
    WinGet, currentWinID,,A
    ; 通过 class 获取进程名
    WinGet, processName, ProcessName, ahk_class %currentClass%
    ; 通过 processName 获取 id 列表，会根据 id 唤起窗口
    WinGet, idList, List, ahk_exe %processName%

    If (WinExist("ahk_id " switchgui))
    {
        resetList()
        Gui %switchgui%: Hide
        Return
    }

    ; idList 值为长度
    If idList > 2
    {

        listContent:= ""

        Loop, % idList
        {
            winID := idList%A_Index%
            If winID = %currentWinID%
            {
                Continue
            }

            WinGetTitle, winTitle, ahk_id %winID%

            If StrLen(winTitle) = 0
            {
                Continue
            }

            itemText := winTitle . " --- " . winID
            listContent := listContent . "|" . itemText
        }

        resetList(listContent)
        Gui %switchgui%: Show, Center
        Return
    }

    If idList = 2
    {
        Loop, % idList
        {
            winID := idList%A_Index%
            If winID = %currentWinID%
            {
                continue
            }
            WinActivate, ahk_id %winID%
        }
        Return
    }
Return

resetList(list := "|")
{
    GuiControl Alpha:, MyListBox, %list%
}