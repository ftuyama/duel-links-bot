#include <MsgBoxConstants.au3>
#include <AutoItConstants.au3>
#include <WinAPI.au3>
#include "FastFind.au3"

Global $title = "[TITLE:Yu-Gi-Oh! DUEL LINKS]"
Global $world = 0
Global $timer = TimerInit()
Global $Loop  = True
Global $auto_orb_reload = False
Global $orb_depleted = False
Global $sPaused = False
$FFWnd = _WinAPI_GetDesktopWindow()
$winPos = WinGetPos($title)
FFSetWnd($FFWnd)

Func Gate_duel($amount)
   Go_to_area(0)
   For $i = 0 To $amount Step 1
	  Click(727, 341)
	  Write_log("Click duel gate.")
	  Wait_pixel(626, 743, 0xFFFFFF, 10000, "Legendary Duelist list")
	  If Compare_pixel(498, 646, 0xFFFFFF) == 0 Then
		 Switch duel()
			Case -1
			   Return
		 EndSwitch
	  Else
		 Write_log("Color key depleted")
		 Click(902, 372);next legendary duelist
	  EndIf
	  Sleep(200)
   Next
EndFunc   ;==>Gate_duel

#cs
Duel any steet duelist availbae at $world(0 for Yu-Gi-Oh and 1 for
	Yu-Gi-Oh GX) starting from $start_area
#ce
Func Street_duel($world, $start_area)
	Select
		Case $world = 0
			Local $duelist = [1, 2, 3, 6, 7, 8, 13, 14, 15, 16, 17, 18, 19]
			Write_log("Yu-Gi-Oh World selected")
		Case $world = 1
			Local $duelist = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13]
			Write_log("Yu-Gi-Oh Gx World selected")
	EndSelect

	For $area = $start_area To 3 Step 1
		Do
			Local $hSearch = Search($area, 99)
			Switch $hSearch
				Case -1
					Return
				Case 1
					Write_log("Loot detected")
					$massage = "Recieve Rewards"
					Wait_pixel(500, 460, 0xFFFFFF, 5000, $massage)
					Write_log($massage)
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
					 If duel() == 1 Then
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
		Grant_gems($area)

		If $Loop And $area == 3 Then
			$area = -1
		EndIf
	Next
	Write_log("Street duel over")
	Return
 EndFunc   ;==>Street_duel

Func Auto_orb()
   If Compare_pixel(638, 600, 0xFFFFFF) == 1 Then
	  Write_log('Duel beacon, Standard duelist depleted.')
	  $orb_depleted = True
	  If $auto_orb_reload Then
		 Click(694, 472)

		 $massage = "Use Duel beacon"
		 Write_log($massage)
		 Wait_pixel(678, 347, 0xFFFFFF, 10000, $massage)
		 Click(745, 413)

		 $massage = "Confirm"
		 Write_log($massage)
		 Wait_pixel(488, 297, 0xFFFFFF, 10000, $massage)
		 Click(643, 443)
		 $orb_depleted = False
		 Sleep(500)
	  Else
		 Write_log('Orb auto reload disabled.')
		 Click(632, 630)
		 Sleep(500)
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
    $time_out = 6000
	$timer = TimerInit()

   While (TimerDiff($timer) < $time_out) AND NOT Has_gems_dialog()
	  Write_log("Waiting dialog")
	  Sleep(1000)
   WEnd

   If Has_gems_dialog() Then
	  Sleep(500)
	  Click(650, 480)
	  Sleep(2000)
   EndIf
EndFunc

Func Has_gems_dialog()
   Return (Compare_pixel(500, 400, 0xFFFFFF) == 1 AND Compare_pixel(780, 400, 0xFFFFFF) == 1)
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
Func duel()
	Local $massage
	Local $time_out

   Sleep(1000)
   If has_white_dialog() Then
	  While has_white_dialog()
		 Write_log("Reading dialog")
		 Click(700, 653)
		 Sleep(1000)
	  WEnd
   Else
	  Return 0;
   EndIf

   Click(700, 653)
   Sleep(1000)
   Click(700, 653)
   Write_log("Waiting Duel")
   Sleep(10000)

    $time_out = 300000
	$timer = TimerInit()
	While (TimerDiff($timer) < $time_out) And (get_area(0) == -1)
	   While (TimerDiff($timer) < $time_out) And (get_area(0) == -1)
		   Click(644, 708);
		   Write_log("Waiting Duel")
		   vagabond_challange()
		   Sleep(1000)
	   WEnd
	   Sleep(1500)
    WEnd
	WriteTimeout($timer, $time_out)

	Write_log("Exit Dialouge")
	Sleep(1000)

	$time_out = 5000
	$timer = TimerInit()
	While Compare_pixel(640, 736, 0xFFFFFF) == 1 And (TimerDiff($timer) < $time_out)
		Click(644, 708)
		Sleep(1000)
	WEnd
	WriteTimeout($timer, $time_out)
	Return 1;
 EndFunc   ;==>duel

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
	Local $pos = FFBestSpot(10, 7, 16, 632, 488, -1, 2)

	Local $found
	If Not @error Then
		Write_log("Seems like " & $hObject[0] & ", " & $pos[2] & " pixel detected.")
		MouseClick($MOUSE_CLICK_LEFT, $pos[0], $pos[1],2)
		$found = 1
	Else
		$found = 0
	EndIf
	FFResetColors()
	FFResetExcludedAreas()
	Return $found
