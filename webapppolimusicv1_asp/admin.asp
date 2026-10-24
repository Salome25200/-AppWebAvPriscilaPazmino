<!--#include file="includes/db.asp"-->
<!--#include file="includes/auth.asp"-->
<!--#include file="includes/layout.asp"-->
<%
Response.Buffer = True
Call RequireAdmin()

Dim entity, editId, message, formError, cn, cmd, rs, editRs
Dim fieldOne, fieldTwo, fieldThree, isEditing, actionName
Dim formTitle, entityPlural, secondaryLabel, hasRows, rowIndex, rowName, rowSecondary
entity = LCase(Request.QueryString("entity") & "")
If Len(entity) = 0 Then entity = LCase(Request.Form("entity") & "")
If entity <> "songs" And entity <> "artists" And entity <> "albums" Then entity = "songs"
editId = Request.QueryString("edit")
message = ""
formError = ""
fieldOne = ""
fieldTwo = ""
fieldThree = ""
isEditing = False

Sub DeleteById(db, statement, recordId)
    Dim deleteCmd
    Set deleteCmd = NewCommand(db, statement)
    Call AddNumber(deleteCmd, recordId)
    deleteCmd.Execute
End Sub

On Error Resume Next
Set cn = OpenDb()
If Err.Number <> 0 Then
    formError = "No se pudo conectar con BDD_PoliMusic. Revisa SQL Server antes de realizar cambios."
    Err.Clear
End If
On Error GoTo 0

actionName = LCase(Request.Form("action") & "")
If Len(formError) = 0 And Request.ServerVariables("REQUEST_METHOD") = "POST" Then
    If actionName = "save" Then
        fieldOne = Trim(Request.Form("fieldOne") & "")
        fieldTwo = Trim(Request.Form("fieldTwo") & "")
        fieldThree = Trim(Request.Form("fieldThree") & "")
        isEditing = ValidId(Request.Form("recordId"))
        If Len(fieldOne) = 0 Then
            formError = "Completa el campo principal antes de guardar."
        ElseIf entity = "albums" And Not IsNumeric(fieldTwo) Then
            formError = "Escribe un año de lanzamiento válido de cuatro dígitos."
        ElseIf entity = "albums" And (Val(fieldTwo) < 1000 Or Val(fieldTwo) > 9999) Then
            formError = "Escribe un año de lanzamiento válido de cuatro dígitos."
        Else
            On Error Resume Next
            If entity = "songs" Then
                If Len(fieldTwo) = 0 Then formError = "Indica una ruta de audio para la canción."
                If Len(formError) = 0 Then
                    If isEditing Then
                        Set cmd = NewCommand(cn, "UPDATE TBL_SONG SET SONG_NAME = ?, SONG_PATH = ? WHERE ID_SONG = ?")
                        Call AddText(cmd, fieldOne, 50): Call AddText(cmd, fieldTwo, 255): Call AddNumber(cmd, Request.Form("recordId"))
                    Else
                        Set cmd = NewCommand(cn, "INSERT INTO TBL_SONG (SONG_NAME, SONG_PATH, PLAYS) VALUES (?, ?, 0)")
                        Call AddText(cmd, fieldOne, 50): Call AddText(cmd, fieldTwo, 255)
                    End If
                End If
            ElseIf entity = "artists" Then
                If isEditing Then
                    Set cmd = NewCommand(cn, "UPDATE TBL_ARTIST SET ARTIST_NAME = ?, ARTIST_LASTNAME = ?, ARTIST_IMAGE = ? WHERE ID_ARTIST = ?")
                    Call AddText(cmd, fieldOne, 100): Call AddText(cmd, fieldTwo, 100): Call AddText(cmd, fieldThree, 255): Call AddNumber(cmd, Request.Form("recordId"))
                Else
                    Set cmd = NewCommand(cn, "INSERT INTO TBL_ARTIST (ARTIST_NAME, ARTIST_LASTNAME, ARTIST_IMAGE) VALUES (?, ?, ?)")
                    Call AddText(cmd, fieldOne, 100): Call AddText(cmd, fieldTwo, 100): Call AddText(cmd, fieldThree, 255)
                End If
            Else
                If isEditing Then
                    Set cmd = NewCommand(cn, "UPDATE TBL_ALBUM SET TITLE_ALBUM = ?, RELEASE_YEAR = ?, ALBUM_IMAGE_PATH = ? WHERE ID_ALBUM = ?")
                    Call AddText(cmd, fieldOne, 50): Call AddNumber(cmd, fieldTwo): Call AddText(cmd, fieldThree, 255): Call AddNumber(cmd, Request.Form("recordId"))
                Else
                    Set cmd = NewCommand(cn, "INSERT INTO TBL_ALBUM (TITLE_ALBUM, RELEASE_YEAR, ALBUM_IMAGE_PATH) VALUES (?, ?, ?)")
                    Call AddText(cmd, fieldOne, 50): Call AddNumber(cmd, fieldTwo): Call AddText(cmd, fieldThree, 255)
                End If
            End If
            If Len(formError) = 0 Then cmd.Execute
            If Err.Number <> 0 Then
                formError = "No se pudo guardar el registro. Verifica que los datos no excedan la longitud permitida."
                Err.Clear
            ElseIf Len(formError) = 0 Then
                If isEditing Then message = "Cambios guardados correctamente." Else message = "Registro creado correctamente."
                fieldOne = "": fieldTwo = "": fieldThree = "": editId = "": isEditing = False
            End If
            On Error GoTo 0
        End If
    ElseIf actionName = "delete" And ValidId(Request.Form("deleteId")) Then
        On Error Resume Next
        cn.BeginTrans
        If entity = "songs" Then
            Call DeleteById(cn, "DELETE FROM TBL_PLAYLIST_SONG WHERE ID_SONG = ?", Request.Form("deleteId"))
            Call DeleteById(cn, "DELETE FROM TBL_TRACKLIST WHERE ID_SONG = ?", Request.Form("deleteId"))
            Call DeleteById(cn, "DELETE FROM TBL_PLAYER WHERE ID_SONG = ?", Request.Form("deleteId"))
            Call DeleteById(cn, "DELETE FROM TBL_SONG WHERE ID_SONG = ?", Request.Form("deleteId"))
        ElseIf entity = "artists" Then
            Call DeleteById(cn, "DELETE FROM TBL_PLAYER WHERE ID_ARTIST = ?", Request.Form("deleteId"))
            Call DeleteById(cn, "DELETE FROM TBL_ARTIST WHERE ID_ARTIST = ?", Request.Form("deleteId"))
        Else
            Call DeleteById(cn, "DELETE FROM TBL_TRACKLIST WHERE ID_ALBUM = ?", Request.Form("deleteId"))
            Call DeleteById(cn, "DELETE FROM TBL_ALBUM WHERE ID_ALBUM = ?", Request.Form("deleteId"))
        End If
        If Err.Number <> 0 Then
            cn.RollbackTrans
            formError = "No se pudo eliminar el registro. La operación se revirtió."
            Err.Clear
        Else
            cn.CommitTrans
            message = "Registro eliminado y relaciones asociadas actualizadas."
            editId = ""
        End If
        On Error GoTo 0
    End If
