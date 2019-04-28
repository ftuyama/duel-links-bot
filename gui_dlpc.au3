#include <String.au3>
#include <MsgBoxConstants.au3>
#include <StringConstants.au3>
#include <GuiScrollBars.au3>
#include <GUIConstantsEx.au3>
#include <ButtonConstants.au3>
#include <GuiEdit.au3>
#include <FileConstants.au3>
#include <WinAPIFiles.au3>
#include "dlpc.au3"

Global $nMsg = ""
Global $duel_mode = 0
Global $coin = 1000
Global $OnTop = True

;Move(875, 52)
;Dbg_print_color(500,330)
gui()
;Move(498, 646)
;Dbg_search(0,0,16)
;Street_duel(0,0)
;Dbg_print_color(759,439)
;Dbg_excluded(504, 522,0)
;Gate_duel(10)
;-------------------------------------------------------------------
Func gui()
	Local $window_status = 0
	Global $hGui = GUICreate("Duellink Bot For PC",400, 400, 10, 20)

	GUICtrlCreateTab(0,0,400,400)
		GUICtrlCreateTabItem("Bot")
			Global $log  = GUICtrlCreateEdit("",5, 25, 210, 340)
				write_log("Make sure you are already log in.")

			Local $x = 225
			Local $y= 60
			GUICtrlCreateGroup("Duel",$x-5, 25,170,80)

			   GUIStartGroup()
			   Global $duel_enable = GUICtrlCreateCheckbox("Enable",$x,$y-20)
			   GUICtrlSetState($duel_enable, $GUI_CHECKED )
			   Global $rad_world0 = GUICtrlCreateRadio("Yu-Gi-Oh", $x,$y)
			   GUICtrlSetState($rad_world0, $GUI_CHECKED )
			   Global $rad_world1 = GUICtrlCreateRadio("Yu-Gi-Oh GX", $x+75, $y)

			   GUIStartGroup()
			   Global $rad_sd = GUICtrlCreateRadio("Street duel", $x, $y+20)
			   GUICtrlSetState($rad_sd, $GUI_CHECKED )
			   Global $rad_gd = GUICtrlCreateRadio("Gate duel", $x+75, $y+20)

			GUICtrlCreateGroup("Battle City Showdown",$x-5, $y+45,170,80)
			   GUIStartGroup()
			   Global $event_enable = GUICtrlCreateCheckbox("Enable",$x,$y+60)
			   Global $rad_dt = GUICtrlCreateRadio("Devine trial", $x, $y+80)
			   GUICtrlSetState($rad_dt, $GUI_DISABLE)
			   Global $rad_lo = GUICtrlCreateRadio("Card Lottery", $x, $y+100)
			   GUICtrlSetState($rad_lo, $GUI_DISABLE)

			Global $but_duel = GUICtrlCreateButton("It's time to DUEL", 4, 370)
			Global $l_status = GUICtrlCreateLabel("Duellink status: Stopped",270, 383)

		GUICtrlCreateTabItem("Hotkey")
			GUICtrlCreateLabel("F9  : Pause/resume",5,25)
			GUICtrlCreateLabel("F10: Terminate",5,40)

		GUICtrlCreateTabItem("Setting")
			$x = 5
			$y = 25
			GUICtrlCreateGroup("General",$x, $y,170,40)
				GUIStartGroup()
				Global $cOnTop = GUICtrlCreateCheckbox("Always on top", $x+5,40)
				GUICtrlSetState($cOnTop, $GUI_CHECKED)

			GUICtrlCreateGroup("Street Duel",$x, $y+50 ,170,40)
				GUIStartGroup()
				Global $cLoop = GUICtrlCreateCheckbox("Loop area", $x+5,90)
				Global $cOrb  = GUICtrlCreateCheckbox("Auto use orb", $x+80,90)
				GUICtrlSetState($cLoop, $GUI_CHECKED)

			GUICtrlCreateGroup("Gate Duel",5, 125,170,40)
				GUIStartGroup()

		GUICtrlCreateTabItem("Help")
			Local $nHelp = "\help.txt"
			Local $hFileOpen = FileOpen(@ScriptDir & $nHelp)
			If $hFileOpen = -1 Then
				MsgBox($MB_SYSTEMMODAL, "", "An error occurred when reading " & $nHelp)
			Else
				Local $lHelp = GUICtrlCreateLabel(FileRead($hFileOpen),5,25,Default,Default,0x0000)
			EndIf
	GUICtrlCreateTabItem("")

	HotKeySet("{F9}", "Hot_key")
	HotKeySet("{F10}", "Hot_key")

	GUISetState(@SW_SHOW)
	While 1
		If Control_gui(GUIGetMsg()) == -1 Then
			ExitLoop
		EndIf

		If $OnTop Then
			WinSetOnTop($hGui,'',  $WINDOWS_ONTOP)
		Else
			WinSetOnTop($hGui,'',  $WINDOWS_NOONTOP)
		EndIf

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
	GUIDelete($hGui)
	Exit
