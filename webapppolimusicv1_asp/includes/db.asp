<%
' PoliMusic uses the SQL Server database supplied in BDD_PoliMusic.sql.
Const adCmdText = 1
Const adParamInput = 1
Const adInteger = 3
Const adVarChar = 200

Function OpenDb()
    Dim cn
    Set cn = Server.CreateObject("ADODB.Connection")
    cn.Open "Provider=SQLOLEDB;Data Source=localhost;Initial Catalog=BDD_PoliMusic;User ID=usr_polimusic;Password=Politecnica1;"
    Set OpenDb = cn
End Function

Function NewCommand(cn, statement)
    Dim cmd
    Set cmd = Server.CreateObject("ADODB.Command")
    Set cmd.ActiveConnection = cn
    cmd.CommandType = adCmdText
    cmd.CommandText = statement
    Set NewCommand = cmd
End Function

Sub AddText(cmd, val, maxLength)
    cmd.Parameters.Append cmd.CreateParameter("", adVarChar, adParamInput, maxLength, CStr(val))
End Sub

Sub AddNumber(cmd, val)
    cmd.Parameters.Append cmd.CreateParameter("", adInteger, adParamInput, 4, CLng(val))
End Sub

Function ValidId(val)
    ValidId = False
    If IsNumeric(val) Then
        If CLng(val) > 0 And CLng(val) < 2147483647 Then ValidId = True
    End If
End Function
%>
