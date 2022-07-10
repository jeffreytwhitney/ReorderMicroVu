#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


DetectHiddenWindows, Off
SetKeyDelay, 100

if !WinExist("InSpec")
{
	Exit
}
WinActivate
FeatureNameArray := [] 

Try 
{
	iterator := 0
	mostRecentValue:= ""
	Loop
	{
		Send, {F2}
		ControlGetText, controlTextValue, WindowsForms10.Edit.app.0.378734a_r3_ad11, ahk_exe MicroVuTestHarness.exe
		if (controlTextValue = mostRecentValue)
		{
			SendInput {Esc}
			break
		}
				
		if controlTextValue is number
		{
			newTextValue := controlTextValue + 200
			localFeatureName := new FeatureName(iterator, true, controlTextValue, newTextValue)
			FeatureNameArray.Push(localFeatureName)
			ControlSetText, WindowsForms10.Edit.app.0.378734a_r3_ad11, %newTextValue%, ahk_exe MicroVuTestHarness.exe
			SendInput {Enter}
		} 
		else
		{
			localFeatureName := new FeatureName(iterator, false, controlTextValue, controlTextValue)
			FeatureNameArray.Push(localFeatureName)
			SendInput {Esc}
		}
		mostRecentValue := controlTextValue
		iterator++
		SendInput {Down}
	}
}
catch e
{
	Exit
}

Send {Home}

Loop, %iterator%
{
    localFeatureName := FeatureNameArray[A_Index]
	if (localFeatureName.ShouldChange = true)
	{
		Send, {F2}
		ControlSetText, WindowsForms10.Edit.app.0.378734a_r3_ad11, %A_Index%, ahk_exe MicroVuTestHarness.exe
		SendInput {Enter}
	}
	SendInput {Down}
}

Send {Home}

Class FeatureName
{
    __New(index, shouldChange, originalName, newName)
    {
        this.Index := index
		this.ShouldChange := shouldChange
        this.OriginalName := originalName
        this.NewName := newName
    }
}










