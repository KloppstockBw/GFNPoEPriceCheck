; Hope you enjoy using my script
; Please note that i'm a hobby programmer 
; If you have questions or find bugs you can leave a comment on reddit or write an issue on github
; https://www.reddit.com/r/pathofexile/comments/17cktr0/awakened_poe_trade_on_geforce_now/
; https://github.com/KloppstockBw/GFNPoEPriceCheck

Opt("TrayMenuMode", 3)
Opt("TrayOnEventMode", 1)
#include <AutoItConstants.au3>
#include <ClipBoard.au3>
#include <String.au3>
#include <FileConstants.au3>
#include <MsgBoxConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <WinAPI.au3>
#include <TrayConstants.au3>
#include <Inet.au3>
Global $searchString = '"ty":"is","ibi":1,"s":"'
Global $sUserName = @UserName
Global $sDirPath = "C:\Users\" & $sUserName & "\Documents\My Games\Path of Exile"
Global $sIniFile = $sDirPath & "\POEGFNconfig.ini"
Global $aKoordinaten = 0
Global $counter = 0 
Global $counterwindow = 300
Global $sURL = 0
Global $URLau3 = "https://github.com/KloppstockBw/GFNPoEPriceCheck/blob/main/GFNPoEPriceCheck.au3"
Global $VersionL = "20231201AA"
Global $updateChecked = False
Global $WEBSITE, $UPDATE
Global $ty = "thanks and good luck"
Global $HotKey1 = ""
Global $HotKey2 = ""
Global $HotKey3 = ""
Global $HotKey4 = ""
Global $HotKey5 = ""
If Not FileExists($sDirPath) Then DirCreate($sDirPath)
If Not FileExists($sDirPath & "\GFNPoEPriceCheck.ico")Then InetGet("https://raw.githubusercontent.com/KloppstockBw/GFNPoEPriceCheck/main/favicon.ico", $sDirPath & "\GFNPoEPriceCheck.ico", $INET_FORCERELOAD)

$trayItem = TrayCreateItem("Change Hotkeys")
TrayItemSetOnEvent($trayItem, "ChangeHotkeys")
$trayItem = TrayCreateItem("Reset Config")
TrayItemSetOnEvent($trayItem, "ResetConfig")
$trayItem = TrayCreateItem("Exit")
TrayItemSetOnEvent($trayItem, "ExitScript")
TraySetIcon($sDirPath & "\GFNPoEPriceCheck.ico")

LoadHotkeysFromIni()
Updater()
AutorunAwakened()
awakenedrunning()
configMaus()
ConfigURL()
Setup()

While 1
Sleep(100)
If $counterwindow = 300 Then
WindowRename()
$counterwindow = 0
EndIf
 $counterwindow += 1
WEnd

Func LoadHotkeysFromIni()
    $HotKey1 = IniRead($sIniFile, "HotKey", "Key1", "{F7}")
    HotKeySet($HotKey1, "HotKeyPressed1")
    $HotKey2 = IniRead($sIniFile, "HotKey", "Key2", "{F6}")
    HotKeySet($HotKey2, "copyItem")
    $HotKey3 = IniRead($sIniFile, "HotKey", "Key3", "{F5}")
    HotKeySet($HotKey3, "gotoHideout")
    $HotKey4 = IniRead($sIniFile, "HotKey", "Key4", "{F9}")
    HotKeySet($HotKey4, "lasty")
    $HotKey5 = IniRead($sIniFile, "HotKey", "Key5", "{F11}")
    HotKeySet($HotKey5, "ExitScript")
	Local $Check = IniRead($sIniFile, "HotKey", "Key1", "")
If $Check = "" Then ChangeHotkeys()
EndFunc

Func ChangeHotkeys()
    Local $msg = MsgBox(4, "GFNPoEPriceCheck - HotKey", "Do you want to change the default script Hotkeys?"& @CRLF & @CRLF & "You can change it anytime by right clicking the tray icon")

	If $msg = 6 Then
        Local $gui = GUICreate("GFNPoEPriceCheck - HotKey", 300, 440)
		GUISetIcon($sDirPath & "\GFNPoEPriceCheck.ico", -58, $gui)
        GUICtrlSetFont(-1, 16, 800, 0, "Calibri", 5)
   Local $combo1 = GUICtrlCreateCombo("", 10, 100, 260, 20)
   GUICtrlCreateLabel("Choose the hotkey you would like to use", 10, 10)
