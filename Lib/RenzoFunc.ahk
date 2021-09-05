; 运行格式化空格
RunHeyspace(heyspacePath)
{
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
