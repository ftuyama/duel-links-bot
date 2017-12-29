Func gui()
	Global $nMsg = ""
	Global $world = 0
	Global $duel_mode = 0
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

	Global $log  = GUICtrlCreateEdit("",10, 10, 200, 330)

	Global $but_duel = GUICtrlCreateButton("    It's Time To DUEL    ", 10, 350)





	GUISetState(@SW_SHOW)
	WinSetOnTop($hGui,'',$WINDOWS_ONTOP)
	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				Exit
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
	WEnd
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