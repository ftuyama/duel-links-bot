#include <MsgBoxConstants.au3>
#include <AutoItConstants.au3>
#include <WinAPI.au3>
#include "FastFind.au3"
#include "duelists.au3"
#include "events.au3"

Global $title = "[TITLE:Yu-Gi-Oh! DUEL LINKS]"
Global $world = 0
Global $timer = TimerInit()
Global $Loop  = True
Global $CheckGems = True
Global $auto_orb_reload = False
Global $sPaused = False
$FFWnd = _WinAPI_GetDesktopWindow()
$winPos = WinGetPos($title)
FFSetWnd($FFWnd)

#cs
	Gate duel using the first character that appears
	; Click(902, 372) ;next legendary duelist
#ce
Func Gate_duel($amount)
   Go_to_area(0)
   For $i = 0 To $amount Step 1
		Click(727, 341)
		Write_log("Click duel gate.")
		Wait_pixel(626, 743, 0xFFFFFF, 10000, "Legendary Duelist list")
		Wait_pixel(632, 654, 0xF8D627, 10000, "Duel text golden color")
		Click(632, 654)
		Write_log("Du-du-du-el")
		letsDuel()
		Sleep(200)
	Next
EndFunc   ;==>Gate_duel

#cs
Duel any steet duelist availbae at $world(0 for Yu-Gi-Oh and 1 for
	Yu-Gi-Oh GX) starting from $start_area
#ce
Func Street_duel($world, $start_area)
	$duelist = Get_duelists($world)

	For $area = $start_area To 3 Step 1
		Do
			Local $hSearch = Search($area, 99)
			Switch $hSearch
				Case -1
					Return
				Case 1
					Write_log("Loot detected")
					$message = "Receive Rewards"
					Wait_pixel(500, 460, 0xFFFFFF, 5000, $message)
					Write_log($message)
					Sleep(1000)
					Click(640, 460)
					Sleep(500)
			EndSwitch
		Until $hSearch == 0
		Write_log("Area is clear from loot")

		For $char = 0 To UBound($duelist) - 1 Step 1
			Switch Search($area, $duelist[$char])
				Case -1
					Return
				Case 1
					 If letsDuel() == 1 Then
					   Sleep(200)
					   If Compare_pixel(637, 394, 0xFFFFFF) == 1 Then
						   Write_log('Collect fragments')
						   Click(642, 425)
					   Else
						   If Compare_pixel(596, 427, 0x8C0606) == 1 Then
							   vagabond_challange()
						   EndIf
					   EndIf

					   Sleep(700)
						Auto_orb()
					   $char = 0
					 EndIf
			EndSwitch
		Next
		Write_log("No one here.")

		; Additional routines
		If $CheckGems Then
			Grant_gems($area)
		EndIf
		If $auto_orb_reload Then
			Auto_orb()
		EndIf

		If $Loop And $area == 3 Then
			$area = -1
		EndIf
	Next
	Write_log("Street duel over")
	Return
 EndFunc   ;==>Street_duel

Func Auto_orb()
   If Compare_pixel(456, 68, 0x6666AA) == 1 And Compare_pixel(456, 77, 0x6666AA) == 1 Then
	  Write_log('Duel beacon, Standard duelist depleted.')
	  If $auto_orb_reload Then
		 Click(400, 75)

		 $massage = "Use Duel beacon"
		 Write_log($massage)
		 Wait_pixel(569, 179, 0xFFCC00, 10000, $massage)
		 Click(600, 240)

		 $massage = "Confirm"
		 Write_log($massage)
		 Wait_pixel(515, 430, 0x870505, 10000, $massage)
		 Click(700, 430)
		 Sleep(2000)
		 Click(700, 430)
		 Sleep(1000)
	  Else
		 Write_log('Orb auto reload disabled.')
	  EndIf
   EndIf
EndFunc

Func Grant_gems($area)
	Write_log("Granting gems")
	Switch $area
	  Case 0
		 Click(650, 360)
		 Handle_gems_dialog()
	  Case 1
		 Click(800, 455)
		 Handle_gems_dialog()
	  Case 2
		 Click(600, 300)
		 Handle_gems_dialog()
	  Case 3
		 Click(560, 580)
		 Handle_gems_dialog()
	EndSwitch
 EndFunc

Func Handle_gems_dialog()
   	If Wait_pixel(500, 400, 0xFFFFFF, 8000, 'Waiting gems') == 0 And Wait_pixel(780, 400, 0xFFFFFF, 500, 'Waiting gems') == 0 Then
		Click(650, 480)
		Sleep(2000)
	EndIf
