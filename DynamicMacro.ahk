; DynamicMacro.ahk
; 
; 増井俊之先生のDynamic MacroのAutoHotKey実装。
; 参考：http://www.pitecan.com/DynamicMacro/
; 
; 2021/07/12	公開 by forestail
; 2021/07/15	リセット機能を改善
; 2021/07/17	ログ機能追加、キーコードをVKだけでなくSCもセットで送出するようにした
; 
; ※呼び出しホットキーのデフォルトは[Ctrl + t]になっているので、好みのものに変更してください。
; ■増井先生の論文にあって実装できていないもの
; 　・繰り返し検知が意図しないものだった場合、予測モードに切り替える機能
; ■その他
; 　・特定のエディタではなくOS全体で機能する点、AutoHotKeyの仕様による制限などを考慮し、能動的にキー履歴をクリアする機能を付けました。
; 　　デフォルトでは[ESC]に割り当てています。

#UseHook On
#KeyHistory 200
#InstallKeybdHook
global flgPredict := 0
global seqRepeat := Object()
global flgEnableLog
global strLogPath

; Import ini file.(DynamicMacro.ini)
IniRead, strInvokeHotKey, %A_ScriptDir%\DynamicMacro.ini, Main, InvokeHotKey , ^t
IniRead, strResetHotKey, %A_ScriptDir%\DynamicMacro.ini, Main, ResetHotKey , ~esc
IniRead, flgEnableLog, %A_ScriptDir%\DynamicMacro.ini, Main, EnableLog , 1
IniRead, strLogPath, %A_ScriptDir%\DynamicMacro.ini, Main, LogPath , DMlog.txt

; Set working directory to script directory.
SetWorkingDir %A_ScriptDir%

Hotkey, %strInvokeHotKey%, Execute
Hotkey, %strResetHotKey%, Reset
Return


; Reset
Reset:
	; Clear key history & seqRepeat.
	LogWrite("Reset")
	Reload
Return

; Execute
Execute:
	KeyHistory := ParseKeyHistory()
	if IsDoubledHotkey(KeyHistory) == 0
	{
		seqRepeat := []
	}

	seq := RemoveHotKey(GetHistoryArray(KeyHistory))

	if seqRepeat.MaxIndex() > 0
	{
		rep := seqRepeat
	}
	else
	{
		rep := FindRep(seq)
		seqRepeat := rep

		if rep.MaxIndex() == ""
		{
			pre := Predict(seq)
			seqPredict := pre
		}
	
		flgPredict := 0
	}

	
	if rep.MaxIndex() > 0
	{
		Send % GetMacro(rep)
		LogWrite("Repeat," . rep.MaxIndex())
	}
	else if pre["Y"].MaxIndex() > 0
	{
		Send % GetMacro(pre["Y"])
		LogWrite("Predict," . pre["Y"].MaxIndex() . "," . pre["X"].MaxIndex())
		seqRepeat := []
		for i,e in pre["X"]
		{
			seqRepeat.Insert(e)
		}
		for i,e in pre["Y"]
		{
			seqRepeat.Insert(e)
		}
	}

Return

IsDoubledHotkey(arr)
{
	if arr[arr.MaxIndex()]["Type"] == "h" || arr[arr.MaxIndex()]["Type"] == "s" || arr[arr.MaxIndex()]["Key"] == "LControl"
	{
		return IsDoubledHotkey(SubArray(arr,0,arr.MaxIndex()))
	}
	else if arr[arr.MaxIndex()]["Type"] == "i"
	{
		return 1
	}
	else
	{
		return 0
	}
}


RemoveHotKey(arr)
{
	if RegExMatch(arr[arr.MaxIndex()], "U){.+\sdown}") > 0
	{
		return RemoveHotKey(SubArray(arr,0,arr.MaxIndex()))
	}
	else
	{
		return arr
	}	
}

; Convert KeyHistory to One-dimensional array
GetHistoryArray(arr)
{
	Array := Object()
	InnerFunction := ""

	For index,element in arr
	{		
		if element["Key"] != "" && element["Type"] != "i" && element["Type"] != "h"
		{
			if element["UpDn"]
			{
				if isFunctionKey(element["Key"]) == 0
				{
					if InnerFunction != 
					{
						Array.Insert("{" . InnerFunction . " down}")
					}
					; Array.Insert("{vk" . element["VK"] . "}")
					Array.Insert("{vk" . element["VK"] . "sc" . element["SC"] . "}")

					if InnerFunction != 
					{
						Array.Insert("{" . InnerFunction . " up}")
					}
				}
				else
				{
					InnerFunction := element["Key"]
				}
			}
			else
			{
				if isFunctionKey(element["Key"]) == 1
				{
					InnerFunction := ""
				}
			}		
		}
	}
	return Array
}

