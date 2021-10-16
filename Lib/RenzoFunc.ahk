; 运行格式化空格
RunHeyspace(heyspacePath) {
    RunWait, %heyspacePath%,,Hide
    showText("heyspace format success")
    return
}

Hotkey(hk, fun, arg*) {
    Static funs := {}, args := {}
    funs[hk] := Func(fun), args[hk] := arg
    Hotkey, %hk%, Hotkey_Handle
    Return
Hotkey_Handle:
    funs[A_ThisHotkey].(args[A_ThisHotkey]*)
    Return
}

Msg(msg) {
    MsgBox, %msg%
}


; 调整亮度
ChangeBrightness(increment, timeout = 0)
{
    brightness := 0
    if (increment != 0)
    {
        brightness := GetCurrentBrightNess()
        brightness := brightness + increment

        if ( brightness > 100 )
        {
            brightness := 100
        }
        else if ( brightness < 0 )
        {
            brightness := 0
        }
    }
    else
    {
        brightness := 50
    }

    For property in ComObjGet( "winmgmts:\\.\root\WMI" ).ExecQuery( "SELECT * FROM WmiMonitorBrightnessMethods" )
        property.WmiSetBrightness( timeout, brightness )	
}

GetCurrentBrightNess()
{
	For property in ComObjGet( "winmgmts:\\.\root\WMI" ).ExecQuery( "SELECT * FROM WmiMonitorBrightness" )
		currentBrightness := property.CurrentBrightness	

	return currentBrightness
}