EndFunc

; Checks if gems balance is visible at the top
Func Has_gems_balance_visible()
	Return Compare_pixel(855, 76, 0x9453AB) == 1 And Compare_pixel(861, 69, 0x09F7F0) == 1
EndFunc


#cs
Duel with Autowin Skipped duel cheat. Precondition is starting duel dialog.

                 ___====-_  _-====___
           _--^^^#####//      \\#####^^^--_
        _-^##########// (    ) \\##########^-_
       -############//  |\^^/|  \\############-
     _/############//   (@::@)   \\############\_
    /#############((     \\//     ))#############\
   -###############\\    (oo)    //###############-
  -#################\\  / VV \  //#################-
 -###################\\/      \//###################-
_#/|##########/\######(   /\   )######/\##########|\#_
|/ |#/\#/\#/\/  \#/\##\  |  |  /##/\#/  \/\#/\#/\#| \|
`  |/  V  V  `   V  \#\| |  | |/#/  V   '  V  V  \|  '
   `   `  `      `   / | |  | | \   '      '  '   '
                    (  | |  | |  )
                   __\ | |  | | /__
                  (vvv(VVV)(VVV)vvv)


Lalalalala
#ce
Func letsDuel()
	Local $massage
	Local $time_out
	Local $count = 0

   Sleep(1000)
   If has_white_dialog() Then
	  While has_white_dialog()
		 Write_log("Reading dialog")
		 Click(700, 653)
		 Sleep(1000)
	  WEnd
   Else
	  Write_log("No white dialog")
	  If $world = 7 Then
		Sleep(7000) ; Yu-gi-oh Sevens is so damn slow
	  Else
		Sleep(3000)
	  EndIf

	  ; Confirm there's a duel screen
	  If has_duel_screen() Then
		 Write_log("Duel screen found")
	  Else
	    Write_log("No duel screen, skipping")
		Return 0;
	  EndIf
   EndIf

   ; Start auto duel
   Click(700, 653)
   Sleep(1000)
   Click(700, 653)
   Write_log("Duel Started!")
   Sleep(10000)

	; Wait for duel end
    $time_out = 300000
	$timer = TimerInit()
	While (TimerDiff($timer) < $time_out) And (get_area(0) == -1)
	   While (TimerDiff($timer) < $time_out) And (get_area(0) == -1)
		   Click(644, 708);
		   vagabond_challange()
		   $count += 1
		   If Mod($count, 10) = 0 Then
				Write_log("Waiting Duel")
		   EndIf
		   Sleep(1000)
	   WEnd
	   Sleep(3000)
    WEnd
    Write_log("Duel Finished")
	WriteTimeout($timer, $time_out)
	CloseDialogue()

	Return 1;
EndFunc   ;==>letsDuel

Func CloseDialogue()
	Write_log("Exit Dialogue")
	Sleep(1000)

	$time_out = 5000
	$timer = TimerInit()
	While Compare_pixel(640, 736, 0xFFFFFF) == 1 And (TimerDiff($timer) < $time_out)
		Click(644, 708)
		Sleep(1000)
	WEnd
	;WriteTimeout($timer, $time_out)
EndFunc  ;==>CloseDialogue

Func WriteTimeout($timer, $time_out)
	If TimerDiff($timer) >= $time_out Then
		$time_out = 5000
		Write_log("Time out!")
		Write_log("Exit in " & $time_out / 1000 & " s")
		Sleep($time_out)
		Exit
	Else
		Write_log(time_s(TimerDiff($timer)) & " s")
	EndIf
EndFunc

#cs
	Vagabond introduce. Set second name in the list and choose one opening hand as challange
#ce
Func vagabond_challange()
   If Compare_pixel(520, 380, 0xFFFFFF) == 1 AND Compare_pixel(780, 380, 0xFFFFFF) == 1 Then
	  Sleep(1000)
	  If Compare_pixel(520, 380, 0xFFFFFF) == 1 AND Compare_pixel(780, 380, 0xFFFFFF) == 1 Then
		  Write_log('Decline to check oponent deck')
		  Click(550, 430)
	  EndIf
	EndIf
EndFunc   ;==>vagabond_challange

#cs
	Search $object insinde $area