isFunctionKey(key)
{
	if key in LShift,RShift,LControl,RControl,LAlt,RAlt
	{
		return 1
	}
	else
	{
		return 0
	}
}

; Find repeat Sequence
FindRep(arr)
{
	res := Object()
	buf1 := Object()
	buf2 := Object()
	len := arr.MaxIndex()
	Loop, % len // 2
	{
		i := A_Index
		buf1 := []
		buf2 := []
		Loop, % i
		{
			j := A_Index
			if j <= i
			{
				buf1.Insert(arr[len + 1 - i + j - 1])
				buf2.Insert(arr[len + 1 - i * 2 + j - 1])
			}
		}
		if ArrayCompare(buf1,buf2)
		{
			res := buf1
		}
	}
	return res
}

; Predict repeat sequence
Predict(arr)
{
	bufX := Object()
	bufY := Object()
	bufX1 := Object()
	bufX2 := Object()
	len := arr.MaxIndex()
	Loop, % len
	{
		i := A_Index
		bufX2 := SubArray(arr, len - i + 1, i)
		Loop, % len - 1
		{
			; bufX1 := SubArray(arr, len - i + 1 - i + 1 - A_Index - 1 , i)
			bufX1 := SubArray(arr, len - i * 2 + 1 - A_Index , i)
			if ArrayCompare(bufX1,bufX2)
			{
				bufX := bufX1
				; bufY := SubArray(arr, len - i + 1 - i + 1 - A_Index - 1 + i, len - i + 1 - (len - i + 1 - i + 1 - A_Index - 1 + i))
				bufY := SubArray(arr, len - i + 1 - A_Index ,   A_Index)
				Break
			}
		}
	}
	return {"X":bufX, "Y":bufY}
}

; Make send text
GetMacro(arr)
{
	buf := ""
	For index,element in arr
	{
		buf .= element
	}
	return buf
}


SubArray(arr, start, num)
{
	res := Object()
	Loop, % num
	{
		res.Insert(arr[start + A_Index - 1])
	}
	return res
}

ArrayCompare(a,b){
	if a.MaxIndex() != b.MaxIndex()
		return 0

	for index,value in a
	{
		if a[index] != b[index]
			return 0
	}
	return 1
}

LogWrite(msg)
{
	if flgEnableLog
	{
		logText = %A_YYYY%/%A_MM%/%A_DD%,%A_Hour%:%A_Min%:%A_Sec%,%msg%
		FileAppend,  %logText%`n, %strLogPath%
	}
}

; For Debug
PrintArray( arr )
{
	buf := ""
	For index,element in arr
	{
		buf .= element
		buf .= "`n"
	}
	MsgBox % buf
	return buf
}


; ; For Debug
; ^q::
; 	KeyHistory := ParseKeyHistory()
; 	seq := RemoveHotKey(GetHistoryArray(KeyHistory))
; 	PrintArray(seq)
; 	PrintArray(FindRep(seq))
;	PrintArray(seqRepeat)
; return




; ---------------------------------------------------------------
; from https://www.autohotkey.com/boards/viewtopic.php?t=9656
; ---------------------------------------------------------------
ScriptInfo(Command)
{
	static hEdit := 0, pfn, bkp
	if !hEdit {
		hEdit := DllCall("GetWindow", "ptr", A_ScriptHwnd, "uint", 5, "ptr")
		user32 := DllCall("GetModuleHandle", "str", "user32.dll", "ptr")
		pfn := [], bkp := []
		for i, fn in ["SetForegroundWindow", "ShowWindow"] {
			pfn[i] := DllCall("GetProcAddress", "ptr", user32, "astr", fn, "ptr")
			DllCall("VirtualProtect", "ptr", pfn[i], "ptr", 8, "uint", 0x40, "uint*", 0)
			bkp[i] := NumGet(pfn[i], 0, "int64")
		}
	}

	if (A_PtrSize=8) {	; Disable SetForegroundWindow and ShowWindow.
		NumPut(0x0000C300000001B8, pfn[1], 0, "int64")	; return TRUE
		NumPut(0x0000C300000001B8, pfn[2], 0, "int64")	; return TRUE
	}
	else {
		NumPut(0x0004C200000001B8, pfn[1], 0, "int64")	; return TRUE
		NumPut(0x0008C200000001B8, pfn[2], 0, "int64")	; return TRUE
	}

	static cmds := {ListLines:65406, ListVars:65407, ListHotkeys:65408, KeyHistory:65409}
	cmds[Command] ? DllCall("SendMessage", "ptr", A_ScriptHwnd, "uint", 0x111, "ptr", cmds[Command], "ptr", 0) : 0

	NumPut(bkp[1], pfn[1], 0, "int64")	; Enable SetForegroundWindow.
	NumPut(bkp[2], pfn[2], 0, "int64")	; Enable ShowWindow.

	ControlGetText, text,, ahk_id %hEdit%
	return text
}

