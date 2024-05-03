#include <Misc.au3>
#include <MsgBoxConstants.au3>
#include <WindowsConstants.au3>
#include <String.au3>
#include <GUIConstantsEx.au3>
#include <GuiEdit.au3>
#include <FontConstants.au3>

Global $text = ""
Global $last_text = ""
Global $title = "[TITLE:Yu-Gi-Oh! DUEL LINKS]"

Func Helper()
    Local $hGUI = GUICreate("Cursor Logger", 400, 230, -1, -1)
	GUISetFont(9,  $FW_NORMAL, $GUI_FONTNORMAL, "Courier New")

    Local $LabelInstructions = GUICtrlCreateLabel("F10 to log the cursor position and color. F11 to clear", 10, 10, 380, 20)
    Local $WindowLabel = GUICtrlCreateLabel("Window", 10, 30, 280, 20)
    Local $CursorLabel = GUICtrlCreateLabel("", 10, 50, 280, 20)
    Local $ColorLabel = GUICtrlCreateLabel("", 10, 70, 280, 20)
	Global $log = GUICtrlCreateEdit("", 10, 100, 380, 120)

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
		Global $winPos = WinGetPos($title)
        Global $aPos = MouseGetPos()
        Global $iColor = PixelGetColor($aPos[0], $aPos[1])

		; Update GUI
		$text = "0x" & Hex($iColor, 6)
		_GUICtrlEdit_SetText($WindowLabel, "Window | X: " & $winPos[0] & " Y: " & $winPos[1] & " (window)")
		_GUICtrlEdit_SetText($CursorLabel, "Cursor | X: " & $aPos[0] - $winPos[0] & " Y: " & $aPos[1] - $winPos[1])
		_GUICtrlEdit_SetText($ColorLabel,  "Color  | " & $text)
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
    ;$log_text = $log_text & @CRLF
    $log_text = $log_text & ','
    _GUICtrlEdit_AppendText($log, $log_text)
EndFunc

Func Clear_log()
	GUICtrlDelete($log)
    $log = GUICtrlCreateEdit("", 10, 70, 380, 120)
EndFunc

Helper()
