Func gui()
	Global $nMsg

	Global $hGui = GUICreate("Duellink Bot For PC",400, 400, 10, 20)

	Global $log  = GUICtrlCreateEdit("",10, 10, 200, 330)

	Global $button = GUICtrlCreateButton("Log", 10, 350, 80, 30)

	Global $rad_sd = GUICtrlCreateRadio("Street duel", 220, 5)
	Global $rad_gd = GUICtrlCreateRadio("Gate duel", 220, 25)
	GUISetState(@SW_SHOW)
	WinSetOnTop($hGui,'',$WINDOWS_ONTOP)
	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				Exit
			Case $button
				write_log("test")
			Case $rad_sd
				Street_duel(0,0)
			Case $rad_gd
				Gate_duel(10)
		EndSwitch
	WEnd
EndFunc

Func write_log($variable)
	$variable = $variable & @CRLF
	_GUICtrlEdit_AppendText($log,$variable)
EndFunc