ParseKeyHistory(KeyHistory:="",ParseStringEnumerations:=1){
	/*
	Parses the text from AutoHotkey's Key History into an associative array:
	Header:
	KeyHistory[0]	["Window"]					String
	["K-hook"]					Bool
	["M-hook"]					Bool
	["TimersEnabled"]			Int
	["TimersTotal"]				Int
	["Timers"]					String OR Array		[i] String
	["ThreadsInterrupted"]		Int
	["ThreadsPaused"]			Int
	["ThreadsTotal"]			Int
	["ThreadsLayers"]			Int
	["PrefixKey"]				Bool
	["ModifiersGetKeyState"]	|String OR Array	["LAlt"]   Bool
	["ModifiersLogical"]		|					["LCtrl"]  Bool
	["ModifiersPhysical"]		|					["LShift"] Bool
	["LWin"]   Bool
	["RAlt"]   Bool
	["RCtrl"]  Bool
	["RShift"] Bool
	["RWin"]   Bool
	Body:
	KeyHistory[i]	["VK"]		String [:xdigit:]{2}
	["SC"]		String [:xdigit:]{3}
	["Type"]	Char [ hsia#U]
	["UpDn"]	Bool (0=up 1=down)
	["Elapsed"]	Float
	["Key"]		String
	["Window"]	String
	*/


	If !(KeyHistory) && IsFunc("ScriptInfo")
	KeyHistory:=ScriptInfo("KeyHistory")

	RegExMatch(KeyHistory,"sm)(?P<Head>.*?)\s*^NOTE:.*-{109}\s*(?P<Body>.*)\s+Press \[F5] to refresh\.",KeyHistory_)
	KeyHistory:=[]

	RegExMatch(KeyHistory_Head,"Window: (.*)\s+Keybd hook: (.*)\s+Mouse hook: (.*)\s+Enabled Timers: (\d+) of (\d+) \((.*)\)\s+Interrupted threads: (.*)\s+Paused threads: (\d+) of (\d+) \((\d+) layers\)\s+Modifiers \(GetKeyState\(\) now\) = (.*)\s+Modifiers \(Hook's Logical\) = (.*)\s+Modifiers \(Hook's Physical\) = (.*)\s+Prefix key is down: (.*)",Re)

	KeyHistory[0]:={"Window": Re1, "K-hook": (Re2="yes"), "M-hook": (Re3="yes"), "TimersEnabled": Re4, "TimersTotal": Re5, "Timers": Re6, "ThreadsInterrupted": Re7, "ThreadsPaused": Re8, "ThreadsTotal": Re9, "ThreadsLayers": Re10, "ModifiersGetKeyState": Re11, "ModifiersLogical": Re12, "ModifiersPhysical": Re13, "PrefixKey": (Re14="yes")}

	If (ParseStringEnumerations){
		Loop, Parse,% "ModifiersGetKeyState,ModifiersLogical,ModifiersPhysical",CSV
		{
			i:=A_Loopfield
			k:=KeyHistory[0][i]
			KeyHistory[0][i]:={}
			Loop, Parse,% "LWin,LShift,LCtrl,LAlt,RWin,RShift,RCtrl,RAlt",CSV
			KeyHistory[0][i][A_LoopField]:=Instr(k,A_Loopfield)
		}

		k:=KeyHistory[0]["Timers"]
		KeyHistory[0]["Timers"]:=[]
		Loop, Parse,k,%A_Space%
		KeyHistory[0]["Timers"].Push(A_Loopfield)
	}

	Loop, Parse,KeyHistory_Body,`n,`r
	{
		RegExMatch(A_Loopfield,"(\w+) {2}(\w+)\t([ hsia#U])\t([du])\t(\S+)\t(\S*) *\t(.*)",Re)
		KeyHistory.Push({"VK": Re1, "SC": Re2, "Type": Re3, "UpDn": (Re4="D"), "Elapsed": Re5, "Key": Re6, "Window": Re7})
	}

	Return KeyHistory
}

hexToDecimal(str)
{
	static _0 := 0
	static _1 := 1
	static _2 := 2
	static _3 := 3
	static _4 := 4
	static _5 := 5
	static _6 := 6
	static _7 := 7
	static _8 := 8
	static _9 := 9
	static _a := 10
	static _b := 11
	static _c := 12
	static _d := 13
	static _e := 14
	static _f := 15
	;
	str := LTrim(str, "0x `t`n`r")
	len := StrLen(str)
	ret := 0
	Loop, Parse, str
	{
		ret += _%A_LoopField% * (16 ** (len - A_Index))
	}
	return ret
}
