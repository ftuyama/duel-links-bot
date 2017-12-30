#include <MsgBoxConstants.au3>
#include <AutoItConstants.au3>
#include <WinAPI.au3>
#include <GUIConstantsEx.au3>
#include <ButtonConstants.au3>
#Include <GuiEdit.au3>
#include "FastFind.au3"
#include "gui_dlpc.au3"

$FFWnd    = _WinAPI_GetDesktopWindow()
$winPos   = WinGetPos($title)
FFSetWnd($FFWnd)

gui()
;Street_duel(0,0)
;Dbg_print_color(759,439)
;Dbg_excluded(504, 522,0)
;Gate_duel(10)
;--------------------------------------------------------------
#cs
Duel as many as $amount Legendary duelists
#ce
Func Gate_duel($amount)
	Go_to_area(0)
	For $i = 0 To $amount Step 1
		Do
			Click(727, 341)
			Wait_pixel(626, 743, 0xFFFFFF, 5000, "Legendary Duelist list")
			if  Compare_pixel(607, 648,0xFFFFFF) == 0 Then
				Switch duel()
					Case -1
						Return
				EndSwitch
			EndIf
		Until Compare_pixel(607, 648,0xFFFFFF) == 1
		Click(902, 372)
	Next
EndFunc

#cs
Duel any steet duelist availbae at $world(0 for Yu-Gi-Oh and 1 for
Yu-Gi-Oh GX) starting from $start_area
#ce
Func Street_duel($world,$start_area)
	Select
		Case $world = 0
			Local $duelist = [1,2,3,6,7,8,13,14,15,16,17,18]
			Write_log("Yu-Gi-Oh World selected")
		Case $world = 1
			Local $duelist = [1,2,3,4,5,6,7,8,9,10,11,12,13]
			Write_log("Yu-Gi-Oh Gx World selected")
	EndSelect

	Local $area_loop = 0
	For $area=$start_area To 3 Step 1
		Do
			Switch  search($area,99)
				Case -1
					Return
				Case 1
					Write_log("Loot detected")
					$massage = "Recieve Rewards"
					wait_pixel(469, 303,0xFFFFFF,5000,$massage)
					Write_log($massage)
					Click(640, 470)
					Sleep(1000)
			EndSwitch
		Until search($area,99) == 0
		Write_log("Area is clear from loot")

		For $char = 0 To UBound($duelist)-1 Step 1
			Switch search($area,$duelist[$char])
				Case -1
					Return
				Case 1
					duel()
					Sleep(500)
					If Compare_pixel(637, 394, 0xFFFFFF) == 1 Then
						Write_log('Collect fragments')
						Click(642, 425)
					Else
						If Compare_pixel(646, 212, 0x042744) ==1 Then
							vagabond_challange()
						EndIf
					EndIf

					Sleep(700)
					If Compare_pixel(638, 600, 0xFFFFFF) == 1 Then
						Write_log('Duel beacon, its over')
						Click(646, 575)
						Sleep(500)
						Return
					EndIf
				$char = 0
			EndSwitch
		Next
		Write_log("No one here.")

		If (Compare_pixel(436, 72, 0xFFFFFF) == 1) And ($area == 3) Then
			Write_log("There is still standard duelist.")
			Write_log("Go back to gate area")
			$area = -1 ; next iteration(Foor loop in 55) will make $area = $area+1 = -1+1 =0
			$area_loop += 1
			If $area_loop == 2 Then
				Write_log("Can't Find last standard duelist.")
				Write_log("Over.")
				Return
			EndIf
		EndIf
	Next
EndFunc

#cs
Duel with Autowin Skipped duel cheat. Precondition is starting duel dialog.
#ce
Func duel()
	Local $timer
	Local $massage
	Local $time_out

	$massage = "Starting duel"
	Write_log($massage)
	$time_out = 10000
	$timer =  TimerInit()
	While Compare_pixel(640, 103,0x0) == 0 And (TimerDiff($timer)<$time_out)
		Click(600, 653);
	WEnd
	If TimerDiff($timer) >= $time_out Then
		Write_log("Time out!")
		Return -1
	Else
		Write_log(Round(TimerDiff($timer)/1000,1) & " s")
	EndIf

	$massage = "Skipping duel and reward"
	Write_log($massage)
	$time_out = 20000
	$timer =  TimerInit()
	While Compare_pixel(897, 666,0xFFFFFF) == 0 And (TimerDiff($timer)<$time_out)
		Click(644, 708);
		Sleep(500)
	WEnd
	If TimerDiff($timer) >= $time_out Then
		$time_out = 5000
		Write_log("Time out!")
		Write_log("Exit in " & $time_out & " s")
		Sleep($time_out)
		Exit
	Else
		Write_log(Round(TimerDiff($timer)/1000,1) & " s")
	EndIf

	$massage = "Exit Dialouge"
	Write_log($massage)
	Sleep(1000)
	$time_out = 5000
	$timer =  TimerInit()
	While Compare_pixel(640, 736,0xFFFFFF) == 1  And (TimerDiff($timer)<$time_out)
		Click(644, 708)
		Sleep(500)
	WEnd
	If TimerDiff($timer) >= $time_out Then
		$time_out = 5000
		Write_log("Time out!")
		Write_log("Exit in " & $time_out/1000 & " s")
		Sleep($time_out)
		Exit
	Else
		Write_log(Round(TimerDiff($timer)/1000,1) & " s")
	EndIf

	if $nMsg = $GUI_EVENT_CLOSE Then
		Exit
	EndIf