EndFunc   ;==>Search

#cs
	Face color database for duelist and other search able object like orange loot
	$n is code for specific object
#ce
Func Object_color($n)
	Select
		Case $n = 1
			Local $face = [0xF9E7D5, 0xF5D1B5, 0xFFE4C7, 0xFFE2C8, 0xFFE3CA]
			Local $return = ["Alyssa", $face]
		Case $n = 2
			Local $face = [0xEBC29E, 0xEBC29E, 0xEDC8A1]
			Local $return = ["Nick", $face]
		Case $n = 3
			Local $face = [0xC79574, 0xEDBE9B, 0xF6E2D5, 0x765752]
			Local $return = ["Emma", $face]
		Case $n = 4
			Local $face = [0xDBB59C, 0xDBB8A0, 0xDCBAA4, 0xFFEBD2]
			Local $return = ["Zachary", $face]
		Case $n = 5
			Local $face = [0x675A34, 0xECCC7A, 0xBDA862, 0xB5A164]
			Local $return = ["Alexis", $face]
		Case $n = 6
			Local $face = [0xEECCBB]
			Local $return = ["Ashley", $face]
		Case $n = 7
			Local $face = [0xE5C399, 0xDFC599, 0xE6C399, 0xE8C699, 0xE5C499,0xE5BEA1] ;
			Local $return = ["Vagabond", $face]
		Case $n = 8
			Local $face = [0xEECA9B, 0xEEC3A4, 0xEEC3A1, 0xEBC6A0, 0xEECB9D, 0xEEBE9E, 0x664744]
			Local $return = ["Jay", $face]
		Case $n = 9
			Local $face = [0xFCD8B1, 0xFCDBAF, 0xFFDCAB, 0xFDD4B0, 0xFFDAAA, 0xFBDAB0, 0xFCD9AB, 0xFBDAAB]
			Local $return = ["Logan", $face]
		Case $n = 10
			Local $face = [0xFFE8D2, 0xFFE6D3, 0xFDEEDC, 0xFFE6D5, 0xFFE5D8, 0xFFE2D9, 0xFFEDD4, 0xFFE8DC]
			Local $return = ["Madison", $face]
		Case $n = 11
			Local $face = [0xFEDBAD, 0xF6DCAA, 0xFDDDAA, 0xFEDCAE, 0xFCD9AE, 0xF8D6B2, 0xFADAAD, 0xFFDDAB]
			Local $return = ["Evan", $face]
		Case $n = 12
			Local $face = [0xFFE9CC, 0xFFE5D0, 0xFFE9CC]
			Local $return = ["Aster", $face]
		Case $n = 13
			Local $face = [0xF7D6AC, 0xFBDEB0, 0xFEDCAA, 0xF7D5AA, 0xF8D4AA, 0xF0CBA0, 0xFCD1A9, 0xF4D1AA, 0xF9D6AA]
			Local $return = ["Jesse", $face]
		Case $n = 14
			Local $face = [0xFFDDBB]
			Local $return = ["Mai", $face]
		Case $n = 15
			Local $face = [0xEEC09E, 0xEBBEA7, 0xEEC79E, 0xEEC3A1]
			Local $return = ["David", $face]
		Case $n = 16
			Local $face = [0xD3A08F, 0xCCA988, 0xCCA688, 0xCCA088, 0xCCA588, 0xCCA188, 0xCC9F88, 0xCCA788, 0xCCA787]
			Local $return = ["Bakura", $face]
		Case $n = 17
			Local $face = [0xEEC89D, 0xE8CBA3, 0xEEBFA6, 0xE7C59A, 0xEDCAA1, 0xF6CCA3, 0xEEC5A0, 0xECC098, 0xEEC6A6]
			Local $return = ["Josh", $face]
		Case $n = 18
			Local $face = [0xA37053, 0xA97051, 0xA27050, 0xA26D4D]
			Local $return = ["Odin", $face]
		Case $n = 19
			Local $face = [0xBD9A67, 0xC19977, 0xBD9977, 0xC49970,0xBB906C,0xBB996B,0xBB966B]
			Local $return = ["Anzu", $face]
		Case $n = 99
			Local $face = [0xFF6600, 0xFF7700, 0xFF8700, 0xFF5700]
			Local $return = ["Loot", $face]
	EndSelect
	Return $return
 EndFunc   ;==>Object_color


		;Case $n = 20
		;	Local $face = [0xB2BBC3, 0xCCCFD5, 0x555599, 0x614550, 0xADB5BC, 0xCC9AAA, 0x997787, 0xFDFBB5, 0xF2E59D]
		;	Local $return = ["Yubel", $face]

