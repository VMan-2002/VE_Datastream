On Error Resume Next

Dim WshShell, oExec
Set WshShell = CreateObject("WScript.Shell")

ask=msgbox("It's been a while... Please come back...", 4, "VE_Datastream")

If ask = 6 Then
	WshShell.Run("rstop.bat")
	WshShell.CurrentDirectory = WshShell.CurrentDirectory + "/../../../"
	WshShell.Exec("funkin.exe")
Else
	y=msgbox("I won't bother you anymore then...", 0, "VE_Datastream")
End If