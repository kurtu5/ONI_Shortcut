;
;   Oxygen Not Included Select Shortcut
;
;   Description:  Several keys for QOL enhancements in ONI.  

; Quick priority
;Alt + 1 - Priority 9
;Alt + 2 - Priority 8
;Alt + 3 - Priority 7
;Alt + 4 - Priority 6
;Alt + 5 - Priority 5



; Sensible overlays open building menu and overlay
;    CapsLock + 1    - Open Plumbing
;    CapsLock & 2    - Open Gases
;    CapsLock & 3    - Open Electrical
;    CapsLock & 4    - Open Logic
;    CapsLock & 4    - Open Shipping
;
; Rotate building
;    Tiltwheel left - Rotate
;
; Easy copy and deconstruct
;    Mouse Backward  - Copy selected tile
;    Mouse forward   - Deconstruct selected tile
;    Alt + Mforward  - Train AHK where Deconstruct button is
;
; Quickly copy parts to a new location.
;    Shift Click     - Copy selected tile and zoom focus to slot bookmarked with ONI Ctrl+2 command.  Use vanilla Shift-1 to go back.  
;    Alt + Click     - Remap Alt + Click to Shift Click.  Alt + Click, release Click then release Alt.

;
; Pliers Mod
;    CapsLock + x    - Use Pliers while in overlay
;    Alt + x         - Train AHK where Pliers button is

; Version: 1.1

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
;#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#IfWinActive, Oxygen Not Included
#InstallMouseHook
SetCapsLockState, AlwaysOff

;;;
;;;  Save button locations across restarts
;;;
global ConfigFile := A_ScriptDir . "\" . SubStr(A_ScriptName, 1, -4) . ".cfg"
; Create empty config
if not (FileExist(ConfigFile)) {
	FileAppend,
	(
[main]
DeconstructButton=
PliersButton=
ShippingButton=
	), % ConfigFile, utf-16 ; save your ini file asUTF-16LE
}
; Or read saved values
IniRead, temp, % ConfigFile, main, DeconstructButton
global DeconstructButton := temp == "" ? "" : {x: StrSplit(temp,",")[1], y: StrSplit(temp,",")[2]}

IniRead, temp, % ConfigFile, main, PliersButton
global PliersButton := temp == "" ? "" : {x: StrSplit(temp,",")[1], y: StrSplit(temp,",")[2]}

IniRead, temp, % ConfigFile, main, ShippingButton 
global ShippingButton := temp == "" ? "" : {x: StrSplit(temp,",")[1], y: StrSplit(temp,",")[2]}



;;;
;;;
;;;  Quick Priority
*!1::
Sleep 200
	Send {BLIND}{Alt Up}{p}{9}
	Return
*!2::
Sleep 200
	Send {BLIND}{Alt Up}{p}{8}
	Return
*!3::
Sleep 200
	Send {BLIND}{Alt Up}{p}{7}
	Return
*!4::
Sleep 200
	Send {BLIND}{Alt Up}{p}{6}
	Return
*!5::
Sleep 200
	Send {BLIND}{Alt Up}{p}{5}
	Return

;;;
;;;
;;;SetCapsLockState, AlwaysOff
	
; Open Plumbing
CapsLock & 1::
	Send 1
	Return	
1::
	CustomESC()
    Send {F6}
	Send 5
    Return
	
; Open Gases
CapsLock & 2::
	Send 2
	Return	
2::
	CustomESC()
    Send {F7}
	Send 6
    Return
	
; Open Electrical
CapsLock & 3::
	Send 3
	Return	
3::
	CustomESC()
    Send {F2}
	Send 3
    Return


; Open Logic
CapsLock & 4::
	Send 4
	Return	
4::
	BlockInput On
	CustomESC()
	Sleep 100
	Send {LShift down}
	Sleep 100
	Send {F2}
	Sleep 100
	Send {LShift up}
	Send {=}
	BlockInput Off
    Return

; Open Shipping
CapsLock & 5::
	Send 5
	Return	
5::
	if ( ShippingButton == "" ) {
		SetShippingButton()
	} else {
		BlockInput On
		CustomESC()
		Sleep 100
		Send {LShift down}
		Sleep 100
		Send {F3}
		Sleep 100
		Send {LShift up}
		Sleep 100
		MouseClick Left, ShippingButton["x"], ShippingButton["y"], 1, 0
		Sleep 100
		BlockInput Off
		Return
	}
	
