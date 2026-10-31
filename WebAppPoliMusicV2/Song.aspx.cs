using System;
using System.Configuration;
using System.Data;
using System.Globalization;
using System.IO;
using System.Web;
using System.Web.UI.WebControls;

namespace WebAppPoliMusicV2
{
    public partial class Song : System.Web.UI.Page
    {
        // TEMPORAL (laboratorio): cambiar a false para volver a los MP3 originales.
        private static readonly bool UseAdventureAudioForLab = true;
        private string labAudioUrl = String.Empty;

        // FindControl conserva el diseñador y permite que Visual Studio lo regenere.
        private GridView LibraryGrid
        {
            get { return (GridView)form1.FindControl("songGrid"); }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.Cache.SetNoStore();
            Entities.User currentUser = Session[Util.Constants.USER] as Entities.User;
            if (currentUser == null || String.IsNullOrEmpty(currentUser.UserName) ||
                currentUser.UserName.Trim().Length == 0)
            {
                Response.Redirect("~/Login.aspx", true);
                return;
            }
            ((Literal)form1.FindControl("welcomeUserName")).Text = Encode(currentUser.UserName);
            if (!IsPostBack) { BindSongs(); }
        }

        private void BindSongs()
        {
            ((Panel)form1.FindControl("libraryMessage")).Visible = false;
            ((HyperLink)form1.FindControl("retryLink")).Visible = false;
            LibraryGrid.Visible = false;
            try
            {
                string connectionString = ConfigurationManager.ConnectionStrings[
                    "BDD_PoliMusicConnectionString"].ConnectionString;
                DataTable songs = new BLL.Song(connectionString).Read();
                int count = songs == null ? 0 : songs.Rows.Count;
                ((Literal)form1.FindControl("songCount")).Text = count.ToString(
                    CultureInfo.GetCultureInfo("es-EC")) + (count == 1 ? " canción en tu biblioteca" : " canciones en tu biblioteca");
                if (count == 0)
                {
                    ShowMessage("Tu biblioteca está por comenzar", "Todavía no hay canciones disponibles. Vuelve cuando se hayan agregado canciones a la biblioteca.", false);
                    return;
                }
                // Reutilizar la ruta real de Adventure, sin alterar el DataTable ni SQL Server.
                if (UseAdventureAudioForLab)
                {
                    foreach (DataRow song in songs.Rows)
                    {
                        if (String.Equals(Convert.ToString(song["SONG_NAME"], CultureInfo.InvariantCulture), "Adventure", StringComparison.Ordinal))
                        {
                            labAudioUrl = ResolveSongUrl(Convert.ToString(song["SONG_PATH"], CultureInfo.InvariantCulture));
                            break;
                        }
                    }
                }
                LibraryGrid.PageIndex = Math.Min(LibraryGrid.PageIndex, (count - 1) / LibraryGrid.PageSize);
                LibraryGrid.DataSource = songs;
                LibraryGrid.DataBind();
                LibraryGrid.Visible = true;
            }
            catch (Exception)
            {
                // No enviar al navegador excepciones, consultas ni datos de conexión.
                ((Literal)form1.FindControl("songCount")).Text = "Biblioteca no disponible";
                ShowMessage("No pudimos cargar tus canciones", "Comprueba la conexión e inténtalo de nuevo. Si el problema continúa, consulta con la persona que administra PoliMusic.", true);
            }
        }

        private void ShowMessage(string title, string body, bool retry)
        {
            ((Panel)form1.FindControl("libraryMessage")).Visible = true;
            ((Literal)form1.FindControl("messageTitle")).Text = Encode(title);
            ((Literal)form1.FindControl("messageBody")).Text = Encode(body);
            ((HyperLink)form1.FindControl("retryLink")).Visible = retry;
        }

        protected void SongGrid_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            LibraryGrid.PageIndex = e.NewPageIndex;
            BindSongs();
        }

        protected void SongGrid_PreRender(object sender, EventArgs e)
        {
            if (LibraryGrid.HeaderRow != null) { LibraryGrid.HeaderRow.TableSection = TableRowSection.TableHeader; }
        }

        protected string Encode(object value)
        {
            return HttpUtility.HtmlEncode(Convert.ToString(value, CultureInfo.InvariantCulture));
        }

