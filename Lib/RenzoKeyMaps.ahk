; CapsLock::LWin
*CapsLock::
  SetKeyDelay -1
  Send {Blind}{Ctrl DownTemp}{Alt DownTemp}{Shift DownTemp}
return

*CapsLock up::
  SetKeyDelay -1
  Send {Blind}{Ctrl Up}{Alt Up}{Shift Up}
return

; win shift alt
; CapsLock::SendInput, {Lwin Down}{Alt Down}{LShift Down}
; CapsLock Up::SendInput, {Lwin Up}{Alt Up}{LShift Up}

LAlt & Left::
	Send, #{Left}
	Return
LAlt & Right::
	Send, #{Right}
	Return
LAlt & Up::
	Send, #{Up}
	Return
LAlt & Down::
	Send, #{Down}
	Return

LAlt & q::
	MsgBox, 4, Quit Check, Are You Sure To Quit Current App?
	IfMsgBox Yes
		Send !{F4}
	Return

; 取消原 LWin 键位映射
#r::Return

; hide window
!h::
    WinGetClass, ActiveClass, A
    WinSet, Bottom,, A
    Return

; 音量 control + 上/下
LControl & Up::
    Send {Volume_Up 5}
    Return

LControl & Down::
    Send {Volume_Down 5}
    Return

; 亮度调整
^Left::ChangeBrightness(-10)
^Right::ChangeBrightness(10)
; Numpad1::Send, {F1}
; Numpad2::Send, {F2}
; Numpad3::Send, {F3}
; Numpad4::Send, {F4}
; Numpad5::Send, {F5}
; Numpad6::Send, {F6}
; Numpad7::Send, {F7}
; Numpad8::Send, {F8}
; Numpad9::Send, {F9}
; Numpad0::Send, {F11}

; 将 Alt 与 Ctrl 部分组合键互换
!w::Send, ^w
!a::Send, ^a
!c::Send, ^c
!x::Send, ^x
!v::Send, ^v
!z::Send, ^z
!s::Send, ^s
!f::Send, ^f
!LButton::Send, ^{LButton}

#IfWinActive ahk_exe chrome.exe
!l::Send, ^l
!j::Send, ^j
!t::Send, ^t
!r::Send, ^r
!=::Send, ^=
!-::Send, ^-
#IfWinActive

#IfWinActive ahk_exe msedge.exe
!l::Send, ^l
!j::Send, ^j
!t::Send, ^t
!r::Send, ^r
!=::Send, ^=
!-::Send, ^-
#IfWinActive

#IfWinActive ahk_exe typora.exe
!i::Send, ^i
!b::Send, ^b
!/::Send, ^/
#IfWinActive

#IfWinActive ahk_exe obsidian.exe
!i::Send, ^i
!b::Send, ^b
!/::Send, ^/
!t::Send, ^t
#IfWinActive
