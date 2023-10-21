#include <AutoItConstants.au3>
#include <ClipBoard.au3>
#include <String.au3>
#include <FileConstants.au3>
#include <MsgBoxConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <WinAPI.au3>


;_____________________
;Change this if Required:
;_____________________

	HotKeySet("{F6}", "copyItem") 		; Price check on current ITEM
	HotKeySet("{F5}", "gotoHideout")	; Goto HO
	HotKeySet("{F11}", "ExitScript")	; Force stop script
	
	$sleeper 	= 500 							;Time to wait that google saved the docs in cloud. Can be lowered or increased to customize script , def: 500 (0,5 sec)

;_____________________



Global $searchString = '"ty":"is","ibi":1,"s":"'
Global $sUserName = @UserName
Global $sDirPath = "C:\Users\" & $sUserName & "\Documents\My Games\Path of Exile"
Global $sIniFile = $sDirPath & "\POEGFNconfig.ini"
Global $aKoordinaten = 0
Global $counter = 0 
Global $counterwindow = 300
Global $sURL = 0
Global $URLau3 = "https://github.com/KloppstockBw/GFNPoEPriceCheck/blob/main/TestScript.au3"
Global $VersionL = "20231022A"
Global $updateChecked = False
Global $WEBSITE, $UPDATE

Updater()
AutorunAwakened()
awakenedrunning()
configMaus()
ConfigURL()

While 1
	Sleep(100)
	If $counterwindow = 300 Then
    WindowRename()
    $counterwindow = 0
EndIf
  $counterwindow = $counterwindow + 1
WEnd


Func AutorunAwakened()
	If Not FileExists($sIniFile) Or IniRead($sIniFile, "AwakenedPath", "ExePath", "") = "" Then
		Local $iResponse = MsgBox($MB_YESNO, "Auto Start Awakened POE Trade", "Do you want me to start Awakened PoE Trade automatically when the script is executed?")
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
			MsgBox($MB_SYSTEMMODAL, "", "No Autostart of Awakened. If you change your mind check the config at: " & @CRLF & $sIniFile)
			IniWrite($sIniFile, "AwakenedPath", "ExePath", "You dont want to start awakened automatically. Remove this line if you changed your mind and rerun the script")
		EndIf
	EndIf

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

Func WindowRename()
While 1
    Local $hWnd = WinGetHandle("[REGEXPTITLE:(?i)(.*Path of Exile.*GeForce.*)]")
    If $hWnd <> 0 Then
        If WinSetTitle($hWnd, "", "Path of Exile") Then ExitLoop
    EndIf
    Sleep(100)
WEnd
EndFunc

Func configMaus()
	If Not FileExists($sDirPath) Then DirCreate($sDirPath)
	$sMausKoordinaten = IniRead($sIniFile, "AwakenedPasteWindow", "Koordinaten", "-1,-1")
	$aKoordinaten = StringSplit($sMausKoordinaten, ',')
	If $sMausKoordinaten = "-1,-1" Or ($aKoordinaten[1] = 0 And $aKoordinaten[2] = 0) Then
		Opt("GUIOnEventMode", 1) ;
		$Form1 = GUICreate("Path of Exile", @DesktopWidth, @DesktopHeight, 0, 0, $WS_POPUP)
		GUISetState(@SW_SHOWMAXIMIZED)
		Sleep(200)
		;Send("+{SPACE}")
		;WinActivate($Form1)
                MsgBox(0, "Show me where the Awakened PoE Trade Field is", "Now you have to show me where to put the item details in Awakened PoE Trade, unfortunately I can't read that information." & @CRLF & @CRLF & "Click with the left mouse button in the upper left corner on the input field where it says" & @CRLF & @CRLF & "Price Check (Ctrl + V)." & @CRLF & @CRLF & "It starts as soon as you click on ok.")
		WinActivate($Form1)
		Send("+{SPACE}")
    If WinActive("Awakened PoE Trade") Then
        While 1
            If _IsPressed("01") Then
                ExitLoop
            EndIf
            Sleep(20)
        WEnd
    EndIf
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