Func Move($x, $y)
	$winPos = WinGetPos($title)
	MouseMove($x + $winPos[0], $y + $winPos[1],0)
EndFunc   ;==>Move

#cs
	Do a single mouse click at ($x,$y)
#ce
Func Click($x, $y)
	$winPos = WinGetPos($title)
	MouseClick($MOUSE_CLICK_LEFT, $x + $winPos[0], $y + $winPos[1], 1, 5)
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
#ce
Func get_area($mode)
	SnapShot(372, 698, 914, 745)
	Local $pos = FFBestSpot(7, 4, 9, 655 + $winPos[0], 721 + $winPos[1], 0x001AFF, 10, False)
	If Not @error Then
		;MouseMove($pos[0], $pos[1])
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
		;MsgBox(0, "Area", $area & " at " &$pos[0]&", "&$pos[1])
	Else
		Switch $mode
			Case 0
			Case 1
				Write_log("Area can't be decided.")
				Write_log("Make sure four area tab is visible.")
		EndSwitch
		Return -1
	EndIf
EndFunc   ;==>get_area

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
	wait for $color show at ($x, $y). When $time_out pass it will show error
	with $massage text
#ce
Func Wait_pixel($x, $y, $color, $time_out, $massage)
	$timer = TimerInit()
	While Compare_pixel($x, $y, $color) == 0 And (TimerDiff($timer) < $time_out)
	WEnd
	If TimerDiff($timer) >= $time_out Then
		MsgBox($MB_ICONERROR, "Error", "Timeout " & $massage)
		Exit
	EndIf
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
		MouseClick($MOUSE_CLICK_LEFT, $pos[0], $pos[1],2)
		MsgBox(0, "", $hObject[0] & " at " & $pos[0] & ", " & $pos[1] & " " & $pos[2] & " pixel detected.")
	Else
		MsgBox(0, "", "Not found")
	EndIf
	FFResetColors()
	FFResetExcludedAreas()
	Exit
EndFunc   ;==>Dbg_search
















Func card_lottery($coin)
	$massage = "Go to battle city"
	Click(650, 672)
	Wait_pixel(812, 652, 0x0A0D0C, 5000, $massage)
	Write_log($massage)
	Sleep(500)

	Click(470, 630)
	$massage = "Wait black box in Coin lottery"
	Write_log($massage)
	Wait_pixel(767, 623, 0x000000, 5000 ,$massage)
   Sleep(500)

   While Compare_pixel(801, 573, 0x4A4A46) == 0
	  Write_log("Draw")
	  While Compare_pixel(500, 132, 0x112233) == 0
		 Click(878, 585)
	  Wend
	  Sleep(300)
	  Write_log("Claim reward")
	  $coin = $coin - 300
   Wend
   Write_log("Coin depleted")
EndFunc

