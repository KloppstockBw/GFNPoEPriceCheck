;https://www.reddit.com/r/pathofexile/comments/17cktr0/awakened_poe_trade_on_geforce_now/
;by KloppstockBW
#include <AutoItConstants.au3>
#include <ClipBoard.au3>
#include <String.au3>
#include <FileConstants.au3>
#include <MsgBoxConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <WinAPI.au3>
Global $VersionL = 20231021A
Global $searchString = '"ty":"is","ibi":1,"s":"'
Global $sUserName = @UserName
Global $sDirPath = "C:\Users\" & $sUserName & "\Documents\My Games\Path of Exile"
Global $sIniFile = $sDirPath & "\POEGFNconfig.ini"
Global $Zaehler = 0
Global $aKoordinaten = 0
Global $counter = 0 
Global $counterwindow = 300


	
;_____________________
;      Change this always:
;_____________________

	$sURL = "https://docs.google.com/document/d/1pn67changemeHXZqHQNl5GzEGlGSPcUQRgWY2Y/edit"
	
;_____________________

;Change this if Required:
;_____________________

	HotKeySet("{F6}", "copyItem") 		; Price check on current ITEM
	HotKeySet("{F5}", "gotoHideout")	; Goto HO
	HotKeySet("{F9}", "lasty") 			; whisper ty and gl to last whispered
	HotKeySet("{F11}", "ExitScript")	; Force stop script
	
	$sleeper 	= 500 							;Time to wait that google saved the docs in cloud. Can be lowered or increased to customize script , def: 500 (0,5 sec)
	$ty = "ty and gl"							;Text to send on hitting F9
	
;______________________

AutorunAwakened()
awakenedrunning()
configMaus()




While 1
	Sleep(100)
  IF $counterwindow = 300 Then WindowRename()
  IF $counterwindow = 300 Then $counterwindow = 0
  $counterwindow = $counterwindow + 1
WEnd


Func AutorunAwakened()
	If Not FileExists($sIniFile) Or IniRead($sIniFile, "AwakenedPath", "ExePath", "") = "" Then
		Local $iResponse = MsgBox($MB_YESNO, "Auto Start Awakened POE Trade", "Do you want me to start awakened PoE Trade automatically?")
		If $iResponse = $IDYES Then
			Local $sFile = FileOpenDialog("Choose Awakened PoE Trade.exe", "C:\Users\pjw\AppData\Local\Programs\Awakened PoE Trade", "Awakened PoE Trade.exe (*.exe)", $FD_FILEMUSTEXIST)
			If @error Then
				MsgBox($MB_SYSTEMMODAL, "Cancel", "You will be reasked on next script start")
			Else
				IniWrite($sIniFile, "AwakenedPath", "ExePath", $sFile)
				Local $sFile = IniRead($sIniFile, "AwakenedPath", "ExePath", "")
				If StringRight($sFile, 4) = ".exe" Then Run($sFile)
			EndIf
		Else
			MsgBox($MB_SYSTEMMODAL, "", "No Autostart of Awakened. If you change your mind check the config at " & $sIniFile)
			IniWrite($sIniFile, "AwakenedPath", "ExePath", "You dont want to start awakened automatically. Remove this line if you changed your mind and rerun the script")
		EndIf
	EndIf
;auto start Awakened if available
Local $sFile = IniRead($sIniFile, "AwakenedPath", "ExePath", "")
If StringRight($sFile, 4) = ".exe" Then Run($sFile)
Sleep(200)
EndFunc

Func awakenedrunning()
	While True
		Local $awakenedrunning = "Awakened PoE Trade"
		Local $processList = ProcessList()
		For $i = 1 To $processList[0][0]
			If StringInStr($processList[$i][0], $awakenedrunning) Then Return
		Next
		MsgBox(0, "Status", "Please start 'Awakened PoE Trade' before running this script")
		Exit
	Wend
EndFunc


