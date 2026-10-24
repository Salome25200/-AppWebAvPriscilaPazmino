<!--#include file="includes/auth.asp"-->
<!--#include file="includes/layout.asp"-->
<%
Call RequireLogin()
Call PageStart("Acceso denegado")
%>
<section class="forbidden" aria-labelledby="forbidden-title">
  <div class="forbidden-box">
    <p class="eyebrow">ERROR 403</p>
    <h1 id="forbidden-title">Acceso reservado</h1>
    <p>Esta sección está disponible únicamente para la cuenta administradora. Tu biblioteca y el reproductor continúan disponibles.</p>
    <a class="button primary" href="index.asp">Volver a Song List</a>
  </div>
</section>
<% Call PageEnd() %>
