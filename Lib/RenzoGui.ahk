global guiHWND := ""

~LButton::
#IfWinExist, Renzo.ahk
    MouseGetPos,,,windowUnderMouse
    If (guiHWND != "" AND windowUnderMouse != guiHWND) {
        Gui %switchgui%: Hide
    }
    Return
#If

MyListView:
If (A_GuiEvent = "DoubleClick") {
    LV_GetText(ahkID, A_EventInfo, 3)
    WinActivate, ahk_id %ahkID%
    Gui %switchgui%: Hide
}


If (A_GuiEvent = "K") {
    rowCount := LV_GetCount()
    currentRow := LV_GetNext(0)
    ; Space 或 D 或 L 激活窗口
    If (A_EventInfo = 32 OR A_EventInfo = 68 OR A_EventInfo = 76) {
        LV_GetText(ahkID, currentRow, 3)
        WinActivate, ahk_id %ahkID%
        Gui %switchgui%: Hide
    }

    If (A_EventInfo = 81) {
        Gui %switchgui%: Hide
    }

    ; W 上一个
    If (A_EventInfo = 87) {
        If (currentRow > 1) {
            LV_Modify(currentRow, "-Focus")
            LV_Modify(currentRow, "-Select")
            LV_Modify(currentRow - 1, "Focus")
            LV_Modify(currentRow - 1, "Select")
        }
    }

    ; S 下一个
    If (A_EventInfo = 83) {
        If (currentRow < rowCount) {
            LV_Modify(currentRow, "-Focus")
            LV_Modify(currentRow, "-Select")
            LV_Modify(currentRow + 1, "Focus")
            LV_Modify(currentRow + 1, "Select")
        }
    }

    ; K 上一个
    If (A_EventInfo = 75) {
        If (currentRow > 1){
            LV_Modify(currentRow, "-Focus")
            LV_Modify(currentRow, "-Select")
            LV_Modify(currentRow - 1, "Focus")
            LV_Modify(currentRow - 1, "Select")
        }
        guiJKSwitchTime := A_TickCount
    }

    ; J 下一个
    If (A_EventInfo = 74) {
        If (currentRow < rowCount) {
            LV_Modify(currentRow, "-Focus")
            LV_Modify(currentRow, "-Select")
            LV_Modify(currentRow + 1, "Focus")
            LV_Modify(currentRow + 1, "Select")
        }
    }
}
Return

; GUI Close
GuiClose:
    Gui %switchgui%: Hide
    Return

; Toggle Switch GUI
; !*ESC::
; !ESC::
;     WinGetClass, currentClass, A
;     WinGet, currentWinID,,A
;     WinGet, processName, ProcessName, ahk_class %currentClass%
;     ; 通过 processName 获取 id 列表，会根据 id 唤起窗口
;     WinGet, idList, List, ahk_exe %processName%
;
;     If (WinExist("ahk_id " switchgui)) {
;         LV_Delete()
;         Gui %switchgui%: Hide
;         Return
;     }
;
;     ; idList 值为长度
;     If (idList > 2) {
;         generateListView(idList, currentWinID)
;         Return
;     }
;
;     If idList = 2
;     {
;         Loop, % idList {
;             winID := idList%A_Index%
;             If (winID = currentWinID) {
;                 continue
;             }
;             WinActivate, ahk_id %winID%
;         }
;         Return
;     }
; Return

; ^Space::
;     If (WinExist("ahk_id " switchgui)) {
;         LV_Delete()
;         Gui %switchgui%: Hide
;         Return
;     }
;
;     WinGet, idList, List
;     generateListView(idList, "")
; Return

generateListView(idList, currentWinID) {
        global guiHWND
        global switchgui
        imageCount := 0

        LV_Delete()
        ImageIDList := IL_Create(10,, 1)
        LV_SetImageList(ImageIDList, 1)


        Loop, %idList%
        {
            winID := idList%A_Index%
            WinGet, processPath, ProcessPath, ahk_id %winID%
            WinGet, processName, ProcessName, ahk_id %winID%

            If (winID = currentWinID) {
                Continue
            }

            WinGetTitle, winTitle, ahk_id %winID%

            If (StrLen(winTitle) = 0 || winTitle = "Program Manager" || winTitle = "Cortana") {
                Continue
            }

            ; load icon
            IL_Add(ImageIDList, processPath)
            imageCount += 1

            titleSplitList := StrSplit(winTitle, " - ",,2)
            If (titleSplitList.Length() = 2) {
                winTitle := titleSplitList[1]
            }

            If (StrLen(winTitle) > 50) {
                winTitle := SubStr(winTitle, 1, 50)
            }

            LV_Add("Icon" . imageCount, winTitle, processName, winID)
        }

        LV_Modify(1, "Focus")
        LV_Modify(1, "Select")
        LV_ModifyCol(1, "AutoHdr Sort")
        LV_ModifyCol(2, "AutoHdr Sort")
        LV_ModifyCol(3, "AutoHdr")

        Gui %switchgui%: Show, Center
        guiHWND := WinActive("A")
        Return
}