;Rename Window for Awakened POE Trade
Func WindowRename()
While 1
    Local $hWnd = WinGetHandle("[REGEXPTITLE:(?i)(.*Path of Exile.*GeForce.*)]")
    If $hWnd <> 0 Then
        If WinSetTitle($hWnd, "", "Path of Exile") Then ExitLoop
    EndIf
    Sleep(100)
WEnd
EndFunc

;Config Mouse setup 
Func configMaus()
	If Not FileExists($sDirPath) Then DirCreate($sDirPath)

	$sMausKoordinaten = IniRead($sIniFile, "AwakenedPasteWindow", "Koordinaten", "-1,-1")
	$aKoordinaten = StringSplit($sMausKoordinaten, ',')
	If $sMausKoordinaten = "-1,-1" Or ($aKoordinaten[1] = 0 And $aKoordinaten[2] = 0) Then
		Opt("GUIOnEventMode", 1) ;
		$Form1 = GUICreate("Path of Exile", @DesktopWidth, @DesktopHeight, 0, 0, $WS_POPUP)
		GUISetState(@SW_SHOWMAXIMIZED)
		Sleep(200)
		Send("+{SPACE}")
                MsgBox($MB_SYSTEMMODAL, "Show me where the Awakened PoE Trade Field is", "Please move the mouse curser to the position where the script should paste the item details to awakened POE Trade. Usually it's in the upper left corner and the field says: Price Check (Ctrl + V). Then hit space bar on your keyboard to save that Mouse position.")
		While Not _IsPressed("20") ; 
			Sleep(50)
		WEnd
		$aMausPosition = MouseGetPos()
		$sMausKoordinaten = $aMausPosition[0] & "," & $aMausPosition[1]
		IniWrite($sIniFile, "AwakenedPasteWindow", "Koordinaten", $sMausKoordinaten)
		GUISetState(@SW_HIDE, $Form1) 
		MsgBox($MB_SYSTEMMODAL, "Coordinates Saved", "Coodinates saved to config file at " & $sIniFile & @CRLF & "X: " & $aMausPosition[0] & @CRLF & "Y: " & $aMausPosition[1])
	EndIf

EndFunc
Func _IsPressed($sHexKey)
    Local $aResult = DllCall("user32.dll", "short", "GetAsyncKeyState", "int", '0x' & $sHexKey)
    If Not @error And BitAND($aResult[0], 0x8000) Then
        Return 1
    EndIf
    Return 0
EndFunc

; Macros   
	
	Func ExitScript()
		Exit
	EndFunc

	Func lasty()
		If Not WinActive("Path of Exile") Then Return
		Send("^{ENTER}")
		Send($ty)
		Send("{ENTER}")
	EndFunc

	Func gotoHideout()
		If Not WinActive("Path of Exile") Then Return
		Send("{ENTER}")
		Send("/hideout")
		Send("{ENTER}")
	EndFunc

	Func copyItem()
		If Not WinActive("Path of Exile") Then Return
		$sMausKoordinaten = IniRead($sIniFile, "AwakenedPasteWindow", "Koordinaten", "-1,-1")
	    $aKoordinaten = StringSplit($sMausKoordinaten, ',')
		$savedMousePos = MouseGetPos()
		Opt("SendKeyDelay", 150)
		Sleep(100)
		Send("!^c")
		Send("{F7}")
		Sleep(100)
		If $counter = 0 Then MsgBox($MB_SYSTEMMODAL, "Waiting for google.docs", "Wait until you see the docs.google file is loaded.")
		If $counter = 0 Then WinActivate("Path of Exile") 
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
		MouseMove($aKoordinaten[1],$aKoordinaten[2], 0)
		MouseClick("left", $aKoordinaten[1],$aKoordinaten[2])
		Sleep(100)
		Send("^v")
		MouseMove($savedMousePos[0], $savedMousePos[1],0)
		Opt("SendKeyDelay", 0)
		$counter=1
EndFunc
