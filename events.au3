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
			Local $pixels[6][3] = [[696, 571, 0x083281], [593, 570, 0x08317D], [616, 572, 0xFFFFFF], [662, 569, 0xFFFFFF], [747, 478, 0x112233], [518, 327, 0x112233]]

			If Compare_pixels($pixels) Then
				Write_log("Close dialog")
				Click(650, 570) ;close
			Else
				Write_log("Start!")
				Click(650, 520)
			EndIf
		    Sleep(1000)
		 WEnd

		 Skip_dialog()

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

		 Write_log("Duel is over!")
		 Skip_dialog()
		 Sleep(2000)
	  WEnd
	Else
		Write_log("Please open Tag Duel")
   EndIf
EndFunc

Func On_tag_duel()
	Local $pixels[5][3] = [[400, 520, 0x030914], [462, 654, 0xFC5555], [402, 617, 0xBCBCC5], [769, 117, 0xBDBAC4], [674, 119, 0xC50000]]

	Return Compare_pixels($pixels)
EndFunc

Func Skip_dialog()
	While has_white_dialog()
		Write_log("White Dialog")

		Local $pixels[5][3] = [[904, 522, 0x072C71], [884, 527, 0xFEFEFF], [874, 531, 0x093991], [889, 525, 0xFFFFFF], [895, 525, 0xFFFFFF]]

		If Compare_pixels($pixels) Then
			Write_log("Skipping Dialog")
			Click(904, 522)
		Else
			Click(700, 660)
			Click(650, 520)
		EndIf

		Sleep(1000)
	WEnd
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

Func click_dice()
   Write_log("Run dices")
   Click(720, 540)
EndFunc

Func divine_trial()
   $massage = "Go to battle city"
   Click(650, 672)
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

	  letsDuel()

	  $massage = "Collect Reward"
	  Wait_pixel(641, 350, 0xA65200, 5000, $massage)
	  Write_log($massage)
	  Click(639, 492)
   Wend
EndFunc