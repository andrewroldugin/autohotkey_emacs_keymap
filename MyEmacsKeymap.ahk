Process, Priority,, Realtime
;; Use Ahk2Exe v1.1.33 and later to build exe
;;
;; https://github.com/AutoHotkey/Ahk2Exe
;;
;@Ahk2Exe-UpdateManifest 1
;@Ahk2Exe-SetName         MyEmacsKeymap
;@Ahk2Exe-SetDescription  An AutoHotkey script to simulate Emacs keybindings on Windows
;@Ahk2Exe-SetCompanyName  MyEmacsKeymap
;@Ahk2Exe-SetOrigFilename MyEmacsKeymap.ahk
;@Ahk2Exe-SetMainIcon     MyEmacsKeymap.ico


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MyEmacsKeymap.ahk
;; - An AutoHotkey script to simulate Emacs keybindings on Windows
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Settings for testing
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; enable warning
;#Warn All, MsgBox
;; replace the existing process with the newly started one without prompt
;#SingleInstance force

;;--------------------------------------------------------------------------
;; Important hotkey prefix symbols
;; Help > Basic Usage and Syntax > Hotkeys
;; # -> Win
;; ! -> Alt
;; ^ -> Control
;; + -> Shift
;;--------------------------------------------------------------------------

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; General configuration
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; These settings are required for this script to work.
#InstallKeybdHook
#UseHook

;; What does this actually do?
SetKeyDelay 0

;; Just to play with non-default send modes
;SendMode Input
;SendMode Play

;; Matching behavior of the WinTitle parameter
;; 1: from the start, 2: anywhere, 3: exact match
;; or RegEx: regular expressions
SetTitleMatchMode 2

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Global variables
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; mark status. 1 = set, 0 = not set
global m_Mark := 0

;; Needed to support non english keyboard layouts
global a := "{vk41}"
global b := "{vk42}"
global c := "{vk43}"
global d := "{vk44}"
global e := "{vk45}"
global f := "{vk46}"
global g := "{vk47}"
global h := "{vk48}"
global i := "{vk49}"
global j := "{vk4A}"
global k := "{vk4B}"
global l := "{vk4C}"
global m := "{vk4D}"
global n := "{vk4E}"
global o := "{vk4F}"
global p := "{vk50}"
global q := "{vk51}"
global r := "{vk52}"
global s := "{vk53}"
global t := "{vk54}"
global u := "{vk55}"
global v := "{vk56}"
global w := "{vk57}"
global x := "{vk58}"
global y := "{vk59}"
global z := "{vk5A}"

;; Call on of the following functions in application autoexec file to ignore it
m_IgnoreClass(class) {
    GroupAdd ignored, ahk_class %class%
}
m_IgnoreExe(exe) {
    GroupAdd ignored, ahk_exe %exe%
}

