<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Song.aspx.cs" Inherits="WebAppPoliMusicV2.Song" ResponseEncoding="utf-8" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="es">
<head runat="server">
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<link rel="icon" href="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 32 32'%3E%3Ccircle cx='16' cy='16' r='16' fill='%231ED760'/%3E%3Cpath d='M13 10v13c-7 4-8-5-2-4V9l13-3v14c-7 4-8-5-2-4V9z' fill='%23121212'/%3E%3C/svg%3E" />
<title>Mi biblioteca musical · PoliMusic</title>
<style type="text/css">
/* Identidad local: paleta solicitada, fuentes del sistema y portadas CSS. */
:root{color-scheme:dark;--green:#1DB954;--bright:#1ED760;--bg:#121212;--surface:#181818;--card:#282828;--text:#FFFFFF;--muted:#B3B3B3;--thumb:#686868}
*{box-sizing:border-box;scrollbar-color:var(--thumb) var(--surface);scrollbar-width:thin}
body{margin:0;background:#080808;color:var(--text);font:15px/1.6 "Segoe UI",Arial,sans-serif}
a{color:inherit;text-decoration:none}a:hover{color:var(--bright)}a:focus-visible,button:focus-visible,audio:focus-visible{outline:3px solid var(--bright);outline-offset:5px}
::-webkit-scrollbar{width:10px;height:10px}::-webkit-scrollbar-track{background:var(--surface)}::-webkit-scrollbar-thumb{background:var(--thumb);border:2px solid var(--surface);border-radius:8px}::-webkit-scrollbar-thumb:hover{background:var(--muted)}
.skip{position:absolute;top:-70px;left:20px;padding:12px;background:var(--green);color:#000;z-index:10}.skip:focus{top:12px}
.shell{display:grid;grid-template-columns:224px minmax(0,1fr);min-height:100vh}.sidebar{padding:36px 22px;display:flex;flex-direction:column;border-right:1px solid #242424}
.brand{display:flex;align-items:center;gap:10px;font-size:25px;font-weight:800;letter-spacing:-1px}.brand-icon{display:grid;place-items:center;width:38px;height:38px;border-radius:50%;background:var(--bright);color:#081b10;font-size:25px}
.nav{margin-top:48px}.nav a{display:flex;gap:12px;align-items:center;padding:12px 14px;border-radius:8px;background:#1b2c21;color:var(--bright);font-weight:600}.nav svg{width:20px;height:20px;fill:none;stroke:currentColor;stroke-width:1.7}
.side-note{margin-top:auto;padding-top:70px;color:var(--muted);font-size:12px}.side-note strong{display:block;color:#ddd;font-size:14px;margin-bottom:5px}
.main{background:var(--bg);min-width:0}.topbar{display:flex;justify-content:space-between;align-items:center;gap:18px;padding:23px 42px;border-bottom:1px solid #ffffff0d}.topbar-label{color:var(--muted);font-size:12px}.welcome{display:flex;align-items:center;gap:16px;min-width:0;padding-bottom:26px;border-bottom:1px solid #ffffff18}.welcome-copy,.hero-copy{min-width:0}.welcome-title{margin:0;color:var(--text);font-size:30px;font-weight:650;line-height:1.25;letter-spacing:-.8px;overflow-wrap:anywhere}.welcome-title strong{color:var(--bright);font-weight:750}.welcome-subtitle{margin:7px 0 0;color:#c6d1c9;font-size:14px;line-height:1.5}.user-icon{display:grid;place-items:center;flex:0 0 50px;height:50px;border-radius:50%;color:var(--bright);background:#1ED76012;border:1px solid #1ED76055}.user-icon svg{width:27px;height:27px;fill:none;stroke:currentColor;stroke-width:1.7;stroke-linecap:round}
.logout{display:flex;align-items:center;gap:9px;border:1px solid #494949;border-radius:24px;padding:8px 17px;font-size:13px;font-weight:600;transition:background .2s,border-color .2s}.logout:hover{background:var(--card);border-color:var(--muted);color:#fff}.logout svg{width:17px;height:17px;fill:none;stroke:currentColor;stroke-width:1.7}
.hero{display:flex;flex-direction:column;align-items:stretch;gap:32px;padding:32px 42px 46px;background:linear-gradient(125deg,#194d30 0%,#173322 40%,#142019 75%,var(--bg) 100%);overflow:hidden}.library-intro{display:flex;align-items:center;gap:36px}.art{flex:0 0 174px;height:174px;display:grid;place-items:center;background:linear-gradient(135deg,#1ED760,#176d3b);box-shadow:0 16px 38px #0005;border-radius:8px;transform:rotate(-5deg)}.record{width:132px;height:132px;border-radius:50%;display:grid;place-items:center;background:repeating-radial-gradient(circle,#171d19 0,#171d19 3px,#29342c 4px,#171d19 5px);box-shadow:5px 6px 16px #0006}.record span{display:grid;place-items:center;width:48px;height:48px;border-radius:50%;background:var(--bright);color:#133b22;font-size:28px}
.eyebrow{margin:0 0 9px;font-size:11px;font-weight:700;letter-spacing:2px;text-transform:uppercase;color:#c1e4cb}h1{margin:0;font-size:clamp(32px,4.4vw,62px);letter-spacing:-2.5px;line-height:1.08;font-weight:800}.subtitle{color:#c6d1c9;margin:18px 0 20px}.meta{display:flex;align-items:center;gap:9px;color:#d8e9dc;font-size:13px}.dot{width:7px;height:7px;background:var(--bright);border-radius:50%}
.library{padding:32px 42px 48px}.section-heading{display:flex;align-items:center;justify-content:space-between;gap:16px;margin-bottom:24px}h2{margin:0;font-size:23px;letter-spacing:-.6px}.section-heading p{margin:4px 0 0;color:var(--muted);font-size:13px}.format{font-size:11px;color:var(--bright);border:1px solid #356345;padding:4px 10px;border-radius:5px;letter-spacing:1px}
.songs{width:100%;border-collapse:separate;border-spacing:0 7px;table-layout:fixed}.songs th{text-align:left;padding:10px 16px;color:var(--muted);font-size:11px;text-transform:uppercase;letter-spacing:1.5px;font-weight:500;border-bottom:1px solid #333}.songs th:first-child{width:43%}.songs th:nth-child(2){width:19%}.songs td{background:var(--surface);padding:16px;transition:background .2s;vertical-align:middle}.songs tr:hover td,.songs tr:focus-within td{background:var(--card)}.songs tr.is-playing td{background:#1c3023}.songs td:first-child{border-radius:8px 0 0 8px}.songs td:last-child{border-radius:0 8px 8px 0}
.track{display:flex;align-items:center;gap:15px;min-width:0}.cover{width:48px;height:48px;flex:0 0 48px;display:grid;place-items:center;border-radius:6px;background:linear-gradient(135deg,#335a42,#1b3024);color:#a3e9b8;font-size:26px}.songs tr:nth-child(3n) .cover{background:linear-gradient(135deg,#355456,#1d3033);color:#bee8e9}.songs tr:nth-child(3n + 1) .cover{background:linear-gradient(135deg,#575334,#302b1e);color:#ece3b2}.track-name{display:block;font-weight:600;line-height:1.4;overflow-wrap:anywhere}.track-detail{display:block;font-size:12px;color:var(--muted);margin-top:3px}.plays{font-variant-numeric:tabular-nums;color:var(--muted);font-size:13px}
audio{display:block;width:100%;min-width:0;height:36px;border-radius:20px}.audio-error,.unavailable{display:block;font-size:12px;color:#e2c89c}.audio-error{margin-top:7px}.audio-error[hidden]{display:none}
.message{border:1px solid #454545;border-radius:12px;background:var(--surface);padding:35px 25px;text-align:center;color:var(--muted)}.message strong{display:block;color:#fff;font-size:19px;margin-bottom:8px}.message a{display:inline-block;color:#081b10;background:var(--bright);border-radius:24px;padding:9px 20px;margin-top:18px;font-weight:700}.message a:hover{background:var(--green)}
.pager td{background:transparent;padding:16px 4px}.pager table{margin:auto}.pager a,.pager span{display:inline-block;padding:5px 13px;border-radius:5px}.pager span{color:#071a0d;background:var(--bright)}.pager a:hover{background:var(--card)}
.now{display:flex;align-items:center;gap:14px;padding:22px 42px;background:#151b17;border-top:1px solid #2c3e31}.now-icon{color:var(--bright);font-size:26px}.now-label{color:var(--muted);font-size:11px;text-transform:uppercase;letter-spacing:1.5px}#nowTitle{display:block;overflow-wrap:anywhere;font-size:14px}.foot{padding:20px 42px;color:#949494;font-size:11px;display:flex;justify-content:space-between;gap:12px}
@media(min-width:1500px){.library,.hero,.topbar,.now,.foot{padding-left:64px;padding-right:64px}}
@media(max-width:1100px){.shell{grid-template-columns:180px minmax(0,1fr)}.sidebar{padding:30px 16px}.brand{font-size:22px}.hero{gap:24px}.library-intro{gap:24px}.art{flex-basis:130px;height:130px}.record{width:105px;height:105px}.topbar,.hero,.library,.now,.foot{padding-left:25px;padding-right:25px}.songs th:first-child{width:37%}.songs th:nth-child(2){width:21%}.songs th{letter-spacing:.5px;padding:10px 8px}.songs td{padding:12px 9px}}
@media(max-width:850px){.shell{display:block}.sidebar{flex-direction:row;align-items:center;justify-content:space-between;padding:17px 20px;border-right:0}.nav{margin:0}.nav a{padding:9px 12px;font-size:12px}.side-note{display:none}.topbar{padding:16px 20px}.hero{padding:26px 20px 32px;gap:24px}.library-intro{gap:20px}.welcome{align-items:flex-start;gap:12px;padding-bottom:22px}.welcome-title{font-size:23px;letter-spacing:-.4px}.welcome-subtitle{font-size:13px}.user-icon{flex-basis:40px;height:40px}.user-icon svg{width:23px;height:23px}.topbar-label{font-size:11px}.art{flex-basis:92px;height:92px}.record{width:76px;height:76px}.record span{width:30px;height:30px;font-size:20px}h1{font-size:36px;letter-spacing:-1.5px}.eyebrow{font-size:9px}.subtitle{font-size:13px;margin:13px 0}.library{padding:25px 20px}.songs,.songs tbody,.songs tr,.songs td{display:block;width:100%}.songs thead{display:none}.songs tr{margin-bottom:14px;border-radius:10px;overflow:hidden;background:var(--surface)}.songs td{padding:12px 16px}.songs td:first-child,.songs td:last-child{border-radius:0}.songs td:nth-child(2){padding-top:0;padding-bottom:2px;padding-left:79px}.songs td:nth-child(2)::before{content:'Reproducciones: ';color:var(--muted);font-size:12px}.songs .pager table,.songs .pager tbody,.songs .pager tr,.songs .pager td{display:revert;width:auto}.songs .pager{background:transparent}.now,.foot{padding:20px}}
@media(max-width:390px){.art{display:none}.welcome-title{font-size:22px}.brand{font-size:20px}.brand-icon{width:30px;height:30px}.nav a{gap:6px}.foot{flex-direction:column}}
@media(prefers-reduced-motion:reduce){*{transition:none!important}}
@media(forced-colors:active){*{scrollbar-color:auto}.cover,.art,.record,.brand-icon{border:1px solid CanvasText}}
</style>
</head>
<body>
<a class="skip" href="#biblioteca">Ir a mi biblioteca</a>
<form id="form1" runat="server" novalidate="novalidate">
<div class="shell">
<aside class="sidebar" aria-label="Navegación principal">
<a class="brand" href="Song.aspx" aria-label="PoliMusic, mi biblioteca"><span class="brand-icon" aria-hidden="true">♫</span>PoliMusic</a>
<nav class="nav"><a href="#biblioteca" aria-current="page"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M4 4v16M9 4v16M14 4l6 16M3 4h2M8 4h2" /></svg>Mi biblioteca</a></nav>
<div class="side-note"><strong>Tu música. Tu espacio.</strong>Encuentra tu ritmo en PoliMusic.</div>
</aside>
<main class="main" id="biblioteca" tabindex="-1">
<header class="topbar"><span class="topbar-label">PoliMusic · Tu espacio musical</span><a class="logout" href="Logout.aspx"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M10 4H4v16h6M9 12h12m-5-5 5 5-5 5" /></svg>Cerrar sesión</a></header>
<section class="hero" aria-labelledby="pageTitle">
<div class="welcome">
    <span class="user-icon" aria-hidden="true"><svg viewBox="0 0 24 24"><circle cx="12" cy="8" r="3.5" /><path d="M5 21v-2a7 7 0 0 1 14 0v2" /></svg></span>
    <div class="welcome-copy"><h2 class="welcome-title">¡Hola, <strong><asp:Literal ID="welcomeUserName" runat="server" /></strong>!</h2><p class="welcome-subtitle">Qué bueno tenerte de vuelta en PoliMusic</p></div>
</div>
<div class="library-intro"><div class="art" aria-hidden="true"><div class="record"><span>♫</span></div></div><div class="hero-copy"><p class="eyebrow">Tu colección personal</p><h1 id="pageTitle">Mi biblioteca musical</h1><p class="subtitle">Disfruta de tus canciones favoritas en un solo lugar</p><div class="meta"><span class="dot" aria-hidden="true"></span><asp:Literal ID="songCount" runat="server" Text="Biblioteca musical" /></div></div></div>
</section>
<section class="library" aria-labelledby="songsTitle">
<div class="section-heading"><div><h2 id="songsTitle">Tus canciones</h2><p>Elige una canción y dale play.</p></div><span class="format">MP3</span></div>
<asp:Panel ID="libraryMessage" runat="server" Visible="false" CssClass="message" role="status"><strong><asp:Literal ID="messageTitle" runat="server" /></strong><asp:Literal ID="messageBody" runat="server" /><asp:HyperLink ID="retryLink" runat="server" NavigateUrl="~/Song.aspx" Visible="false" Text="Volver a intentar" /></asp:Panel>
<asp:GridView ID="songGrid" runat="server" AutoGenerateColumns="false" CssClass="songs" GridLines="None" CellPadding="0" UseAccessibleHeader="true" AllowPaging="true" PageSize="12" OnPageIndexChanging="SongGrid_PageIndexChanging" OnPreRender="SongGrid_PreRender">
<Columns>
<asp:TemplateField HeaderText="Canción"><ItemTemplate><div class="track"><span class="cover" aria-hidden="true">♫</span><div><span class="track-name"><%# Encode(Eval("SONG_NAME")) %></span><span class="track-detail">Archivo MP3</span></div></div></ItemTemplate></asp:TemplateField>
<asp:TemplateField HeaderText="Reproducciones"><ItemTemplate><span class="plays"><%# FormatPlays(Eval("PLAYS")) %></span></ItemTemplate></asp:TemplateField>
<asp:TemplateField HeaderText="Reproducir"><ItemTemplate><%# RenderAudio(Eval("SONG_PATH"), Eval("SONG_NAME")) %></ItemTemplate></asp:TemplateField>
</Columns><PagerStyle CssClass="pager" /><PagerSettings Mode="NumericFirstLast" FirstPageText="Primera" LastPageText="Última" Position="Bottom" />
</asp:GridView>
</section>
<section class="now" aria-label="Estado del reproductor"><span class="now-icon" aria-hidden="true">♫</span><div role="status" aria-live="polite"><span class="now-label" id="nowLabel">A tu ritmo</span><strong id="nowTitle">Selecciona una canción para empezar</strong></div></section>
<footer class="foot"><span>PoliMusic · Hecho para escuchar</span><span>Priscila Pazmiño Santacruz</span></footer>
</main></div>
</form>
<script type="text/javascript">
(function () {
    var players = document.querySelectorAll('audio[data-song]');
    var title = document.getElementById('nowTitle');
    var label = document.getElementById('nowLabel');
    function mark(player, active) { var row = player.closest('tr'); if (row) { row.classList.toggle('is-playing', active); } }
    for (var i = 0; i < players.length; i++) {
        players[i].addEventListener('play', function () {
            for (var j = 0; j < players.length; j++) { if (players[j] !== this) { players[j].pause(); mark(players[j], false); } }
            mark(this, true); label.textContent = 'Reproduciendo ahora'; title.textContent = this.getAttribute('data-song');
        });
        players[i].addEventListener('pause', function () { mark(this, false); if (title.textContent === this.getAttribute('data-song')) { label.textContent = 'En pausa'; } });
        players[i].addEventListener('ended', function () { mark(this, false); label.textContent = 'Finalizó la canción'; });
        players[i].addEventListener('error', function () {
            mark(this, false); this.hidden = true; this.parentNode.querySelector('.audio-error').hidden = false;
            label.textContent = 'No se pudo reproducir'; title.textContent = this.getAttribute('data-song');
        });
    }
}());
</script>
</body>
</html>