#ce
Func Search($area, $object)
	If Go_to_area($area) == -1 Then
		Return -1
	EndIf
	Duel_world_exclude_area($area)

	Local $found
	Local $hObject = Object_color($object)
	FFAddColor($hObject[1])
	Local $pos = FFBestSpot(10, 7, 16, 632, 488, -1, 2, True, 372, 54, 913, 749)

	Local $found
	If Not @error Then
		Write_log("Seems like " & $hObject[0] & ", " & $pos[2] & " pixel detected.")
		ClickOn($pos[0], $pos[1], 2)
		$found = 1
	Else
		$found = 0
	EndIf
	FFResetColors()
	FFResetExcludedAreas()
	Return $found
EndFunc   ;==>Search

Func Move($x, $y)
	$winPos = WinGetPos($title)
	MouseMove($x + $winPos[0], $y + $winPos[1],0)
EndFunc   ;==>Move

#cs
	Do a single mouse click at ($x,$y)
#ce
Func Click($x, $y)
	If $x > 372 And $x < 913 And $y > 54 And $y < 749 Then
		$winPos = WinGetPos($title)
		ClickOn($x + $winPos[0], $y + $winPos[1], 1)
	Else
		MsgBox(0, "Error", "What the heck! Don't click outside the game!" + $x + ', ' + $y)
	EndIf
EndFunc   ;==>Click


#cs
	Wrap MouseClick
#ce
Func ClickOn($x, $y, $clicks)
	$winPos = WinGetPos($title)
	If $x - $winPos[0] > 372 And $x - $winPos[0] < 913 And $y + $winPos[1] > 54 And $y + $winPos[1] < 749 Then
		MouseClick($MOUSE_CLICK_LEFT, $x, $y, $clicks)
	Else
		MsgBox(0, "Error", "What the heck! Don't click outside the game!" + $x + ', ' + $y)
	EndIf
EndFunc   ;==>Click

#cs
	Take SnapShot of current screen. Refer to FastFind.chm for information
#ce
Func SnapShot($x1, $y1, $x2, $y2)
	$winPos = WinGetPos($title)
	FFSnapShot($x1 + $winPos[0], $y1 + $winPos[1], $x2 + $winPos[0], $y2 + $winPos[1])
EndFunc   ;==>SnapShot

#cs
	return color of pixel at ($x,$y)
#ce
Func GetPixel($x, $y)
	FFSnapShot()
	$winPos = WinGetPos($title)
	Return FFGetPixel($x + $winPos[0], $y + $winPos[1])
EndFunc   ;==>GetPixel

#cs
	Add exclude zone inside rectangle that defined by two coordinate
	($x1, $y1) and  ($x2, $y2)
#ce
Func AddExcludedArea($x1, $y1, $x2, $y2)
	$winPos = WinGetPos($title)
	FFAddExcludedArea($x1 + $winPos[0], $y1 + $winPos[1], $x2 + $winPos[0], $y2 + $winPos[1])
EndFunc   ;==>AddExcludedArea

#cs
	Return current area code
	0:Gate
	1:Duel
	2:Shop
	3:Studio
	4:Initial Screen
#ce
Func get_area($force)
	; If gems balance is visible, check which tab is active
	If Has_gems_balance_visible() Then
		$active_tab = get_active_tab()

		If $active_tab <> - 1 Then
			Return $active_tab
		EndIf
	EndIf

	; Check if we are in the initial screen
	If initial_screen() Then
		Write_log("Initial screen, starting game")
		Click(650, 470)
		Sleep(10000)
		Return 4
	EndIf

	If $force == 1 Then
		; Keep searching, Bot is lost
		If Has_gems_balance_visible() Then
			Write_log("Gems balance is visible, but Bot is lost...")
		EndIf
		Write_log("Area can't be decided.")
		Write_log("Make sure four area tab is visible.")
		Close_open_menu()
		Sleep(3000)
		Return get_area($force)
	EndIf

	Return -1
EndFunc   ;==>get_area


#cs
	Return current area code
	0:Gate
	1:Duel
	2:Shop
	3:Studio
	-1:Not found

	Debug:
		Write_log("Area1 " & $area1 & " at " &$pos1[0]&" & "&$pos1[1])
		Write_log("Area2 " & $area2 & " at " &$pos2[0]&" & "&$pos2[1])
#ce
Func get_active_tab()
	; Screenshot screen
	SnapShot(372, 698, 914, 745)
	; Use two points colors to identify active tab
	Local $pos1 = FFBestSpot(7, 4, 9, 655 + $winPos[0], 721 + $winPos[1], 0x001AFF, 10, False)
	Local $pos2 = FFBestSpot(7, 4, 9, 655 + $winPos[0], 721 + $winPos[1], 0x0012FF, 10, False)

	If Not @error Then
		$area1 = get_identified_area($pos1, $winPos)
		$area2 = get_identified_area($pos2, $winPos)

		If $area1 == $area2 Then
			;Write_log("Area1 " & $area1 & " at " &$pos1[0]&" & "&$pos1[1])
			;Write_log("Area2 " & $area2 & " at " &$pos2[0]&" & "&$pos2[1])
			Return $area1
		Else
			Write_log("Area can't be decided. Conflict.")
		EndIf
	EndIf

	Return -1