        protected string FormatPlays(object value)
        {
            if (value == null || value == DBNull.Value) { return "Sin registro"; }
            return Convert.ToInt32(value, CultureInfo.InvariantCulture).ToString("N0", CultureInfo.GetCultureInfo("es-EC"));
        }

        protected string RenderAudio(object path, object name)
        {
            string url = UseAdventureAudioForLab ? labAudioUrl : ResolveSongUrl(Convert.ToString(path, CultureInfo.InvariantCulture));
            if (url.Length == 0) { return "<span class=\"unavailable\">Archivo no disponible</span>"; }
            string songName = HttpUtility.HtmlAttributeEncode(Convert.ToString(name, CultureInfo.InvariantCulture));
            return "<audio controls=\"controls\" preload=\"none\" src=\"" + HttpUtility.HtmlAttributeEncode(url) +
                "\" data-song=\"" + songName + "\" aria-label=\"Reproducir " + songName +
                "\">Tu navegador no admite audio HTML5.</audio>" +
                "<span class=\"audio-error\" role=\"status\" hidden=\"hidden\">No se pudo reproducir el archivo. Comprueba la conexión o prueba otra canción.</span>";
        }

        private string ResolveSongUrl(string storedPath)
        {
            try
            {
                if (String.IsNullOrEmpty(storedPath)) { return String.Empty; }
                string path = Uri.UnescapeDataString(storedPath.Trim()).Replace('\\', '/');
                // No aceptar URLs remotas, parámetros, doble codificación ni navegación fuera de SongFiles.
                if (path.IndexOfAny(new char[] { '?', '#', '%', '\0' }) >= 0 || path.StartsWith("//", StringComparison.Ordinal)) { return String.Empty; }
                string root = Path.GetFullPath(Server.MapPath("~/SongFiles/")).TrimEnd(Path.DirectorySeparatorChar, Path.AltDirectorySeparatorChar);
                string rootPrefix = root + Path.DirectorySeparatorChar;
                string physical;
                if (path.Length > 2 && Char.IsLetter(path[0]) && path[1] == ':' && path[2] == '/')
                {
                    physical = Path.GetFullPath(path);
                }
                else
                {
                    if (path.IndexOf(':') >= 0) { return String.Empty; }
                    if (path.StartsWith("~/", StringComparison.Ordinal)) { path = path.Substring(2); }
                    else if (path.StartsWith("/", StringComparison.Ordinal))
                    {
                        string appPrefix = Request.ApplicationPath.TrimEnd('/') + "/";
                        if (!path.StartsWith(appPrefix, StringComparison.OrdinalIgnoreCase)) { return String.Empty; }
                        path = path.Substring(appPrefix.Length);
                    }
                    if (path.StartsWith("SongFiles/", StringComparison.OrdinalIgnoreCase)) { path = path.Substring(10); }
                    string[] segments = path.Split('/');
                    foreach (string segment in segments)
                    {
                        if (segment.Length == 0 || segment == "." || segment == "..") { return String.Empty; }
                    }
                    physical = Path.GetFullPath(Path.Combine(root, path.Replace('/', Path.DirectorySeparatorChar)));
                }
                if (!physical.StartsWith(rootPrefix, StringComparison.OrdinalIgnoreCase) ||
                    !String.Equals(Path.GetExtension(physical), ".mp3", StringComparison.OrdinalIgnoreCase) || !File.Exists(physical)) { return String.Empty; }
                // Rechazar enlaces y junctions que puedan salir de la carpeta autorizada.
                string current = physical;
                while (current.Length >= root.Length)
                {
                    if ((File.GetAttributes(current) & FileAttributes.ReparsePoint) != 0) { return String.Empty; }
                    if (String.Equals(current, root, StringComparison.OrdinalIgnoreCase)) { break; }
                    current = Path.GetDirectoryName(current);
                    if (String.IsNullOrEmpty(current)) { return String.Empty; }
                }
                string relative = physical.Substring(rootPrefix.Length).Replace(Path.DirectorySeparatorChar, '/');
                string[] parts = relative.Split('/');
                for (int i = 0; i < parts.Length; i++) { parts[i] = Uri.EscapeDataString(parts[i]); }
                return ResolveUrl("~/SongFiles/" + String.Join("/", parts));
            }
            catch (Exception)
            {
                // Un archivo ausente, inválido o sin permisos no bloquea las demás canciones.
                return String.Empty;
            }
        }
    }
}