#cs
TAG DUEL
          _____
         |A .  | _____
         | /.\ ||A ^  | _____
         |(_._)|| / \ ||A _  | _____
         |  |  || \ / || ( ) ||A_ _ |
         |____V||  .  ||(_'_)||( v )|
                |____V||  |  || \ / |
                       |____V||  .  |
                              |____V|
#ce

Func Tag_duel()
   If On_tag_duel() Then
	  While True
		 Write_log("Tag Duel initial screen")
		 While Not has_white_dialog()
		    Write_log("Start!")
			Click(650, 520)
		    Sleep(1000)
		 WEnd

		 While Not (Compare_pixel(650, 520, 0xFFFFFF) == 1 And Compare_pixel(680, 500, 0x001133) == 1)
		    Write_log("White Dialog")
			Click(700, 660)
			Click(650, 520)
		    Sleep(1000)
		 WEnd

		 Write_log("LvL 40")
		 Click(750, 450)
		 Sleep(1000)

		 Write_log("Duel!")
		 Click(700, 653) ;
		 Sleep(3000)

		 Write_log("Starting Duel!")
		 While Not (has_white_dialog() OR On_tag_duel())
			While Not (has_white_dialog() OR On_tag_duel())
			  Click(644, 708);
			  Sleep(1000)
			  Write_log("Waiting Duel")
			WEnd
			Sleep(3000)
		 WEnd
	  WEnd
   EndIf
EndFunc

Func On_tag_duel()
   Return (Compare_pixel(400, 520, 0x091B3D) == 1 AND Compare_pixel(650, 480, 0xA5ABB6) == 1 AND Compare_pixel(650, 550, 0x0A1838) == 1)
EndFunc

#cs
Battle City

                           ,===:'.,            `-._
                                `:.`---.__         `-._
                                  `:.     `--.         `.
                                    \.        `.         `.
                            (,,(,    \.         `.   ____,-`.,
                         (,'     `/   \.   ,--.___`.'
                     ,  ,'  ,--.  `,   \.;'         `
                      `{D, {    \  :    \;
                        V,,'    /  /    //
                        j;;    /  ,' ,-//.    ,---.      ,
                        \;'   /  ,' /  _  \  /  _  \   ,'/
                              \   `'  / \  `'  / \  `.' /
                               `.___,'   `.__,'   `.__,'

Lalalalala
#ce

Func Battle_city()
   If Compare_pixel(420, 725, 0xFFFFFF) == 1 Then
	  Write_log("Already on battle city")
   Else
	  Write_log("Go to battle city")
	  Click(670, 670)
	  Click(420, 725)
	  Wait_pixel(420, 725, 0xFFFFFF, 5000, "Waiting Battle City")
	  Sleep(500)
   EndIf

   While 1
	  click_dice()
	  Sleep(500)

	  Click(700, 660)

	  If has_white_dialog() Then
		 Click(700, 660)
	  EndIf

	  If has_white_dialog() Then
		 Write_log("Start a battle")

		 $time_out = 5000
		 $timer = TimerInit()
		 While Compare_pixel(875, 520, 0x062868) == 0 And (TimerDiff($timer) < $time_out)
			Click(700, 660)
			Sleep(500)
		 WEnd

		 Write_log("Skipping dialog")
		 Click(875, 520)
		 Sleep(1000)

		 Write_log("Skipping Sirius")
		 Click(700, 660)
		 Sleep(500)
		 Click(700, 660)
		 Sleep(500)

		 Write_log("LvL 40")
		 Click(700, 400)
		 Sleep(1500)

		 Write_log("Duel!")
		 Click(700, 653) ;
		 Sleep(3000)

		 Write_log("Starting Duel!")
		 While Not (has_white_dialog() OR duel_over())
			While Not (has_white_dialog() OR duel_over())
			  Click(644, 708);
			  Sleep(1000)
			  Write_log("Waiting Duel")
			WEnd
			Sleep(3000)
		 WEnd

		 While has_white_dialog()
		   Click(700, 660)
		   Sleep(1000)
		   Write_log("Finishing Duel")
		 WEnd
	  Else
		 Write_log("Not a battle")
		 Sleep(500)
	  EndIf
   WEnd
EndFunc

Func click_dice()
   Write_log("Run dices")
   Click(720, 540)
EndFunc

Func duel_over()
   Return Compare_pixel(420, 725, 0xFFFFFF) == 1 AND Compare_pixel(800, 150, 0x001E52) == 1
EndFunc

Func has_white_dialog()
   Return Compare_pixel(700, 700, 0xFFFFFF) == 1 AND Compare_pixel(700, 750, 0xFFFFFF) == 1
EndFunc

Func divine_trial()
   $massage = "Go to battle city"
   Click(65	0, 672)
   Wait_pixel(812, 652, 0x9056D0, 5000, $massage)
   Write_log($massage)

   while 1
	  Local $massage = "Click support item"

	  Write_log($massage)
	  $time_out = 50000
	  $timer = TimerInit()
	  While Compare_pixel(639, 596, 0x052155) == 0 And (TimerDiff($timer) < $time_out)
		 Click(807, 650)
	  WEnd
	  If TimerDiff($timer) >= $time_out Then
		 $time_out = 5000
		 Write_log("Time out!")
		 Write_log("Exit in " & $time_out / 1000 & " s")
		 Sleep($time_out)
		 Exit
	  Else
		 Write_log(time_s(TimerDiff($timer)) & " s")
	  EndIf

	  $massage = "Use divine offering"
	  Write_log($massage)
	  Sleep(300)
	  Click(752, 236)

	  $massage = "Ok!"
	  Wait_pixel(630, 306, 0xFFFFFF, 5000, $massage)
	  Write_log($massage)
	  Sleep(500)
	  Click(732, 433)

	  duel()

	  $massage = "Collect Reward"
	  Wait_pixel(641, 350, 0xA65200, 5000, $massage)
	  Write_log($massage)
	  Click(639, 492)
   Wend
EndFunc