EndFunc

Func initial_screen()
	Local $initial_screen_pixels[26][3] = [[441, 121, 0xE20011], [455, 121, 0xEE0011], [446, 150, 0xD70000], [447, 170, 0xDD0000], [486, 193, 0xEE0011], [502, 158, 0xFFFFFF], [491, 126, 0xFFFFFF], [500, 137, 0xFFFFFF], [513, 128, 0xFFFFFF], [522, 108, 0x333333], [530, 146, 0xFFFFFF], [559, 151, 0xFFFFFF], [597, 129, 0xFFFFFF], [612, 165, 0xFFFFFF], [641, 147, 0xFFFFFF], [663, 133, 0xFFFFFF], [661, 115, 0xFFFFFF], [686, 97, 0xEE0011], [697, 172, 0xEE0011], [709, 156, 0xFFFFFF], [741, 142, 0xFFFFFF], [767, 125, 0xFFFFFF], [797, 150, 0xFFFFFF], [790, 104, 0xDE0011], [778, 73, 0xE7E7E7], [778, 84, 0xEE0011]]

	Return Compare_pixels($initial_screen_pixels)
EndFunc

Func Close_open_menu()
	; Check for back and home button
	Local $pixels[10][3] = [[403, 726, 0xFFFFFF], [417, 725, 0xFFFFFF], [424, 726, 0xFFFFFF], [398, 724, 0xFFFFFF], [403, 719, 0xFFFFFF], [403, 730, 0xFFFFFF], [396, 732, 0x02338D], [395, 714, 0x002264], [422, 714, 0x002264], [422, 732, 0x003396]]

	If Compare_pixels($pixels) Then
		Write_log("Going back home")
		Click(400, 725) ;home button
	EndIf
EndFunc

#cs
	Return current area code
	0:Gate
	1:Duel
	2:Shop
	3:Studio
#ce
Func get_identified_area($pos, $winPos)
	Local $area = 0
	Switch $pos[0] - $winPos[0]
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
EndFunc   ;==>get_identified_area

#cs
	Go to $des_area
#ce
Func Go_to_area($des_area)
	Local $cur_area = get_area(1)
	If $cur_area <> $des_area Then
		If $cur_area == -1 Then
			Return -1
		EndIf
		Local $massage = ""
		Select
			Case $des_area = 0
				Click(463, 722)
				$massage = "Go to Gate area"
				Sleep(800)
			Case $des_area = 1
				Click(592, 721)
				$massage = "Go to Duel area"
				Sleep(800)
			Case $des_area = 2
				Click(710, 722)
				$massage = "Go to Shop area"
				Sleep(800)
			Case $des_area = 3
				Click(835, 722)
				$massage = "Go to Studio area"
				Sleep(800)
		EndSelect
		Sleep(200)
		Write_log($massage)
	EndIf
EndFunc   ;==>Go_to_area

#cs
	Return 1 if pixel at ($x,$y) is exactly has $color color
#ce
Func Compare_pixel($x, $y, $color)
	$winPos = WinGetPos($title)
	If GetPixel($x, $y) <> $color Then
		Return 0
	Else
		Return 1
	EndIf
EndFunc   ;==>Compare_pixel

#cs
	Loop Compare_pixel
#ce
Func Compare_pixels($pixels)
    For $i = 0 To UBound($pixels) - 1
        $x = $pixels[$i][0]
        $y = $pixels[$i][1]
        $color = $pixels[$i][2]
        If GetPixel($x, $y) <> $color Then
            Return 0
        EndIf
    Next
    Return 1
EndFunc   ;==>Compare_pixels

#cs
	wait for $color show at ($x, $y). When $time_out pass it will show error
	with $massage text
#ce
Func Wait_pixel($x, $y, $color, $time_out, $massage)
	$timer = TimerInit()
	While Compare_pixel($x, $y, $color) == 0 And (TimerDiff($timer) < $time_out)
	WEnd
	If TimerDiff($timer) >= $time_out Then
		Write_log("Timeout " & $massage)
		Return -1
	EndIf
	Return 0
EndFunc   ;==>Wait_pixel

