<!--#include file="includes/db.asp"-->
<!--#include file="includes/auth.asp"-->
<%
Response.Buffer = True
Dim loginError, enteredUser, enteredPassword, cn, cmd, rs
loginError = ""
enteredUser = Trim(Request.Form("username") & "")
enteredPassword = Request.Form("password") & ""

If Request.ServerVariables("REQUEST_METHOD") = "POST" Then
    If Len(enteredUser) = 0 Or Len(enteredPassword) = 0 Then
        loginError = "Escribe tu usuario y contraseña para ingresar."
    Else
        On Error Resume Next
        Set cn = OpenDb()
        If Err.Number <> 0 Then
            loginError = "No se pudo conectar con la biblioteca. Verifica que SQL Server y BDD_PoliMusic estén disponibles."
            Err.Clear
        Else
            Set cmd = NewCommand(cn, "SELECT ID_USER, USERNAME, USER_PHOTO, USER_TYPE FROM TBL_USER WHERE USERNAME = ? AND PASSWORD = ?")
            Call AddText(cmd, enteredUser, 50)
            Call AddText(cmd, enteredPassword, 50)
            Set rs = cmd.Execute()
            If Err.Number <> 0 Then
                loginError = "No se pudo validar la sesión. Inténtalo nuevamente."
                Err.Clear
            ElseIf rs.EOF Then
                loginError = "Usuario o contraseña no válidos."
            Else
                Session("UserId") = rs("ID_USER")
                Session("Username") = rs("USERNAME")
                Session("UserPhoto") = rs("USER_PHOTO")
                Session("UserType") = rs("USER_TYPE")
                Response.Redirect "index.asp"
                Response.End
            End If
        End If
        On Error GoTo 0
    End If
End If
%>
<!doctype html>
<html lang="es">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="color-scheme" content="dark">
  <title>Ingresar — PoliMusic</title>
  <link rel="icon" type="image/svg+xml" href="<%=Asset("assets/favicon.svg")%>">
  <link rel="stylesheet" href="<%=Asset("assets/vendor/bootstrap.min.css")%>?v=5.3.8">
  <link rel="stylesheet" href="<%=Asset("assets/styles.css")%>?v=20261024-3">
</head>
<body class="login-body">
  <main class="login-card" aria-labelledby="login-title">
    <a class="brand" href="login.asp" aria-label="PoliMusic"><span class="brand-mark">P</span><span>POLI<span class="brand-accent">MUSIC</span></span></a>
    <h1 id="login-title">Tu música,<br>en una sola señal.</h1>
    <p>Ingresa a tu biblioteca y reproduce lo que te mueve.</p>
<% If Len(loginError) > 0 Then %>
    <div class="notice error" role="alert"><span aria-hidden="true">!</span><%=H(loginError)%></div>
<% End If %>
    <form class="login-form" method="post" action="login.asp" novalidate data-busy-form>
      <div class="field">
        <label for="username">Usuario</label>
        <input id="username" name="username" type="text" value="<%=H(enteredUser)%>" maxlength="50" autocomplete="username" required aria-describedby="username-help">
        <span id="username-help" class="field-help">Usa la cuenta registrada en PoliMusic.</span>
      </div>
      <div class="field">
        <label for="password">Contraseña</label>
        <div class="password-wrap">
          <input id="password" name="password" type="password" maxlength="50" autocomplete="current-password" required>
          <button class="reveal-password" type="button" data-password-toggle aria-label="Mostrar contraseña" aria-pressed="false">◉</button>
        </div>
      </div>
      <button class="button primary login-button" type="submit">Ingresar a PoliMusic</button>
    </form>
    <p class="demo-access"><strong>Accesos de la base de datos:</strong><br>Normal: userNormal / 12345678<br>Administrador: userAdmin / 12345678</p>
  </main>
  <script src="<%=Asset("assets/app.js")%>?v=20261024-3"></script>
</body>
</html>
