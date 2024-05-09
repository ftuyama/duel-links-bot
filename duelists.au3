#cs
Get list of dueslists from $world(0 for Yu-Gi-Oh and 1 for
	Yu-Gi-Oh GX) starting from $start_area
#ce
Func Get_duelists($world)
	Select
		Case $world = 0
			Local $duelist = [1, 2, 3, 6, 7, 8, 13, 14, 15, 16, 17, 18, 19]
			Write_log("Yu-Gi-Oh World selected")
		Case $world = 1
			Local $duelist = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13]
			Write_log("Yu-Gi-Oh Gx World selected")
		Case $world = 4
			Local $duelist = [1, 2, 6, 7, 8, 13, 14, 15, 16, 17, 18, 19, 23, 24, 25, 26, 27, 28]
			Write_log("Yu-Gi-Oh ARCV selected")
		Case $world = 5
			Local $duelist = [2, 6, 7, 14, 15, 18, 19, 29]
			Write_log("Yu-Gi-Oh Vrains selected")
		Case $world = 7
			Local $duelist = [2, 3, 6, 7, 8, 13, 14, 15, 16, 17, 18, 22]
			Write_log("Yu-Gi-Oh Seven selected")
		Case Else
			Local $duelist = [1, 2, 3, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19]
			Write_log("Not implemented, but let's try")
	EndSelect

	Return $duelist
EndFunc   ;==>Street_duel

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
		Case $n = 20
			Local $face = [0xBBE089, 0xF7FFE3, 0xBFDD8C, 0xEFDDBC,0xF2E3CF,0xFEFEFA,0x81A153, 0xD4AF9A]
			Local $return = ["Roa", $face]
		Case $n = 21
			Local $face = [0xF0EEA8, 0xFBFBE1, 0x1EAC9D, 0xFFFF8D, 0xF1EEDC,0xBBAB54,0xF2F2AA,0xF4F1AA, 0x121313]
			Local $return = ["Celestia", $face]
		Case $n = 22
			Local $face = [0x6EB1DA, 0x73CDD7, 0x73CCCD, 0x142429,0x74CDCC,0x77CCD6]
			Local $return = ["Nail", $face]
		Case $n = 23
			Local $face = [0x336944, 0x48BF72, 0xEECCAA, 0xB56533,0x74B6CE]
			Local $return = ["Yuya", $face]
		Case $n = 24
			Local $face = [0xC66A59, 0xD55151, 0xE5DDBB, 0xBB4444,0xC4B3AA]
			Local $return = ["Dennis Event", $face]
		Case $n = 25
			Local $face = [0xEED0BB, 0x2A0B0B, 0x4D6FA8, 0x2C4466]
			Local $return = ["Emmeline", $face]
		Case $n = 26
			Local $face = [0x873533, 0xE3BB99, 0x3B4647, 0x8F979A,0xCF8B7A]
			Local $return = ["Gong Strong", $face]
		Case $n = 27
			Local $face = [0x55472D,0xD7C3B5,0x34476E,0x8D8585,0x574C34,0x89794E]
			Local $return = ["Margareth", $face]
		Case $n = 28
			Local $face = [0x294295,0x2A4495,0x6EA89E,0x599BDF,0x142135]
			Local $return = ["Yuto Event", $face]
		Case $n = 28
			Local $face = [0xDDB596,0x558894,0x2B4752,0x222C3C,0x812B33,0x725E4B,0xCEBBAA,0x33445D]
			Local $return = ["Shay", $face]
		Case $n = 29
			Local $face = [0x7FC25E,0xC7C7C8,0xDEBD57,0xE5426B,0x453E3D,0xEECCB4,0x23889F]
			Local $return = ["Bravo", $face]
		Case $n = 99
			Local $face = [0xFF6600, 0xFF7700, 0xFF8700, 0xFF5700]
			Local $return = ["Loot", $face]
	EndSelect
	Return $return
 EndFunc   ;==>Object_color