#Include %A_ScriptDir%/include/autoexec.ahki

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Control functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Determines if this script should be enabled based on "ahk_class" of the
;; active window. "ahk_class" can be identified using Window Spy
;; (right-click on the AutoHotkey icon in the task bar)
m_IsEnabled() {
    Return !WinActive("ahk_group ignored")
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Prefix key processing
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; These functions just return without any processing.
;; The purpose of these functions is to make sure the hotkey is mapped to
;; the A_PriorHotkey built-in variable when the prefix key is pressed.
;; Ex) To detect whether C-x is pressed as the prefix key:
;;   if (A_PriorHotkey = "^x")
m_EnableControlCPrefix() {
    Return
}
m_EnableControlXPrefix() {
    Return
}
m_EnableControlQPrefix() {
  Return
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Emacs simulating functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Buffers and Files ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; C-x C-f
m_FindFile() {
    Send ^%o%
    global m_Mark := 0
}
;; C-x C-s
m_SaveBuffer() {
    Send ^%s%
    global m_Mark := 0
}
;; C-x C-w
m_WriteFile() {
    Send !fa
    global m_Mark := 0
}
;; C-x k
m_KillBuffer() {
    m_KillEmacs()
}
;; C-x C-c
m_KillEmacs() {
    Send !{F4}
    global m_Mark := 0
}

;; C-M-m
m_MaxMinWindow() {
  WinGetActiveTitle, title
  WinGet, maximized, MinMax, %title% 

  if (maximized)
     WinRestore, %title%
  else
     WinMaximize, %title%
}
;; Cursor Motion ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; C-f
m_ForwardChar() {
    global
    if (m_Mark) {
        Send +{Right}
    } else {
        Send {Right}
    }
}
;; C-b
m_BackwardChar() {
    global
    if (m_Mark) {
        Send +{Left}
    } else {
        Send {Left}
    }
}
;; C-n
m_NextLine() {
    global
    if (m_Mark) {
        Send +{Down}
    } else {
        Send {Down}
    }
}
;; C-p
m_PreviousLine() {
    global
    if (m_Mark) {
        Send +{Up}
    } else {
        Send {Up}
    }
}
;; M-f
m_ForwardWord() {
    global
    if (m_Mark) {
        Send ^+{Right}
    } else {
        Send ^{Right}
    }
}
;; M-b
m_BackwardWord() {
    global
    if (m_Mark) {
        Send ^+{Left}
    } else {
        Send ^{Left}
    }
}
;; M-n
m_MoreNextLines() {
    global
    if (m_Mark) {
        Loop, 5
        Send +{Down}
    } else {
        Loop, 5
        Send {Down}
    }
}
;; M-p
m_MorePreviousLines() {
    global
    if (m_Mark) {
        Loop, 5
        Send +{Up}
    } else {
        Loop, 5
        Send {Up}
    }
}
;; C-a
m_MoveBeginningOfLine() {
    global
    if (m_Mark) {
        Send +{Home}
    } else {
        Send {Home}
    }
}
;; C-e
m_MoveEndOfLine() {
    global
    if (m_Mark) {
        Send +{End}
    } else {
        Send {End}
    }
}
;; C-v
m_ScrollDown() {
    global
    if (m_Mark) {
        Send +{PgDn}
    } else {
        Send {PgDn}
    }
}
;; M-v
m_ScrollUp() {
    global
    if (m_Mark) {
        Send +{PgUp}
    } else {
        Send {PgUp}
    }
}
;; M-<
m_BeginningOfBuffer() {
    global
    if (m_Mark) {
        Send ^+{Home}
    } else {
        Send ^{Home}
    }
}
;; M->
m_EndOfBuffer() {
    global
    if (m_Mark) {
        Send ^+{End}
  } else {
      Send ^{End}
  }
}
;; Select, Delete, Copy & Paste ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; C-spc
m_SetMarkCommand() {
    m_Mark = 1
}
;; C-x h
m_MarkWholeBuffer() {
    Send ^{End}^+{Home}
    global m_Mark := 1
}
;; C-x C-p
m_MarkPage() {
    m_MarkWholeBuffer()
}
;; C-d
m_DeleteChar() {
    Send {Del}
    global m_Mark := 0
}
;; M-d
m_DeleteWord() {
    Send ^{Del}
    global m_Mark := 0
}
;; C-h
m_DeleteBackwardChar() {
    Send {BS}
    global m_Mark := 0
}
;; M-h
m_DeleteBackwardWord() {
    Send ^{BS}
    global m_Mark := 0
}
;; C-k
m_KillLine() {
    Send +{End}^{Ins}{Del}
    global m_Mark := 0
}
;; C-w
m_KillRegion() {
    Send ^%x%
    global m_Mark := 0
}
;; M-w
m_KillRingSave() {
    Send ^%c%
    global m_Mark := 0
}
;; C-y
m_Yank() {
    Send ^%v%
    global m_Mark := 0
}
;; Search ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; C-s
m_ISearchForward() {
    Send ^%f%
    global m_Mark := 0
}
;; C-r
m_ISearchBackward() {
    m_IsearchForward()
}
;; Undo and Cancel ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; C-/
m_Undo() {
    Send ^%z%
    global m_Mark := 0
}
;; C-g
m_KeyboardQuit() {
    if (m_Mark) {
      m_Mark = 0
    } else {
      Send {Esc}
    }
}

;; Input Method ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; C-x C-j
m_ToggleInputMethod() {
    Send {vkF3sc029}
    global m_Mark := 0
}
;; Others ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; C-m, C-j
m_NewLine() {
    Send {Enter}
    global m_Mark := 0
}
;; (C-o)
m_OpenLine() {
    Send {Enter}{Up}
    global m_Mark := 0
}
;; C-i
m_IndentForTabCommand() {
    Send {Tab}
    global m_Mark := 0
}
;; C-t
m_TransposeChars() {
    m_SetMarkCommand()
    m_ForwardChar()
    m_KillRegion()
    m_BackwardChar()
    m_Yank()
    m_ForwardChar()
}
;; Keys to send as they are when followed by C-q ;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; C-q C-a
;; For MS Paint
m_RawSelectAll() {
    Send ^%a%
}
;; C-q C-n
;; For Web browsers
m_RawNewWindow() {
    Send ^%n%
}
;; C-q C-p
m_RawPrintBuffer() {
    Send ^%p%
}
m_Cc() {
  return A_PriorHotkey = "^c"
}
m_Cx() {
  return A_PriorHotkey = "^x"
}
m_Cq() {
  return A_PriorHotkey = "^q"
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Keybindings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
#Include %A_ScriptDir%/include/hotkeys.ahki
#If (m_IsEnabled() && m_Cq())
^p::m_RawPrintBuffer()
^a::m_RawSelectAll()
^n::m_RawNewWindow()
#If (m_IsEnabled() && m_Cx())
h::m_MarkWholeBuffer()
k::m_KillBuffer()
u::m_Undo()
^s::m_SaveBuffer()
^w::m_WriteFile()
^p::m_MarkPage()
^f::m_FindFile()
^j::m_ToggleInputMethod()
^c::m_KillEmacs()
#If (m_IsEnabled())
^Space::m_SetMarkCommand()
^/::m_Undo()
!<::m_BeginningOfBuffer()
!>::m_EndOfBuffer()
^\::m_ToggleInputMethod()
^a::m_MoveBeginningOfLine()
^b::m_BackwardChar()
!b::m_BackwardWord()
^d::m_DeleteChar()
!d::m_DeleteWord()
^e::m_MoveEndOfLine()
^f::m_ForwardChar()
!f::m_ForwardWord()
^g::m_KeyboardQuit()
^h::m_DeleteBackwardChar()
!h::m_DeleteBackwardWord()
^!h::m_DeleteBackwardWord()
^!m::m_MaxMinWindow()
^i::Send {Tab}
^j::m_NewLine()
^k::m_KillLine()
^m::m_NewLine()
^n::m_NextLine()
!n::m_MoreNextLines()
^o::m_OpenLine()
^p::m_PreviousLine()
!p::m_MorePreviousLines()
^q::m_EnableControlQPrefix()
^r::m_ISearchBackward()
^s::m_ISearchForward()
^t::m_TransposeChars()
^v::m_ScrollDown()
!v::m_ScrollUp()
^w::m_KillRegion()
!w::m_KillRingSave()
^x::m_EnableControlXPrefix()
^y::m_Yank()
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Administration
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
#If
^!q::Suspend, Toggle
^!z::
if (m_IsEnabled()) {
    MsgBox, AutoHotkey emacs keymap is Enabled.
} else {
    MsgBox, AutoHotkey emacs keymap is Disabled.
}
Return
^!r::
RunWait %A_ScriptDir%/tools/mergeapps.bat
Reload
Return
