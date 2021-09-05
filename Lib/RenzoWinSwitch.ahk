global winPathToIDMap := new HashTable()

; 切换应用, 模拟 Manico
; 比较建议 3 个参数都填，这样可以确定 Pid 以唤起正确的窗口
; 参数 1：ahk_exe ProcessNameOrPath in WinTitle to identIfy a window belonging to any process with the given name or path.
; 参数 2：ahk_class ClassName in WinTitle to identIfy a window by its window class
; 参数 3：title regex：匹配正确的标题（\S 非空即可)
ToggleApp(exePath, titleClass := "", titleRegexToGetPID := "", recheck := True, activeTray := False)
{
    global debug := False
    ; path, app.exe, app
    SplitPath, exePath, exeName, , , noExt

    ; --------------------------------------------------------------
    ; 进程名不存在，则运行 exePath（对多进程会失效）
    ; --------------------------------------------------------------
    If !checkProcessNameExist(exeName)
    {
        Run, %exePath%
        If titleClass
        {
            ; WinWait, ahk_class %titleClass%, , 1
            activeWinClass(exeName, titleClass, activeTray)
            ; WinActivate ahk_class %titleClass%
        }

        If debug {
            ShowText("Run " . exePath)
        }

        Return
    }

    ; --------------------------------------------------------------
    ; 是否需要重新确认窗口是否存在，不存在则运行 exePath
    ; --------------------------------------------------------------
    If titleClass AND recheck
    {
        WinGet windowCount, Count, ahk_class %titleClass%

        If debug {
            ShowText("windowCount = " . windowCount)
        }

        If (%windowCount% == 0)
        {
            Run, %exePath%

            If titleClass
            {
                ; WinWait, ahk_class %titleClass%, , 1
                activeWinClass(exeName, titleClass, activeTray)
                ; WinActivate ahk_class %titleClass%
            }

            Return
        }
    }

    ; --------------------------------------------------------------
    ; 若应用名对应的窗口为激活状态 (Active)，则需要隐藏
    ; --------------------------------------------------------------
    If WinActive("ahk_exe " . exeName)
    {
        If debug {
            ShowText("<" . exeName . "> is active, minimize now")
        }

        ; WinMinimize
        minimizeWin()
        Return
    }


    ; --------------------------------------------------------------
    ; 若应用名对应的窗口为未激活状态，则需要激活
    ; 可能会失败
    ; --------------------------------------------------------------
    If titleRegexToGetPID
    {
        ahkID := getMainProcessID(exeName, titleClass, titleRegexToGetPID)
        If winPathToIDMap.HasKey(exePath) {
            if debug {
                ShowText("<" . exeName . " | pid = " .  ahkID . "> not active, active now (from map)")
            }
            activeWinID(exeName, winPathToIDMap.Get(exePath), activeTray)
        } Else {
            activeWinID(exeName, ahkID, activeTray)
            ; WinActivate, ahk_id %ahkID%
            If debug {
                ShowText("<" . exeName . " | pid = " .  ahkID .  "> not active, active now")
            }
        }

        Return
    }

    If titleClass
    {
        ; WinActivate, ahk_class %titleClass%
        activeWinClass(exeName, titleClass, activeTray)
        If debug {
            ShowText("<" . exeName . " | class = " .  titleClass .  "> not active, active now")
        }

        Return
    }

    activeWinName(exeName, activeTray)
    ; WinActivate, ahk_exe %exeName%
    If debug {
        ShowText("<" . exeName . " | exe = " .  exeName .  "> not active, active now")
    }

    Return
}


; 判断进程是否存在（返回PID）
checkProcessNameExist(processName)
{
    Process, Exist, %processName% ; 比 IfWinExist 可靠
    Return ErrorLevel
}


; 获取类似 chrome 等多进程的主程序 ID
getMainProcessID(exeName, titleClass, titleRegexToGetPID := "")
{
    DetectHiddenWindows, On
    ; 获取 exeName 的窗口列表，获取其 titleClass，并确认 title 匹配 titleRegexToGetPID
    WinGet, winList, List, ahk_exe %exeName%
    DetectHiddenWindows, Off
    Loop, % winList
    {
        ahkID := winList%A_Index%
        WinGetClass, currentClass, ahk_id %ahkID%
        ; MsgBox,% A_Index . "/" . winList . "`n" . "currentClass = " .  currentClass . "`n" . "titleClass = " . titleClass
        ; 1/12：遍历至第几个
        ; 当前 class
        ; 目标 class
        If (currentClass ~= titleClass)
        {
            ; titleRegexToGetPID 为空，不需要判断标题
            If !StrLen(titleRegexToGetPID)
                Return ahkID

            ; 获取 Window 标题（字面含义）
            WinGetTitle, currentTitle, ahk_id %ahkID%
            ; MsgBox, %currentTitle%

            If (currentTitle ~= titleRegexToGetPID)
                ; MsgBox, "titleLoop = " . %currentTitle%
                Return ahkID
        }

        Continue
    }

    Return False
}

; Window Active Helper Functions
activeWinClass(exeName, cls, activeTray)
{
    saveWindowToMap()
    If activeTray {
        TrayIcon_Button(exeName)
        Return
    }
    WinActivate ahk_class %cls%
}

activeWinID(exeName, id, activeTray)
{
    saveWindowToMap()
    If activeTray {
        TrayIcon_Button(exeName)
        Return
    }
    WinActivate, ahk_id %id%
}

activeWinName(exeName, activeTray)
{
    saveWindowToMap()
    If activeTray {
        TrayIcon_Button(exeName)
        Return
    }
    WinActivate, ahk_exe %exeName%
}

minimizeWin()
{
    saveWindowToMap()
    WinMinimize
}

saveWindowToMap()
{
    ; 获取当前窗口 id, 保存到 map 用于下一次唤起时优先唤起
    WinGet, currentWinPath, ProcessPath, A
    WinGet, currentWinID,,A
    winPathToIDMap.Set(currentWinPath, currentWinID)
}

; 显示提示 t 秒并自动消失
ShowText(str, t := 1, ExitScript := 0, x := "", y := "")
{
    t *= 1000
    ToolTip, %str%, %x%, %y%
    SetTimer, removeTip, -%t%
    If ExitScript
    {
        Gui, Destroy
        Exit
    }
}

; 清除ToolTip
RemoveTip()
{
    ToolTip
}