EndFunc

Func write_log($variable)
	$variable = $variable & @CRLF
	_GUICtrlEdit_AppendText($log,$variable)
EndFunc

Func duel_bot()
	Switch $duel_mode
		 Case 0
			Street_duel($world, get_area(1))
		 Case 1
			Gate_duel(1176/24)
		 Case 2
			#comments-start divine_trial()
			#comments-end
			Battle_city()
		 Case 3
			card_lottery($coin)
	EndSwitch
EndFunc

Func Create_log()
	$log  = GUICtrlCreateEdit("",10, 10, 200, 330)
EndFunc

Func Clear_log()
	GUICtrlDelete($log)
	Create_log()
EndFunc

Func Hot_key()
	Switch @HotKeyPressed
		Case "{F9}"
			$sPaused = Not $sPaused
			Local $Informed = False
			While $sPaused
				Control_gui(GUIGetMsg())
				$timer = TimerInit()
				If Not $Informed Then
					Write_log("Bot Paused.")
					$Informed = True
				EndIf
				Sleep(100)
			WEnd
			If Not $sPaused  And $Informed Then
				Write_log("Bot resume.")
			EndIf
		Case "{F10}"
			Write_log("Bot terminated.")
			Sleep(1000)
			Exit
	EndSwitch
EndFunc

Func Control_gui($nMsg)
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				Return -1
			Case $duel_enable
			   if GUICtrlRead($duel_enable) == $GUI_UNCHECKED Then
				  disable_duel_menu()
			   Else
				  GUICtrlSetState($rad_sd, $GUI_ENABLE)
				  GUICtrlSetState($rad_gd, $GUI_ENABLE)
				  GUICtrlSetState($rad_world0, $GUI_ENABLE)
				  GUICtrlSetState($rad_world1, $GUI_ENABLE)

				  disalbe_bcd_menu()
			   EndIf
			Case $event_enable
			   If GUICtrlRead($event_enable) == $GUI_UNCHECKED Then
				  disalbe_bcd_menu()
			   Else
				  disable_duel_menu()
				  GUICtrlSetState($rad_dt, $GUI_ENABLE)
				  GUICtrlSetState($rad_lo, $GUI_ENABLE)
			   EndIf
			Case $but_duel
			   duel_bot()
			Case $rad_sd
			   $duel_mode = 0
			Case $rad_gd
			   $duel_mode = 1
			Case $rad_dt
			   $duel_mode = 2
			Case $rad_lo
			   $duel_mode = 3
			Case $rad_world0
				$world = 0
			Case $rad_world1
				$world = 1
			Case $cLoop
				if _IsChecked($cLoop) Then
					$Loop = True
				Else
					$Loop = false
				EndIf
			 Case $cOrb
				if _IsChecked($cOrb) Then
					$auto_orb_reload = True
				Else
					$auto_orb_reload = false
				EndIf
			Case $cOnTop
				if _IsChecked($cOnTop) Then
					$OnTop = True
				Else
					$OnTop = false
				EndIf
		EndSwitch
EndFunc

Func disable_duel_menu()
   GUICtrlSetState($duel_enable, $GUI_UNCHECKED)

   GUICtrlSetState($rad_sd, $GUI_UNCHECKED)
   GUICtrlSetState($rad_sd, $GUI_DISABLE)

   GUICtrlSetState($rad_gd, $GUI_UNCHECKED)
   GUICtrlSetState($rad_gd, $GUI_DISABLE)

   GUICtrlSetState($rad_world0, $GUI_UNCHECKED)
   GUICtrlSetState($rad_world0, $GUI_DISABLE)

   GUICtrlSetState($rad_world1, $GUI_UNCHECKED)
   GUICtrlSetState($rad_world1, $GUI_DISABLE)
EndFunc

Func disalbe_bcd_menu()
   GUICtrlSetState($event_enable, $GUI_UNCHECKED)

   GUICtrlSetState($rad_dt, $GUI_UNCHECKED)
   GUICtrlSetState($rad_dt, $GUI_DISABLE)

   GUICtrlSetState($rad_lo, $GUI_UNCHECKED)
   GUICtrlSetState($rad_lo, $GUI_DISABLE)
EndFunc

Func _IsChecked($idControlID)
    Return BitAND(GUICtrlRead($idControlID), $GUI_CHECKED) = $GUI_CHECKED
EndFunc