GUICtrlCreateLabel("Currently only functions buttons are usable", 10, 30)
GUICtrlCreateLabel("You can change again by right-click on the icon in the tray", 10, 50)
GUICtrlCreateLabel("Open Steam Overlay (needs to be set in steam ingame):", 10, 75)
GUICtrlSetData($combo1, "{F1}|{F2}|{F3}|{F4}|{F5}|{F6}|{F7}|{F8}|{F9}|{F10}|{F11}|{F12}", $HotKey1)
Local $combo2 = GUICtrlCreateCombo("", 10, 160, 260, 20)
GUICtrlCreateLabel("Price Check in GFN:", 10, 135)
GUICtrlSetData($combo2, "{F1}|{F2}|{F3}|{F4}|{F5}|{F6}|{F7}|{F8}|{F9}|{F10}|{F11}|{F12}", $HotKey2)
Local $combo3 = GUICtrlCreateCombo("", 10, 220, 260, 20)
GUICtrlCreateLabel("Go to Hideout:", 10, 195)
GUICtrlSetData($combo3, "{F1}|{F2}|{F3}|{F4}|{F5}|{F6}|{F7}|{F8}|{F9}|{F10}|{F11}|{F12}", $HotKey3)
Local $combo4 = GUICtrlCreateCombo("", 10, 280, 260, 20)
GUICtrlCreateLabel("Local Chat Thanks:", 10, 255)
GUICtrlSetData($combo4, "{F1}|{F2}|{F3}|{F4}|{F5}|{F6}|{F7}|{F8}|{F9}|{F10}|{F11}|{F12}", $HotKey4)
Local $combo5 = GUICtrlCreateCombo("", 10, 340, 260, 20)
GUICtrlCreateLabel("Force Close this macro:", 10, 315)
GUICtrlSetData($combo5, "{F1}|{F2}|{F3}|{F4}|{F5}|{F6}|{F7}|{F8}|{F9}|{F10}|{F11}|{F12}", $HotKey5)
Local $saveButton = GUICtrlCreateButton("Save", 40, 380, 90, 30)
Local $cancelButton = GUICtrlCreateButton("Default", 170, 380, 90, 30)
        GUISetState(@SW_SHOW, $gui)
        While 1
            Switch GUIGetMsg()
                Case $GUI_EVENT_CLOSE
                    ExitLoop
                Case $cancelButton
                    $HotKey1 = "{F7}"
                    $HotKey2 = "{F6}"
                    $HotKey3 = "{F5}"
                    $HotKey4 = "{F9}"
                    $HotKey5 = "{F11}"
                    UpdateHotkeys()
                    MsgBox(0, "Info", "The default hotkeys have been saved!")
					MsgBox(0, "You are ready to go!", "Setup is done and you can start playing now!" & @CRLF & @CRLF & "Press in PoE GFN the Hotkey:" & @CRLF & @CRLF & $HotKey3 & " - go to hideout " & @CRLF & $HotKey2 & " - price check of item" & @CRLF & $HotKey4 & " - write " & $ty & " in local chat" & @CRLF & $HotKey5 & " - Force Close script" & @CRLF & @CRLF & "If you face any issues then please delete the config file at or right-click the tray icon:" & @CRLF & $sIniFile)
                    ExitLoop
                Case $saveButton
                    $HotKey1 = GUICtrlRead($combo1)
                    $HotKey2 = GUICtrlRead($combo2)
                    $HotKey3 = GUICtrlRead($combo3)
                    $HotKey4 = GUICtrlRead($combo4)
                    $HotKey5 = GUICtrlRead($combo5)
					MsgBox(0, "You are ready to go!", "Setup is done and you can start playing now!" & @CRLF & @CRLF & "Press in PoE GFN the Hotkey:" & @CRLF & @CRLF & $HotKey3 & " - go to hideout " & @CRLF & $HotKey2 & " - price check of item" & @CRLF & $HotKey4 & " - write " & $ty & " in local chat" & @CRLF & $HotKey5 & " - Force Close script" & @CRLF & @CRLF & "If you face any issues then please delete the config file at or right-click the tray icon:" & @CRLF & $sIniFile)
                    UpdateHotkeys()
                    MsgBox(0, "Info", "The hotkeys have been saved!")
                    ExitLoop
            EndSwitch
        WEnd
        GUIDelete($gui)
    Else
        UpdateHotkeys()
    EndIf
EndFunc

Func UpdateHotkeys()
    HotKeySet($HotKey1, "HotKeyPressed1")
    HotKeySet($HotKey2, "HotKeyPressed2")
    HotKeySet($HotKey3, "HotKeyPressed3")
    HotKeySet($HotKey4, "HotKeyPressed4")
    HotKeySet($HotKey5, "HotKeyPressed5")
	iniWrite($sIniFile, "HotKey", "Key1", $HotKey1)
    IniWrite($sIniFile, "HotKey", "Key2", $HotKey2)
    IniWrite($sIniFile, "HotKey", "Key3", $HotKey3)
    IniWrite($sIniFile, "HotKey", "Key4", $HotKey4)
	IniWrite($sIniFile, "HotKey", "Key5", $HotKey5)
	LoadHotkeysFromIni()