EndFunc

#cs
Vagabond introduce. Set second name in the list and choose one opening hand as challange
#ce
Func vagabond_challange()
	Write_log('Vagabond Introduce')
	Click(629, 319)

	$massage = "Set Challenge"
	Wait_pixel(681, 251, 0xFFFFFF, 2000, $massage)
	Write_log($massage)
	Click(638, 418)

	$massage = "Choose One Opening Hand"
	Wait_pixel(629, 403, 0x001118, 2000, $massage)
	Write_log($massage)
	Click(602, 516)

	$massage = "Confirm"
	Wait_pixel(681, 251, 0xFFFFFF, 2000, $massage)
	Write_log($massage)
	Click(733, 488)

	$massage = "Exit extra dialouge"
	Wait_pixel(823, 593, 0xFFFFFF, 2000, $massage)
	Write_log($massage)
	Click(634, 703)
EndFunc

#cs
Search $object insinde $area
#ce
Func Search($area,$object)
	If Go_to_area($area) == -1 Then
		Return -1
	EndIf
	Duel_world_exclude_area($area)

	Local $found
	Local $hObject = Object_color($object)
	FFAddColor($hObject[1])
	Local $pos  = FFBestSpot(10,7,16,632, 488,-1,2)

	Local $found
	If Not @error Then
		Write_log("Seems like " & $hObject[0] & ", " & $pos[2] & " pixel detected.")
		MouseClick($MOUSE_CLICK_LEFT,$pos[0],$pos[1])
		$found = 1
	Else
		$found = 0
	EndIf
	FFResetColors()
	FFResetExcludedAreas()
	Return $found
EndFunc

#cs
Face color database for duelist and other search able object like orange loot
$n is code for specific object
#ce
Func Object_color($n)
	Select
		Case $n = 1
			Local $face	= [0xF9E7D5,0xF5D1B5,0xFFE4C7,0xFFE2C8,0xFFE3CA]
			Local $return = ["Alyssa", $face]
		Case $n = 2
			Local $face	= [0xEBC29E,0xEBC29E,0xEDC8A1]
			Local $return = ["Nick", $face]
		Case $n = 3
			Local $face   = [0xC79574,0xEDBE9B,0xF6E2D5,0x765752]
			Local $return = ["Emma", $face]
		Case $n = 4
			Local $face   = [0xDBB59C,0xDBB8A0,0xDCBAA4,0xFFEBD2]
			Local $return = ["Zachary", $face]
		Case $n = 5
			Local $face   = [0x675A34,0xECCC7A,0xBDA862,0xB5A164]
			Local $return = ["Alexis", $face]
		Case $n = 6
			Local $face   = [0xEECCBB]
			Local $return = ["Ashley", $face]
		Case $n = 7
			Local $face   = [0xE5C399,0x8B312C,0xBE4545,0xE8C699,0xBD4545] ;
			Local $return = ["Vagabond", $face]
		Case $n = 8
			Local $face   = [0xEECA9B,0xEEC3A4,0xEEC3A1,0xEBC6A0,0xEECB9D,0xEEBE9E,0x664744]
			Local $return = ["Jay", $face]
		Case $n = 9
			Local $face   = [0xFCD8B1,0xFCDBAF,0xFFDCAB,0xFDD4B0,0xFFDAAA,0xFBDAB0,0xFCD9AB,0xFBDAAB]
			Local $return = ["Logan", $face]
		Case $n = 10
			Local $face   = [0xFFE8D2,0xFFE6D3,0xFDEEDC,0xFFE6D5,0xFFE5D8,0xFFE2D9,0xFFEDD4,0xFFE8DC]
			Local $return = ["Madison", $face]
		Case $n = 11
			Local $face   = [0xFEDBAD,0xF6DCAA,0xFDDDAA,0xFEDCAE,0xFCD9AE,0xF8D6B2,0xFADAAD,0xFFDDAB]
			Local $return = ["Evan", $face]
		Case $n = 12
			Local $face   = [0xFFE9CC,0xFFE5D0,0xFFE9CC]
			Local $return = ["Aster", $face]
		Case $n = 13
			Local $face   = [0xF7D6AC,0xFBDEB0,0xFEDCAA,0xF7D5AA,0xF8D4AA,0xF0CBA0,0xFCD1A9,0xF4D1AA,0xF9D6AA]
			Local $return = ["Jesse", $face]
		Case $n = 14
			Local $face   = [0xFFDDBB]
			Local $return = ["Mai", $face]
		Case $n = 15
			Local $face   = [0xEEC09E,0xEBBEA7,0xEEC79E,0xEEC3A1]
			Local $return = ["David", $face]
		Case $n = 16
			Local $face   = [0xD3A08F,0xCCA988,0xCCA688,0xCCA088,0xCCA588,0xCCA188,0xCC9F88,0xCCA788,0xCCA787]
			Local $return = ["Bakura", $face]
		Case $n = 17
			Local $face   = [0xEEC89D,0xE8CBA3,0xEEBFA6,0xE7C59A,0xEDCAA1,0xF6CCA3,0xEEC5A0,0xECC098,0xEEC6A6]
			Local $return = ["Josh", $face]
		Case $n = 18
			Local $face   = [0xA37053,0xA97051,0xA27050,0xA26D4D]
			Local $return = ["Odin", $face]
		Case $n = 99
			Local $face   = [0xFF6600,0xFF7700,0xFF8700,0xFF5700]
			Local $return = ["Loot", $face]
	EndSelect
	Return $return