#cs
	Add exclude zone that not will considere by search function for specific
	$area. There is foour area correspond from Gate, duel, shop, card studio area
	respectively. Every $area has uniqe exclude zone.
#ce
Func Duel_world_exclude_area($area)
	AddExcludedArea(0, 0, 372, 749) ;left pane
	AddExcludedArea(913, 0, 1286, 749) ;right pane
	AddExcludedArea(372, 0, 914, 405) ;top pane
	AddExcludedArea(372, 653, 914, 749) ;bottom pane
	AddExcludedArea(525, 626, 752, 689);Event fragment
	AddExcludedArea(764, 480, 914, 653) ;character pane
	Switch $area
		Case 0
			AddExcludedArea(371, 357, 565, 506) ;duel school
		Case 1
			AddExcludedArea(369, 389, 506, 684) ;left
			AddExcludedArea(708, 394, 914, 665) ;right
		Case 2
			AddExcludedArea(716, 549, 669, 648) ;card trader
			AddExcludedArea(371, 358, 469, 687) ;left
			AddExcludedArea(445, 521, 501, 687) ;bottom left flower
			Switch $world
				Case 1
					AddExcludedArea(460, 426,570, 461);river maybe
			EndSwitch
		Case 3
			Switch $world
				Case 0
					AddExcludedArea(370, 420, 480, 647) ;right
				Case 1
					AddExcludedArea(370, 420, 581, 658) ;right
			EndSwitch
			AddExcludedArea(757, 428, 912, 648) ;left
	EndSwitch
EndFunc   ;==>Duel_world_exclude_area

#cs
	Return timer variabel in milisecond into second unit
#ce
Func time_s($time)
	Return Round($time / 1000, 1)
EndFunc   ;==>time_s

#cs
	Check if point ($x,$y) in $area is excluded from search zone.
#ce
Func Dbg_excluded($x, $y, $area, $in_world)
	$world = $in_world
	Duel_world_exclude_area($area)
	If IsExcluded($x, $y) Then
		MsgBox(0, "", "Excluded")
	Else
		MsgBox(0, "", "Clear")
	EndIf
EndFunc   ;==>Dbg_excluded

#cs
	Helper function for Dbg_excluded($x,$y,$area)
#ce
Func IsExcluded($x, $y)
	$winPos = WinGetPos($title)
	Return FFIsExcluded($x + $winPos[0], $y + $winPos[1], $FFWnd)
EndFunc   ;==>IsExcluded

#cs
	Show pixel color of coordinate ($x,$y)
#ce
Func Dbg_print_color($x, $y)
	MsgBox($MB_SYSTEMMODAL, "Color", Hex(GetPixel($x, $y))) ;
	Move($x, $y)
	Exit
EndFunc   ;==>Dbg_print_color

#cs
	Show mean color of areas inside rectangle that defined by two coordinate
	($x1, $y1) and  ($x2, $y2)
#ce
Func Dbg_print_mean($x1, $y1, $x2, $y2)
	GUICreate("Mean", 200, 20)
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
				GUICtrlSetData($display, "Red" & $mean[0] & " G" & $mean[1] & " B" & $mean[2])
		 EndSelect
	WEnd
EndFunc   ;==>Dbg_print_mean

#cs
	Debug mode for search() function
#ce
Func Dbg_search($world_in, $area, $object)
	$world = $world_in
	If Go_to_area($area) == -1 Then
		MsgBox(0, "Error", "Area can't be decided")
		Exit
	EndIf
	Duel_world_exclude_area($area)

	Local $found
	Local $hObject = Object_color($object)
	FFAddColor($hObject[1])
	Local $pos = FFBestSpot(10, 7, 16, 632, 488, -1, 2)

	If Not @error Then
		MsgBox(0, "", $hObject[0] & " at " & $pos[0] & ", " & $pos[1] & " " & $pos[2] & " pixel detected.")
		ClickOn($pos[0], $pos[1], 2)
	Else
		MsgBox(0, "", "Not found")
	EndIf
	FFResetColors()
	FFResetExcludedAreas()
	Exit
EndFunc   ;==>Dbg_search

Func duel_over()
   Return Compare_pixel(420, 725, 0xFFFFFF) == 1 AND Compare_pixel(800, 150, 0x001E52) == 1
EndFunc

Func has_duel_screen()
   Return Compare_pixel(700, 700, 0x000000) == 1 AND Compare_pixel(700, 750, 0x000000) == 1
EndFunc

Func has_white_dialog()
   Return Compare_pixel(700, 700, 0xFFFFFF) == 1 AND Compare_pixel(700, 750, 0xFFFFFF) == 1
EndFunc