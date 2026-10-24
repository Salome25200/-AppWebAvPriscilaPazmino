<%
Sub PageStart(pageTitle)
    Dim isAdmin
    isAdmin = (CInt(Session("UserType")) = 1)
%>
<!doctype html>
<html lang="es">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="color-scheme" content="dark">
  <title><%=H(pageTitle)%> — PoliMusic</title>
  <link rel="icon" type="image/svg+xml" href="<%=Asset("assets/favicon.svg")%>">
  <link rel="stylesheet" href="<%=Asset("assets/vendor/bootstrap.min.css")%>?v=5.3.8">
  <link rel="stylesheet" href="<%=Asset("assets/styles.css")%>?v=20261024-3">
</head>
<body>
  <div class="app-shell">
    <aside class="sidebar" aria-label="Navegacion principal">
      <a class="brand" href="index.asp" aria-label="PoliMusic, inicio"><span class="brand-mark">P</span><span>POLI<span class="brand-accent">MUSIC</span></span></a>
      <p class="nav-label">TU BIBLIOTECA</p>
      <nav class="nav-links">
        <a href="index.asp"<% If LCase(pageTitle) = "song list" Then Response.Write " aria-current=""page""" %>><span aria-hidden="true">◈</span> Song List</a>
<% If isAdmin Then %>
        <a href="admin.asp"<% If LCase(pageTitle) = "administracion" Then Response.Write " aria-current=""page""" %>><span aria-hidden="true">✦</span> Administración</a>
<% End If %>
      </nav>
      <div class="sidebar-note"><span class="pulse-dot" aria-hidden="true"></span>Audio disponible</div>
    </aside>
    <main class="content">
      <header class="topbar">
        <button class="menu-button" type="button" data-menu-toggle aria-label="Abrir navegación" aria-expanded="false">☰</button>
        <div class="welcome"><span>Bienvenido,</span> <strong><%=H(Session("Username"))%></strong></div>
        <div class="account"><img src="<%=ImageFile(Session("UserPhoto"), 0)%>" alt="" width="38" height="38"><a href="logout.asp">Cerrar sesión</a></div>
      </header>
<%
End Sub

Sub PageEnd()
%>
    </main>
  </div>
  <div id="toast-region" class="toast-region" aria-live="polite" aria-atomic="true"></div>
  <script src="<%=Asset("assets/app.js")%>?v=20261024-3"></script>
</body>
</html>
<%
End Sub
%>