EndFunc

#cs
Move cursor to ($x,$y)
#ce
Func Move($x,$y)
	$winPos   = WinGetPos($title)
	MouseMove($x+$winPos[0], $y+$winPos[1])
EndFunc

#cs
Do a single mouse click at ($x,$y)
#ce
Func Click($x,$y)
	$winPos   = WinGetPos($title)
	MouseClick($MOUSE_CLICK_LEFT,$x+$winPos[0], $y+$winPos[1],1,5)
EndFunc

#cs
Take SnapShot of current screen. Refer to FastFind.chm for information
#ce
Func SnapShot($x1, $y1, $x2, $y2)
	$winPos   = WinGetPos($title)
	FFSnapShot($x1+$winPos[0], $y1+$winPos[1], $x2+$winPos[0], $y2+$winPos[1])
EndFunc

#cs
return color of pixel at ($x,$y)
#ce
Func GetPixel($x, $y)
	FFSnapShot()
	$winPos   = WinGetPos($title)
	Return FFGetPixel($x+$winPos[0], $y+$winPos[1])
EndFunc

#cs
Add exclude zone inside rectangle that defined by two coordinate
($x1, $y1) and  ($x2, $y2)
#ce
Func AddExcludedArea($x1, $y1, $x2, $y2)
	$winPos   = WinGetPos($title)
	FFAddExcludedArea($x1+$winPos[0], $y1+$winPos[1], $x2+$winPos[0], $y2+$winPos[1])
EndFunc

#cs
Return current area code
0:Gate
1:Duel
2:Shop
3:Studio
#ce
Func Get_area()
	SnapShot(372, 698, 914, 745)
	Local $pos =FFBestSpot(7, 4, 9, 655+$winPos[0], 721+$winPos[1], 0x001AFF, 10, False)
	If Not @error Then
		;MouseMove($pos[0], $pos[1])
		Local $area = 0
		Switch $pos[0]-$winPos[0]
			Case 392 To 500
				$area = 0
			Case 519 To 634
				$area = 1
			Case 647 To 741
				$area = 2
			Case 764 To 868
				$area = 3
		EndSwitch
		Return $area
		;MsgBox(0, "Area", $area & " at " &$pos[0]&", "&$pos[1])
	Else
		Write_log("Area can't be decided.")
		Write_log("Make sure four area tab is visible")
		Return -1
	EndIf
EndFunc

#cs
Go to $des_area
#ce
Func Go_to_area($des_area)
	Local $cur_area = Get_area()
	If  $cur_area<> $des_area Then
		If $cur_area == -1 Then
			Return -1
		EndIf
		Local $massage = ""
		Select
			Case $des_area = 0
				Click(463, 722)
				$massage = "Go to Gate area"
			Case $des_area = 1
				Click(592, 721)
				$massage = "Go to Duel area"
			Case $des_area = 2
				Click(710, 722)
				$massage = "Go to Shop area"
			Case $des_area = 3
				Click(835, 722)
				$massage = "Go to Studio area"
		EndSelect
		Sleep(1000)
	EndIf
