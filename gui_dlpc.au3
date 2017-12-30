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

gui()

Func gui()
	Local $window_status = 0
	Global $hGui = GUICreate("Duellink Bot For PC",400, 400, 10, 20)

	GUICtrlCreateTab(0,0,400,400)
		GUICtrlCreateTabItem("Duel")
			Global $log  = GUICtrlCreateEdit("",5, 25, 210, 340)
				write_log("Make sure you are already log in.")

			GUICtrlCreateGroup("World",220, 25,170,40)
				GUIStartGroup()
				Global $rad_world0 = GUICtrlCreateRadio("Yu-Gi-Oh", 225,40)
				Global $rad_world1 = GUICtrlCreateRadio("Yu-Gi-Oh GX", 300, 40)
				GUICtrlSetState($rad_world0, $GUI_CHECKED)

			GUICtrlCreateGroup("Duel Mode",220, 75,170,40)
				GUIStartGroup()
				Global $rad_sd = GUICtrlCreateRadio("Street duel", 225, 90)
				Global $rad_gd = GUICtrlCreateRadio("Gate duel", 300, 90)
				GUICtrlSetState($rad_sd, $GUI_CHECKED)

			Global $but_duel = GUICtrlCreateButton("    It's time To DUEL    ", 4, 370)

			Global $l_status = GUICtrlCreateLabel("Duellink status: Stopped",270, 383)

		GUICtrlCreateTabItem("Hotkey")
			GUICtrlCreateLabel("F9  : Pause/resume",5,25)
			GUICtrlCreateLabel("F10: Terminate",5,40)

		GUICtrlCreateTabItem("Setting")
			GUICtrlCreateGroup("Street Duel",5, 25,170,40)
				GUIStartGroup()
				Global $cLoop = GUICtrlCreateCheckbox("Loop area", 13,40)
				GUICtrlSetState($cLoop, $GUI_CHECKED)

			GUICtrlCreateGroup("Gate Duel",5, 75,170,40)
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
	WinSetOnTop($hGui,'',$WINDOWS_ONTOP)
	While 1
		If Control_gui(GUIGetMsg()) == -1 Then
			ExitLoop
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
			Case $cLoop
				if _IsChecked($cLoop) Then
					$Loop = True
				Else
					$Loop = false
				EndIf
		EndSwitch
EndFunc

Func _IsChecked($idControlID)
    Return BitAND(GUICtrlRead($idControlID), $GUI_CHECKED) = $GUI_CHECKED
EndFunc