End If

If Len(formError) = 0 And ValidId(editId) And Not isEditing Then
    On Error Resume Next
    If entity = "songs" Then
        Set editRs = cn.Execute("SELECT ID_SONG, SONG_NAME, SONG_PATH FROM TBL_SONG WHERE ID_SONG = " & CLng(editId))
    ElseIf entity = "artists" Then
        Set editRs = cn.Execute("SELECT ID_ARTIST, ARTIST_NAME, ARTIST_LASTNAME, ARTIST_IMAGE FROM TBL_ARTIST WHERE ID_ARTIST = " & CLng(editId))
    Else
        Set editRs = cn.Execute("SELECT ID_ALBUM, TITLE_ALBUM, RELEASE_YEAR, ALBUM_IMAGE_PATH FROM TBL_ALBUM WHERE ID_ALBUM = " & CLng(editId))
    End If
    If Err.Number = 0 Then
      If Not editRs.EOF Then
        isEditing = True
        If entity = "songs" Then
            fieldOne = editRs("SONG_NAME"): fieldTwo = editRs("SONG_PATH")
        ElseIf entity = "artists" Then
            fieldOne = editRs("ARTIST_NAME"): fieldTwo = editRs("ARTIST_LASTNAME"): fieldThree = editRs("ARTIST_IMAGE")
        Else
            fieldOne = editRs("TITLE_ALBUM"): fieldTwo = editRs("RELEASE_YEAR"): fieldThree = editRs("ALBUM_IMAGE_PATH")
        End If
      Else
        editId = ""
      End If
    Else
      editId = ""
      Err.Clear
    End If
    On Error GoTo 0