EndFunc

Func Setup()
Local $SetupStatus = 0
If IniRead($sIniFile, "Setup Done", "Status", $SetupStatus) = 1 Then
Return
Else
MsgBox(48, "You are ready to go!", "Setup is done and you can start playing now!" & @CRLF & @CRLF & "Press in PoE GFN the Hotkey:" & @CRLF & @CRLF & $HotKey3 & " - go to hideout " & @CRLF & $HotKey2 & " - price check of item" & @CRLF & $HotKey4 & " - write " & $ty & " in local chat" & @CRLF & $HotKey5 & " - Force Close script" & @CRLF & @CRLF & "If you face any issues then please delete the config file at or right-click the tray icon:" & @CRLF & $sIniFile)
IniWrite($sIniFile, "Setup Done", "Status", 1)
EndIf
EndFunc	

Func AutorunAwakened()
	If Not FileExists($sIniFile) Or IniRead($sIniFile, "AwakenedPath", "ExePath", "") = "" Then
		Local $iResponse = MsgBox($MB_YESNO, "Auto Start Awakened POE Trade", "Do you want me to start Awakened PoE Trade automatically when the script is executed?")
		If $iResponse = $IDYES Then
			Local $sFile = FileOpenDialog("Choose Awakened PoE Trade.exe", "C:\Users\" & $sUserName & "\AppData\Local\Programs\Awakened PoE Trade", "Awakened PoE Trade.exe (*.exe)", $FD_FILEMUSTEXIST)
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
    Local $hWnd = WinGetHandle("[REGEXPTITLE:(?i)(.*Path of Exile.*GeForce.*)]")
	If $hWnd <> 0 Then WinSetTitle($hWnd, "", "Path of Exile")
	Local $hWnd = WinGetHandle("[REGEXPTITLE:(?i)(.*GeForce.*Path of Exile.*)]")
    If $hWnd <> 0 Then WinSetTitle($hWnd, "", "Path of Exile")
    Sleep(100)
EndFunc

Func configMaus()
	$sMausKoordinaten = IniRead($sIniFile, "AwakenedPasteWindow", "Koordinaten", "")
	If $sMausKoordinaten = 0 Then
		Opt("GUIOnEventMode", 1)
		$Form1 = GUICreate("Path of Exile", @DesktopWidth, @DesktopHeight, 0, 0, $WS_POPUP)
		GUISetState(@SW_SHOWMAXIMIZED)
		Sleep(200)
		MsgBox(0, "Show me where the Awakened PoE Trade Field is", "Now you have to show me where to put the item details in Awakened PoE Trade, unfortunately I can't read that information." & @CRLF & @CRLF & "Click with the left mouse button in the upper left corner on the input field where it says" & @CRLF & @CRLF & "Price Check (Ctrl + V)." & @CRLF & @CRLF & "It starts as soon as you click on ok.")
		WinActivate($Form1)
		Sleep(50)
		Send("+{SPACE}")
		Sleep(500)
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
		MsgBox($MB_SYSTEMMODAL, "Coordinates Saved", "Coordinates saved to config file at " & $sIniFile & @CRLF & "X: " & $aMausPosition[0] & @CRLF & "Y: " & $aMausPosition[1])
	EndIf
	Sleep(500)	
Global $sMausKoordinaten = StringSplit(( IniRead($sIniFile, "AwakenedPasteWindow", "Koordinaten", "-1,-1")), ',')
EndFunc


Func _IsPressed($sHexKey)
    Local $aResult = DllCall("user32.dll", "short", "GetAsyncKeyState", "int", '0x' & $sHexKey)
    If Not @error And BitAND($aResult[0], 0x8000) Then
        Return 1
    EndIf
    Return 0
EndFunc

Func ConfigURL()
    Local $sURL = IniRead($sIniFile, "docsGoogleURL", "URL", "")
    While $sURL = "" Or $sURL = "https://docs.google.com *** /edit"
        $input = InputBox("docs.google URL", "Please enter your docs.google URL here" & @CRLF & @CRLF & "Please make sure that anyone can edit this document because you can't log in to Google in GeForce NOW. Keep the link private!", "https://docs.google.com *** /edit")
        If @error = 1 Then 
			MsgBox(16, "Missing URL input", "You must enter a valid URL. Script will close now!")
            Exit 
        ElseIf StringRight($input, 4) = "edit" Then
            IniWrite($sIniFile, "docsGoogleURL", "URL", $input)
            $sURL = $input
        EndIf
    WEnd
	Sleep(500)
	Global $sURL = IniRead($sIniFile, "docsGoogleURL", "URL", "")
EndFunc

Func Updater()
    If $updateChecked Then Return
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
        Local $sSearchText2 = '$VersionL = \"'
        Local $iStartPos2 = StringInStr($sContent2, $sSearchText2)
        If $iStartPos2 > 0 Then
            $VersionG = StringMid($sContent2, $iStartPos2 + StringLen($sSearchText2), 9)
        Else
            MsgBox($MB_SYSTEMMODAL, "Error", "Text 'RelVersion:' not found.")
        EndIf
    Else
        MsgBox($MB_SYSTEMMODAL, "Error", "Error retrieving webpage content.")
    EndIf
	$VersionL = StringTrimRight($VersionL, 1)
    If $VersionL = $VersionG Then
    Else
        $updateLater = True
        $hGUI = CreateGUI()
		GUISetIcon($sDirPath & "\GFNPoEPriceCheck.ico", -58, $hGUI)
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

Func CreateGUI() ; FUNKTION INTEGIEREN?
    Local $hGUI = GUICreate("Update Available", 400, 100)
    GUICtrlCreateLabel("There is a new version for the script on Github." & @CRLF & "Do you want to download the latest version?", 10, 10, 380, 50)
    $WEBSITE = GUICtrlCreateButton("Open Github", 50, 55, 150, 30)
    $UPDATE = GUICtrlCreateButton("Update Later", 210, 55, 150, 30)
    GUISetState()
    Return $hGUI
EndFunc

Func ResetConfig()

If FileExists($sIniFile) Then
    $confirmation = MsgBox(36, "Confirmation", "Are you sure you want to delete the config file?", 0)
    If $confirmation = 6 Then ; User clicked "Yes"
        If FileDelete($sIniFile) Then
            MsgBox(64, "Success", "Config file has been deleted successfully. Script will stop now.")
			Exit
        Else
            MsgBox(16, "Error", "Error deleting the INI file.")
        EndIf
    Else ; User clicked "No"
        MsgBox(48, "Canceled", "Deletion of INI file canceled.")
    EndIf
Else
    MsgBox(48, "Warning", "INI file does not exist.")
EndIf
EndFunc

; Macros   
	
	Func ExitScript()
		Exit
	EndFunc

	Func lasty()
		If Not WinActive("Path of Exile") Then Return
		Send("^{ENTER}")
		Send("^a")
		Sleep(20)
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
		$savedMousePos = MouseGetPos()
		Opt("SendKeyDelay", 150)
		Sleep(50)
		Send("!^c")
		Sleep(150)
		Send($HotKey1)
		Sleep(150)
		If $counter < 1 Then 
		MsgBox($MB_SYSTEMMODAL, "Waiting for google.docs", "Wait until you see the docs.google document is loaded. "& @CRLF & @CRLF &"Then press OK and repeat"& $HotKey2&" Price check on item.")
		Sleep(80)
		Send("{ESC}")
		$counter += 1
		Return
		EndIf
		Send("^a")
		Send("^v")
		Send("{ESC}")
		Local $i = 0
		While 1
		Sleep(50)
		Local $iPID = Run("curl -s -k " & $sURL, "", @SW_HIDE, $STDOUT_CHILD)
		ProcessWaitClose($iPID)
		Local $output = StdoutRead($iPID)
		$startPos = StringInStr($output, $searchString) + StringLen($searchString)
		$extractedText = StringMid($output, $startPos)
		$position = StringInStr($extractedText, '"},{"ty')
		$ClipboardText = StringLeft($extractedText, $position - 1)
		$clipboardText = StringReplace(StringReplace(StringReplace(StringReplace($ClipboardText, "\u0027", "'"), "â€”", "—"), '\"', '"'), "\n", @CRLF)
                $clipboardText = StringRegExpReplace($clipboardText, 'вЂ”', '-')
		$clipboardText = StringRegExpReplace($clipboardText, '\s+$', '')
		ClipPut($clipboardText & @CRLF)
		If StringLeft($clipboardText, 4) = "ITEM" Then ExitLoop
		$i += 1
		If $i >= 30 Then
        MsgBox(16, "Fehler", "Item Copy failed from docs.google!"& @CRLF &" Is this the correct docs.google site and anyone can write in it?: "& $sURL & @CRLF & @CRLF &"If yes, please contact KloppstockBW via github or reddit")
        Return
		EndIf
		WEnd
		Send("+{SPACE}")
		MouseMove($sMausKoordinaten[1],$sMausKoordinaten[2], 0)
		MouseClick("left", $sMausKoordinaten[1],$sMausKoordinaten[2])
		Sleep(50)
		Send("^v")
		MouseMove($savedMousePos[0], $savedMousePos[1],0)
		Opt("SendKeyDelay", 0)
	EndFunc