Func ConfigURL()
	If IniRead($sIniFile, "docsGoogleURL", "URL", "") <> "" And IniRead($sIniFile, "docsGoogleURL", "URL", "") <> "https://docs.google.com *** /edit" Then	
	$sURL = IniRead($sIniFile, "docsGoogleURL", "URL", "")
	Else
    $input = InputBox("docs.google URL", "Please enter your docs.google URL here"& @CRLF & @CRLF & "Please make sure that anyone can edit this document because you can't login to google in GeForce NOW. Keep the link private!", "https://docs.google.com *** /edit")
    If StringRight($input, 4) = "edit" Then IniWrite($sIniFile, "docsGoogleURL", "URL", $input)
	EndIf
	$sURL = IniRead($sIniFile, "docsGoogleURL", "URL", "")
EndFunc	



Func Updater()
    If $updateChecked Then
        Return
    EndIf
    Local $updateLater = False
    Local $hGUI
    Local $sContent2 = ""
    Local $iPID2 = Run(@ComSpec & ' /c curl -s -k "' & $URLau3 & '"', "", @SW_HIDE, $STDOUT_CHILD)
    If $iPID2 = 0 Then
        MsgBox($MB_SYSTEMMODAL, "Error", "Error starting curl.")
        Exit
    EndIf
    While 1
        $sContent2 &= StdoutRead($iPID2)
        If @error Then ExitLoop
    WEnd
    ProcessClose($iPID2)
    If StringLen($sContent2) > 0 Then
        Local $sSearchText2 = "$VersionL = "
        Local $iStartPos2 = StringInStr($sContent2, $sSearchText2)
        If $iStartPos2 > 0 Then
            $VersionG = StringMid($sContent2, $iStartPos2 + StringLen($sSearchText2), 9)
        Else
            MsgBox($MB_SYSTEMMODAL, "Error", "Text 'RelVersion:' not found.")
        EndIf
    Else
        MsgBox($MB_SYSTEMMODAL, "Error", "Error retrieving webpage content.")
    EndIf
    If $VersionL = $VersionG Then
    Else
        $updateLater = True
        $hGUI = CreateGUI()
    EndIf
    If $updateLater Then
        While 1
            $imsg = GUIGetMsg()
            Switch $imsg
                Case $GUI_EVENT_CLOSE
                    Exit
                Case $WEBSITE
                    ShellExecute("https://github.com/KloppstockBw/GFNPoEPriceCheck/")
                    Exit
                Case $UPDATE
                    ExitLoop
            EndSwitch
        WEnd
    EndIf
    GUIDelete($hGUI)
    $updateChecked = True
EndFunc

Func CreateGUI()
    Local $hGUI = GUICreate("Update Available", 400, 100)
    GUICtrlCreateLabel("There is a new version for the script on Github." & @CRLF & "Do you want to download the latest version?", 10, 10, 380, 50)
    $WEBSITE = GUICtrlCreateButton("Open Github", 50, 55, 150, 30)
    $UPDATE = GUICtrlCreateButton("Update Later", 210, 55, 150, 30)
    GUISetState()
    Return $hGUI
EndFunc

; Macros   
	
	Func ExitScript()
		Exit
	EndFunc


#cs
	Func lasty()
		If Not WinActive("Path of Exile") Then Return
		Send("^{ENTER}")
		Send($ty)
		Send("{ENTER}")
	EndFunc
#ce


	Func gotoHideout()
		If Not WinActive("Path of Exile") Then Return
		Send("{ENTER}")
		Send("/hideout")
		Send("{ENTER}")
	EndFunc

	Func copyItem()
		If Not WinActive("Path of Exile") Then Return
		$counter = $counter +1
		$sMausKoordinaten = IniRead($sIniFile, "AwakenedPasteWindow", "Koordinaten", "-1,-1")
	    $aKoordinaten = StringSplit($sMausKoordinaten, ',')
		$savedMousePos = MouseGetPos()
		Opt("SendKeyDelay", 150)
		Sleep(100)
		Send("!^c")
		Send("{F7}")
		Sleep(100)
		If $counter < 2 Then MsgBox($MB_SYSTEMMODAL, "Waiting for google.docs", "Wait until you see the docs.google document is loaded. "& @CRLF & @CRLF &"Then press OK and repeat {F6} Price check on item.")
		Sleep(80)
		If $counter < 2 Then Send("{ESC}")
		If $counter < 2 Then Return
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
		
EndFunc