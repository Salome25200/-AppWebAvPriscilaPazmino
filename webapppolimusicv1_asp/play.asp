<!--#include file="includes/db.asp"-->
<!--#include file="includes/auth.asp"-->
<%
Response.Buffer = True
Response.ContentType = "application/json"
Call RequireLogin()
If ValidId(Request.QueryString("id")) Then
    On Error Resume Next
    Dim cn, cmd
    Set cn = OpenDb()
    Set cmd = NewCommand(cn, "UPDATE TBL_SONG SET PLAYS = ISNULL(PLAYS, 0) + 1 WHERE ID_SONG = ?")
    Call AddNumber(cmd, Request.QueryString("id"))
    cmd.Execute
    If Err.Number = 0 Then
        Response.Write "{""ok"":true}"
    Else
        Response.Write "{""ok"":false}"
    End If
    On Error GoTo 0
Else
    Response.Status = "400 Bad Request"
    Response.Write "{""ok"":false}"
End If
%>
