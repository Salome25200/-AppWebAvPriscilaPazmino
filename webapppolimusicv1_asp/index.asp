<!--#include file="includes/db.asp"-->
<!--#include file="includes/auth.asp"-->
<!--#include file="includes/layout.asp"-->
<%
Response.Buffer = True
Call RequireLogin()
Dim cn, rs, countRs, songTotal, pageError
songTotal = 0
pageError = ""
On Error Resume Next
Set cn = OpenDb()
Set countRs = cn.Execute("SELECT COUNT(*) AS SONG_TOTAL FROM TBL_SONG")
songTotal = countRs("SONG_TOTAL")
Set rs = cn.Execute("SELECT s.ID_SONG, s.SONG_NAME, s.SONG_PATH, ISNULL(s.PLAYS, 0) AS PLAYS, " & _
  "ISNULL(STUFF((SELECT ', ' + LTRIM(RTRIM(a.ARTIST_NAME + ' ' + ISNULL(a.ARTIST_LASTNAME, ''))) FROM TBL_PLAYER p INNER JOIN TBL_ARTIST a ON a.ID_ARTIST = p.ID_ARTIST WHERE p.ID_SONG = s.ID_SONG FOR XML PATH(''), TYPE).value('.', 'varchar(max)'), 1, 2, ''), 'Sin artista') AS ARTISTS, " & _
  "ISNULL(STUFF((SELECT ', ' + al.TITLE_ALBUM FROM TBL_TRACKLIST t INNER JOIN TBL_ALBUM al ON al.ID_ALBUM = t.ID_ALBUM WHERE t.ID_SONG = s.ID_SONG FOR XML PATH(''), TYPE).value('.', 'varchar(max)'), 1, 2, ''), 'Single') AS ALBUMS " & _
  "FROM TBL_SONG s ORDER BY ISNULL(s.PLAYS, 0) DESC, s.SONG_NAME ASC")
If Err.Number <> 0 Then
    pageError = "No fue posible cargar las canciones. Comprueba la conexión a BDD_PoliMusic."
    Err.Clear
End If
On Error GoTo 0
Call PageStart("Song List")
%>
<section class="page-head" aria-labelledby="song-list-title">
  <div>
    <p class="eyebrow">BIBLIOTECA · DISPONIBLE</p>
    <h1 id="song-list-title">Song List</h1>
    <p>Tu señal de hoy: selecciona una canción para escucharla. El reproductor utiliza los archivos MP3 incluidos en los assets del proyecto.</p>
  </div>
  <div class="metric"><strong><% If Len(pageError) = 0 Then Response.Write songTotal %></strong>canciones</div>
</section>
<% If Len(pageError) > 0 Then %>
  <div class="notice error" role="alert"><%=H(pageError)%></div>
<% ElseIf rs.EOF Then %>
  <div class="notice info" role="status">La biblioteca no tiene canciones todavía.</div>
<% Else %>
  <section class="row row-cols-1 row-cols-md-2 row-cols-xl-3 g-4 song-list" aria-label="Listado de canciones">
<%
Dim artIndex
artIndex = 0
Do Until rs.EOF
  artIndex = artIndex + 1
%>
    <article class="col">
      <div class="song-card h-100">
      <div class="song-card-top">
        <img class="song-art" src="<%=ImageFile("", artIndex)%>" alt="Portada decorativa de <%=H(rs("SONG_NAME"))%>" width="84" height="84">
        <div class="song-details">
          <h2 class="song-name"><%=H(rs("SONG_NAME"))%></h2>
          <p class="song-artist"><%=H(rs("ARTISTS"))%></p>
          <p class="song-album"><%=H(rs("ALBUMS"))%></p>
        </div>
      </div>
      <div class="song-card-bottom">
        <span class="song-count"><%=rs("PLAYS")%> reproducciones</span>
        <button class="play-song" type="button" data-song-id="<%=rs("ID_SONG")%>" data-title="<%=H(rs("SONG_NAME"))%>" data-audio="<%=AudioFile(rs("SONG_PATH"))%>" aria-label="Reproducir <%=H(rs("SONG_NAME"))%>" aria-pressed="false"><span class="play-icon" aria-hidden="true">▶</span><span class="play-label">Reproducir</span></button>
      </div>
      </div>
    </article>
<%
  rs.MoveNext
Loop
%>
  </section>
  <section class="now-playing" aria-label="Reproductor de audio">
    <img class="now-art" src="<%=ImageFile("", 1)%>" alt="" width="48" height="48">
    <div class="now-label"><span>REPRODUCIENDO AHORA</span><strong id="nowSong">Elige una canción</strong></div>
    <div class="equalizer" aria-hidden="true"><i></i><i></i><i></i><i></i><i></i></div>
    <audio id="appAudio" controls preload="metadata" aria-label="Controles del reproductor"></audio>
  </section>
<% End If %>
<% Call PageEnd() %>