End If

If Len(formError) = 0 Then
    On Error Resume Next
    If entity = "songs" Then
        Set rs = cn.Execute("SELECT ID_SONG, SONG_NAME, SONG_PATH, ISNULL(PLAYS, 0) AS PLAYS FROM TBL_SONG ORDER BY SONG_NAME")
    ElseIf entity = "artists" Then
        Set rs = cn.Execute("SELECT ID_ARTIST, ARTIST_NAME, ARTIST_LASTNAME, ARTIST_IMAGE FROM TBL_ARTIST ORDER BY ARTIST_NAME, ARTIST_LASTNAME")
    Else
        Set rs = cn.Execute("SELECT ID_ALBUM, TITLE_ALBUM, RELEASE_YEAR, ALBUM_IMAGE_PATH FROM TBL_ALBUM ORDER BY TITLE_ALBUM")
    End If
    If Err.Number <> 0 Then formError = "No se pudo recuperar el listado solicitado.": Err.Clear
    On Error GoTo 0
End If

If entity = "songs" Then
    entityPlural = "canciones"
    secondaryLabel = "Ruta / reproducciones"
    If isEditing Then formTitle = "Editar canción" Else formTitle = "Nueva canción"
ElseIf entity = "artists" Then
    entityPlural = "artistas"
    secondaryLabel = "Apellido"
    If isEditing Then formTitle = "Editar artista" Else formTitle = "Nuevo artista"
Else
    entityPlural = "álbumes"
    secondaryLabel = "Año"
    If isEditing Then formTitle = "Editar álbum" Else formTitle = "Nuevo álbum"
End If
hasRows = False
If Len(formError) = 0 Then
    If Not rs Is Nothing Then
        If Not rs.EOF Then hasRows = True
    End If
End If

Call PageStart("Administración")
%>
<section class="page-head" aria-labelledby="admin-title">
  <div><p class="eyebrow">ADMINISTRADOR · CATÁLOGO</p><h1 id="admin-title">Administración</h1><p>Gestiona el catálogo existente sin crear tablas nuevas. Todos los cambios se guardan en BDD_PoliMusic.</p></div>
</section>
<% If Len(message) > 0 Then %><div class="notice success" role="status">✓ <%=H(message)%></div><% End If %>
<% If Len(formError) > 0 Then %><div class="notice error" role="alert">! <%=H(formError)%></div><% End If %>
<section class="admin-layout">
  <nav class="entity-nav" aria-label="Entidades administrativas">
    <a href="admin.asp?entity=songs"<% If entity = "songs" Then Response.Write " aria-current=""page""" %>>Canciones</a>
    <a href="admin.asp?entity=artists"<% If entity = "artists" Then Response.Write " aria-current=""page""" %>>Artistas</a>
    <a href="admin.asp?entity=albums"<% If entity = "albums" Then Response.Write " aria-current=""page""" %>>Álbumes</a>
    <p class="entity-tip">Los borrados son permanentes. La interfaz pedirá confirmación y actualizará las relaciones de la entidad elegida.</p>
  </nav>
  <div>
    <section class="form-panel" aria-labelledby="form-title">
      <h2 id="form-title"><%=H(formTitle)%></h2>
      <p>Los campos marcados como principales son obligatorios.</p>
      <form method="post" action="admin.asp" novalidate data-busy-form>
        <input type="hidden" name="entity" value="<%=entity%>"><input type="hidden" name="action" value="save"><input type="hidden" name="recordId" value="<% If isEditing Then Response.Write CLng(editId) %>">
        <div class="field-grid">
<% If entity = "songs" Then %>
          <div class="field"><label for="fieldOne">Nombre de canción</label><input id="fieldOne" name="fieldOne" type="text" maxlength="50" required value="<%=H(fieldOne)%>"></div>
          <div class="field"><label for="fieldTwo">Ruta del audio</label><input id="fieldTwo" name="fieldTwo" type="text" maxlength="255" required value="<%=H(fieldTwo)%>" placeholder="~/songFiles/bensound-adventure.mp3"><span class="field-help">El reproductor usa el MP3 disponible en SongFilesAndImages_resources.</span></div>
