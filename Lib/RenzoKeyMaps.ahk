CapsLock::LWin

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

#IfWinActive ahk_exe typora.exe
!i::Send, ^i
!b::Send, ^b
!/::Send, ^/
#IfWinActive
