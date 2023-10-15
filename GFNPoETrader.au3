
#include <AutoItConstants.au3>
#include <ClipBoard.au3>
#include <String.au3>
$maxWidth = @DesktopWidth
$maxHeight = @DesktopHeight
$targetX = $maxWidth * 0.1
$targetY = $maxHeight * 0.111
$searchString = '"ty":"is","ibi":1,"s":"'


	Run("C:\Users\pjw\AppData\Local\Programs\Awakened PoE Trade\Awakened PoE Trade.exe")
    Run ("C:\Users\pjw\Desktop\HP Support.lnk")
	
;_____________________
;      Change this always:
;_____________________

	$sURL = "https://docs.google.com/document/d/1pn6dicklover69HXZqHQNl5GzEGlGSPcUQRgWY2Y/edit"
	
;_____________________

;Change this if Required:
;_____________________
	HotKeySet("{F6}", "copyItem") 		; Price check on current ITEM
	HotKeySet("{F5}", "gotoHideout")	; Goto HO
	HotKeySet("{F9}", "lasty") 			; whisper ty and gl to last whispered
	HotKeySet("{F11}", "ExitScript")	; Force stop script
	
	$Counter 	= 8000							;Time to wait until docs.google loaded inside GFN the first time after hitting F7. Will be set to 0 after first price check is done, def: 8000 (8 sec)
	$sleeper 	= 500 							;Time to wait that google saved the docs in cloud. Can be lowered or increased to customize script , def: 500 (0,5 sec)
	$ty = "ty and gl"							;Text to send on hitting F9
	
;______________________
	While 1
		Sleep(100)
	WEnd
	
	Func ExitScript()
		Exit
	EndFunc

	Func lasty()
		Send("^{ENTER}")
		Send($ty)
		Send("{ENTER}")
	EndFunc

	Func gotoHideout()
		Send("{ENTER}")
		Send("/hideout")
		Send("{ENTER}")
	EndFunc

	Func copyItem()
		Opt("SendKeyDelay", 150)
		Send("!^c")
		Send("{F7}")
		Sleep(100)
		If $counter > 0 Then ToolTip("Countdown: 8 Sec",200, 200)
		Sleep($counter)
		ToolTip("")
		Send("^a")
		Send("^v")
		Send("{ESC}")
		Sleep($sleeper)
		Local $iPID = Run("curl -s -k " & $sURL, "", @SW_HIDE, $STDOUT_CHILD)
		ProcessWaitClose($iPID)
		Local $output = StdoutRead($iPID)
		ClipPut($output)
		$startPos = StringInStr($output, $searchString) + StringLen($searchString)
		$extractedText = StringMid($output, $startPos)
		$position = StringInStr($extractedText, '"},{"ty')
		$ClipboardText = StringLeft($extractedText, $position - 1)
		$clipboardText = StringReplace($clipboardText, "\u0027", "'")
		$clipboardText = StringReplace($clipboardText, "â€”", "—")
		$clipboardText = StringReplace($clipboardText, '\"', '"')
		$clipboardText = StringReplace($clipboardText, "\n", @CRLF)
		ClipPut($clipboardText)
		Send("+{SPACE}")
		MouseMove($targetX, $targetY, 0)
		MouseClick("left", $targetX, $targetY)
		Sleep(100)
		Send("^v")
		Opt("SendKeyDelay", 0)
		$counter=0
EndFunc
