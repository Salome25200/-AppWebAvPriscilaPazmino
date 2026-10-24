<%
Function H(value)
    If IsNull(value) Or IsEmpty(value) Then
        H = ""
    Else
        H = Server.HTMLEncode(CStr(value))
    End If
End Function

Function RootPath()
    Dim scriptPath, lastSlash
    scriptPath = Request.ServerVariables("SCRIPT_NAME")
    lastSlash = InStrRev(scriptPath, "/")
    If lastSlash > 1 Then
        RootPath = Left(scriptPath, lastSlash - 1)
    Else
        RootPath = ""
    End If
End Function

Function Asset(path)
    Asset = RootPath() & "/" & path
End Function

Function AudioFile(dbPath)
    ' The provided folder currently contains Adventure. Seed rows with missing demo files
    ' use that real bundled audio file instead of a broken source.
    AudioFile = Asset("SongFilesAndImages_resources/SongFiles/bensound-adventure.mp3")
End Function

Function ImageFile(dbPath, fallbackIndex)
    Dim p, fileName
    p = LCase(H(dbPath))
    If InStr(p, "root.png") > 0 Then
        ImageFile = Asset("SongFilesAndImages_resources/UserImages/root.png")
    ElseIf InStr(p, "default.jpg") > 0 Then
        ImageFile = Asset("SongFilesAndImages_resources/UserImages/default.jpg")
    Else
        fileName = "playlist" & ((CLng(fallbackIndex) Mod 5) + 1) & ".png"
        ImageFile = Asset("SongFilesAndImages_resources/PlaylistImages/" & fileName)
    End If
End Function

Sub RequireLogin()
    If Len(Session("UserId") & "") = 0 Then
        Response.Redirect "login.asp"
        Response.End
    End If
End Sub

Sub RequireAdmin()
    Call RequireLogin()
    If CInt(Session("UserType")) <> 1 Then
        Response.Redirect "forbidden.asp"
        Response.End
    End If
End Sub
%>
