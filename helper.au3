#include <Misc.au3>
#include <MsgBoxConstants.au3>
#include <WindowsConstants.au3>
#include <String.au3>
#include <GUIConstantsEx.au3>
#include <GuiEdit.au3>

Global $log
Global $text = ""

Func Helper()
    Local $hGUI = GUICreate("Cursor Info Logger", 400, 200, -1, -1)
    Local $LabelInstructions = GUICtrlCreateLabel("F10 to log the cursor position and color. F11 to clear", 10, 10, 380, 20)
    Local $Label = GUICtrlCreateLabel("", 10, 40, 380, 30)
	$log = GUICtrlCreateEdit("", 10, 70, 380, 120)
    GUISetState(@SW_SHOW, $hGUI)
    HotKeySet("{F10}", "Hot_key")
    HotKeySet("{F11}", "Hot_key")

    While 1
        Local $nMsg = GUIGetMsg()
        Switch $nMsg
            Case $GUI_EVENT_CLOSE
				GUIDelete($hGui)
                Exit
        EndSwitch

        ; Get cursor position and color
        Global $aPos = MouseGetPos()
        Global $iColor = PixelGetColor($aPos[0], $aPos[1])
        $text = "X: " & $aPos[0] & " Y: " & $aPos[1] & " Color: 0x" & Hex($iColor, 6)

        ; Update edit control with coordinates and color
        _GUICtrlEdit_SetText($Label, $text)
    WEnd
EndFunc   ;==>Helper

Func Hot_key()
    ; Check if F10 to save the information
    Switch @HotKeyPressed
        Case "{F10}"
            Write_log($text)
        Case "{F11}"
            Clear_log()
    EndSwitch
EndFunc   ;==>Hot_key

Func Write_log($log_text)
    $log_text = $log_text & @CRLF
    _GUICtrlEdit_AppendText($log, $log_text)
EndFunc

Func Clear_log()
	GUICtrlDelete($log)
    $log = GUICtrlCreateEdit("", 10, 70, 380, 120)
EndFunc

Helper()