!5::
	SetShippingButton()
Return

SetShippingButton() {
    UserPopupTip("Please click in the middle of the Shipping Button.  Hit Alt-CapsLock 5 to try again.")
    KeyWait, LButton, D
    MouseGetPos, X, Y
	ShippingButton := {x: X, y: Y}
	IniWrite %  X . "," . Y, % ConfigFile, main, ShippingButton
    UserPopupTip("")
}




;;;
;;;  Rotate
;;;
WheelLeft::
WheelRight::
	Send o
Return

;;;
;;; Browser_Back reassignment to Copy Build
;;;
XButton1::
Send {B}
Return

;;;
;;; Browser_Forward reassignment to Deconstruct Build
;;;
XButton2::
	if ( DeconstructButton == "" ) {
		SetDeconstructButton()
	} else {
		MouseGetPos, oldX, oldY
		Sleep 100
		MouseClick Left, DeconstructButton["x"], DeconstructButton["y"], 1, 0
		Sleep 100
		MouseMove, oldX, oldY, 0
	}
Return

!XButton2::
	SetDeconstructButton()
Return

SetDeconstructButton() {
    UserPopupTip("Please click in the middle of the Deconstruct Build button.  Hit Alt-XButton2 to try again.")
    KeyWait, LButton, D
    MouseGetPos, X, Y
	DeconstructButton := {x: X, y: Y}
			IniWrite %  X . "," . Y, % ConfigFile, main, DeconstructButton
    UserPopupTip("")
}

;;;
;;; Quickly copy parts to a new location.
;    Shift Click     - Copy selected tile and zoom focus to slot bookmarked with ONI Ctrl+2 command.  Use vanilla Shift-1 to go back.  
+LButton::
;UserPopupTip("+LButton")
;Sleep 1000
;UserPopupTip("")
Send {2}
   KeyWait, Shift
 ;  UserPopupTip("release")
;Sleep 1000
;UserPopupTip("")
Send {b}
;Sleep 1000

Return

; Remap Alt + Click to Shift Click
!LButton::
KeyWait, Alt
;UserPopupTip("shift click it")
;Sleep 1000
;UserPopupTip("")
Send {Shift down}
Sleep 50
Send {Click}
Sleep 50
Send {Shift up}

Return

;;;
;;; Shortcut for pliers while in overlay screen
;;;
Capslock & x::
	if ( PliersButton == "" ) {
		SetPliersButton()
	} else {
		MouseGetPos, oldX, oldY
		Sleep 100
		MouseClick Left, PliersButton["x"], PliersButton["y"], 1, 0
		Sleep 100
		MouseMove, oldX, oldY, 0
	}
Return

!x::
	SetPliersButton()
Return

SetPliersButton() {
    UserPopupTip("Please click in the middle of the Pliers button.  Hit Alt-x to try again.")
    KeyWait, LButton, D
    MouseGetPos, X, Y
	PliersButton := {x: X, y: Y}
		IniWrite %  X . "," . Y, % ConfigFile, main, PliersButton

    UserPopupTip("")
}










;;;
;;;  Debug Log in the same directory as the script.  Uncomment Log lines to get output.
;;;
Log(text) {
   FileAppend, %text%, ONI_ShortCut_Debuglog.txt
}
    
;;;
;;; User Prompt
;;;
UserPopupTip(text) {
    if (text != "")
        Progress, B2 FS16 ZX10 ZY10 X50 Y100 W500 CTwhite CWgrey, %text%, , , Arial Bold
    else
        Progress, Off
}
UserPopupTipTimeOut:
    SetTimer UserPopupTipTimeOut, Off
    UserPopupTip("")
    Return
    
;;;
;;;  Custom ESC to exit overlays or other menus
;;;
CustomESC() {
return
	;Progress, B2 FS16 ZX10 ZY10 X50 Y100 W500 CTwhite CWgrey, "wqweqweqweqwe", , , Arial Bold
	;UserPopupTip("clickig")
	Click, Right
	Sleep 100
	Click, Right
	;Sleep 100
	;UserPopupTip("")
}
	
;;;
;;; Force Script Reload
;;;
!r::
    
	UserPopupTip("Reloading")
	Sleep 200
	UserPopupTip("")
	Reload
Return
#IfWinActive