<% ElseIf entity = "artists" Then %>
          <div class="field"><label for="fieldOne">Nombre artístico</label><input id="fieldOne" name="fieldOne" type="text" maxlength="100" required value="<%=H(fieldOne)%>"></div>
          <div class="field"><label for="fieldTwo">Apellido</label><input id="fieldTwo" name="fieldTwo" type="text" maxlength="100" value="<%=H(fieldTwo)%>"></div>
          <div class="field full"><label for="fieldThree">Ruta de imagen</label><input id="fieldThree" name="fieldThree" type="text" maxlength="255" value="<%=H(fieldThree)%>" placeholder="~/ArtistImages/artist1.jpg"><span class="field-help">Las portadas visuales se resuelven con las imágenes incluidas en assets.</span></div>
<% Else %>
          <div class="field"><label for="fieldOne">Título del álbum</label><input id="fieldOne" name="fieldOne" type="text" maxlength="50" required value="<%=H(fieldOne)%>"></div>
          <div class="field"><label for="fieldTwo">Año de lanzamiento</label><input id="fieldTwo" name="fieldTwo" type="number" min="1000" max="9999" required value="<%=H(fieldTwo)%>"></div>
          <div class="field full"><label for="fieldThree">Ruta de imagen</label><input id="fieldThree" name="fieldThree" type="text" maxlength="255" value="<%=H(fieldThree)%>" placeholder="~/albumImages/album1.png"><span class="field-help">Las portadas visuales se resuelven con las imágenes incluidas en assets.</span></div>
<% End If %>
        </div>
        <div class="form-actions"><button class="button primary" type="submit"><% If isEditing Then Response.Write "Guardar cambios" Else Response.Write "Crear registro" %></button><% If isEditing Then %><a class="button outline" href="admin.asp?entity=<%=entity%>">Cancelar edición</a><% End If %></div>
      </form>
    </section>
    <section class="data-panel" aria-labelledby="list-title">
      <div class="data-panel-head"><h2 id="list-title">Listado actual</h2><span>Seleccione Editar para cargar un registro.</span></div>
      <table>
        <caption>Listado de <%=H(entityPlural)%></caption>
        <thead><tr><th scope="col">Registro</th><th scope="col"><%=H(secondaryLabel)%></th><th scope="col">Acciones</th></tr></thead>
        <tbody>
<% If hasRows Then
  rowIndex = 0
  Do Until rs.EOF
    rowIndex = rowIndex + 1
    If entity = "songs" Then
        rowName = rs("SONG_NAME")
        rowSecondary = H(rs("SONG_PATH")) & " · " & rs("PLAYS") & " reproducciones"
    ElseIf entity = "artists" Then
        rowName = rs("ARTIST_NAME")
        rowSecondary = H(rs("ARTIST_LASTNAME"))
    Else
        rowName = rs("TITLE_ALBUM")
        rowSecondary = H(rs("RELEASE_YEAR"))
    End If
%>
          <tr>
            <td><div class="table-name"><img src="<%=ImageFile("", rowIndex)%>" alt="" width="34" height="34"><span><%=H(rowName)%></span></div></td>
            <td class="table-muted"><%=rowSecondary%></td>
            <td><div class="row-actions"><a href="admin.asp?entity=<%=entity%>&edit=<%=rs(0)%>">Editar</a><button type="button" data-delete-id="<%=rs(0)%>" data-delete-name="<%=H(rowName)%>">Eliminar</button></div></td>
          </tr>
<% rs.MoveNext: Loop
ElseIf Len(formError) = 0 Then %>
          <tr><td colspan="3" class="table-muted">Todavía no hay registros para esta entidad.</td></tr>
<% End If %>
        </tbody>
      </table>
    </section>
  </div>
</section>
<div class="dialog-backdrop" id="deleteDialog" role="presentation">
  <section class="dialog" role="alertdialog" aria-modal="true" aria-labelledby="delete-title" aria-describedby="delete-description">
    <h2 id="delete-title">Eliminar registro</h2><p id="delete-description">Eliminarás permanentemente <strong id="deleteName">este registro</strong> y sus relaciones directas. Esta acción no se puede deshacer.</p>
    <form method="post" action="admin.asp" novalidate data-busy-form><input type="hidden" name="entity" value="<%=entity%>"><input type="hidden" name="action" value="delete"><input type="hidden" name="deleteId" id="deleteId"><div class="dialog-actions"><button class="button outline" type="button" data-dialog-cancel>Cancelar</button><button class="button danger" type="submit">Eliminar permanentemente</button></div></form>
  </section>
</div>
<% Call PageEnd() %>