EndFunc

#cs
Return 1 if pixel at ($x,$y) is exactly has $color color
#ce
Func Compare_pixel($x,$y,$color)
	$winPos   = WinGetPos($title)
	If GetPixel($x, $y) <> $color Then
		return 0
	Else
		Return 1
	EndIf
EndFunc

#cs
wait for $color show at ($x, $y). When $time_out pass it will show error
with $massage text
#ce
Func Wait_pixel($x,$y,$color,$time_out,$massage)
	Local $timer = TimerInit()
	While Compare_pixel($x, $y, $color) == 0 And (TimerDiff($timer)< $time_out)
	WEnd
	If TimerDiff($timer)>=$time_out Then
		MsgBox($MB_ICONERROR,"Error","Timeout "&$massage)
		Exit
	Endif
	Sleep(500)
EndFunc

#cs
Add exclude zone that not will considere by search function for specific
$area. There is foour area correspond from Gate, duel, shop, card studio area
respectively. Every $area has uniqe exclude zone.
#ce
Func Duel_world_exclude_area($area)
	AddExcludedArea(  0, 0, 372, 749);left pane
	AddExcludedArea(  913, 0, 1286, 749);right pane
	AddExcludedArea(  372, 0, 914, 405);top pane
	AddExcludedArea( 372, 653, 914, 749);bottom pane
	AddExcludedArea( 764, 490, 914, 653);character pane
	Switch $area
		Case 0
			AddExcludedArea(371, 357,565, 506);duel school
		Case 1
			AddExcludedArea(369, 389,506, 684);left
			AddExcludedArea(679, 394, 914, 665);right
			AddExcludedArea(668, 465,716, 549);street repaly
		Case 2
			AddExcludedArea(716, 549,669, 648);card trader
			AddExcludedArea(371, 358,469, 687);left
			AddExcludedArea(445, 521,501, 687);bottom left flower
		Case 3
			Switch $world
				Case 0
					AddExcludedArea(370, 420,480, 647);right
				Case 1
					AddExcludedArea(370, 420,581, 658);right
			EndSwitch
			AddExcludedArea(757, 428,912, 648);left
	EndSwitch
EndFunc

#cs
Check if point ($x,$y) in $area is excluded from search zone.
#ce
Func Dbg_excluded($x,$y,$area)
	duel_world_exclude_area($area)
	If IsExcluded($x,$y) Then
		MsgBox(0,"","Excluded")
	EndIf
EndFunc

#cs
Helper function for Dbg_excluded($x,$y,$area)
#ce
Func IsExcluded($x,$y)
	$winPos   = WinGetPos($title)
	Return FFIsExcluded($x+$winPos[0], $y+$winPos[1],$FFWnd)
EndFunc

#cs
Show pixel color of coordinate ($x,$y)
#ce
Func Dbg_print_color($x,$y)
	MsgBox($MB_SYSTEMMODAL, "Color", Hex(GetPixel($x,$y)));
	Move($x,$y)
	Exit
EndFunc

#cs
Show mean color of areas inside rectangle that defined by two coordinate
($x1, $y1) and  ($x2, $y2)
#ce
Func Dbg_print_mean($x1, $y1, $x2, $y2)
	GUICreate("Mean", 200,20)
	$display = GUICtrlCreateLabel("", 0, 0, 100, 20)
	GUISetState()

	While 1
        $msg = GUIGetMsg()
        Select
            Case $msg = $GUI_EVENT_CLOSE
                ExitLoop
            Case Else
				SnapShot($x1, $y1, $x2, $y2)
				$mean = FFComputeMeanValues()
				GUICtrlSetData($display,"Red" & $mean[0] & " G" & $mean[1] & " B" &  $mean[2])
        EndSelect
    WEnd
EndFunc

#cs
Debug mode for search() function
#ce
Func Dbg_search($area,$object)
	If Go_to_area($area) == -1 Then
		MsgBox(0, "Error", "Area can't be decided")
		Exit
	EndIf
	Duel_world_exclude_area($area)

	Local $found
	Local $hObject = Object_color($object)
	FFAddColor($hObject[1])
	Local $pos  = FFBestSpot(10,7,16,632, 488,-1,2)

	If Not @error Then
		Move($pos[0], $pos[1])
		MsgBox(0,"", $hObject[0] & " at " & $pos[0] & ", " & $pos[1] &" " &$pos[2]  & " pixel detected." )
	Else
		MsgBox(0,"", "Not found" )
	EndIf
	FFResetColors()
	FFResetExcludedAreas()
	Exit
EndFunc