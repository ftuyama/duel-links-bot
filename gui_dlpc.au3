Global $title    = "[TITLE:Yu-Gi-Oh! DUEL LINKS]"
Global $nMsg = ""
Global $world = 0
Global $duel_mode = 0

Func gui()
	Local $window_status = 0
	Global $hGui = GUICreate("Duellink Bot For PC",400, 400, 10, 20)

	GUICtrlCreateGroup("World",220, 10,170,40)
	GUIStartGroup()
	Global $rad_world0 = GUICtrlCreateRadio("Yu-Gi-Oh", 225,25)
	Global $rad_world1 = GUICtrlCreateRadio("Yu-Gi-Oh GX", 300, 25)
	GUICtrlSetState($rad_world0, $GUI_CHECKED)

	GUICtrlCreateGroup("Duel Mode",220, 75,170,40)
	GUIStartGroup()
	Global $rad_sd = GUICtrlCreateRadio("Street duel", 225, 90)
	Global $rad_gd = GUICtrlCreateRadio("Gate duel", 300, 90)
	GUICtrlSetState($rad_sd, $GUI_CHECKED)

	Global $l_status = GUICtrlCreateLabel("Duellink status: Stopped",270, 371)

	Global $log  = GUICtrlCreateEdit("",10, 10, 200, 330)

	Global $but_duel = GUICtrlCreateButton("    It's Time To DUEL    ", 10, 350)

	GUISetState(@SW_SHOW)
	write_log("Make sure you are already log in")
	WinSetOnTop($hGui,'',$WINDOWS_ONTOP)
	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				ExitLoop
			Case $but_duel
				duel_bot()
			Case $rad_sd
				$duel_mode = 0
			Case $rad_gd
				$duel_mode = 1
			Case $rad_world0
				$world = 0
			Case $rad_world1
				$world = 1
		EndSwitch

		If WinExists($title) Then
			If $window_status == 0 Then
				GUICtrlSetData($l_status, "Duellink status: Running")
				$window_status = 1
			EndIf
		Else
			If $window_status == 1 Then
				GUICtrlSetData($l_status, "Duellink status: Stopped")
				$window_status = 0
			EndIf
		EndIf
	WEnd
	Exit
EndFunc

Func write_log($variable)
	$variable = $variable & @CRLF
	_GUICtrlEdit_AppendText($log,$variable)
EndFunc

Func duel_bot()
	Switch $duel_mode
		Case 0
			Street_duel($world, 0)
		Case 1
			Gate_duel(10)
	EndSwitch
EndFunc

Func Create_log()
	$log  = GUICtrlCreateEdit("",10, 10, 200, 330)
EndFunc

Func Clear_log()
	GUICtrlDelete($log)
	Create_log()
EndFunc