Option Explicit

Dim WS, FSO, ScriptDir, TargetScript, objWMI, colProcs, objProc, MyPID

Set WS = CreateObject("WScript.Shell")
Set FSO = CreateObject("Scripting.FileSystemObject")

ScriptDir = FSO.GetParentFolderName(WScript.ScriptFullName)

TargetScript = FSO.BuildPath(ScriptDir, "Surfing.start.vbs")

Set objWMI = GetObject("winmgmts:\\.\root\CIMV2")
Set colProcs = objWMI.ExecQuery("SELECT * FROM Win32_Process WHERE Name='wscript.exe'")
For Each objProc In colProcs
    If InStr(LCase(objProc.CommandLine), "surfing.delay.vbs") > 0 Then
        MyPID = objProc.ProcessId
        Exit For
    End If
Next

WScript.Sleep 10000

WS.Run """" & TargetScript & """", 0, False

If Not IsEmpty(MyPID) Then
    On Error Resume Next
    objWMI.Get("Win32_Process.Handle='" & MyPID & "'").Terminate
    On Error GoTo 0
End If

Set colProcs = Nothing
Set objWMI = Nothing
Set WS = Nothing
Set FSO = Nothing

WScript.Quit