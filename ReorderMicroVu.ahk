DetectHiddenWindows, Off
SetKeyDelay, 100

if !WinExist("InSpec")
{
	Msgbox, "Inspec is not running."
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
		ControlGetText, controlTextValue, Edit1, ahk_exe InSpec.exe
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
			ControlSetText, Edit1, %newTextValue%, ahk_exe InSpec.exe
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
		ControlSetText, Edit1, %A_Index%, ahk_exe InSpec.exe
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










