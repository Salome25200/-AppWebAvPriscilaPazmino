
using System;
using System.Configuration;
using System.Data;
using System.IO;
using System.Web;
using System.Web.UI;

namespace WebAppPoliMusicV3
{
    public partial class Song : System.Web.UI.Page
    {
        private readonly string strConnString =
            ConfigurationManager.ConnectionStrings[
                "BDD_PoliMusicConnectionString"
            ].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadSongs();
            }
        }

        private void LoadSongs()
        {
            try
            {
                BLL.PoliMusicV3.Song songBLL =
                    new BLL.PoliMusicV3.Song(strConnString);

                DataTable dtSongs = songBLL.Read();

                gvSongs.DataSource = dtSongs;
                gvSongs.DataBind();

                lblMessage.Text = string.Empty;
            }
            catch (Exception)
            {
                lblMessage.Text =
                    "No se pudieron cargar las canciones. " +
                    "Verifique la conexión con la base de datos.";
            }
        }

        protected string GetSongUrl(object songPath)
        {
            if (songPath == null ||
                songPath == DBNull.Value)
            {
                return string.Empty;
            }

            string ruta = songPath.ToString();

            if (string.IsNullOrWhiteSpace(ruta))
            {
                return string.Empty;
            }

            string fileName = Path.GetFileName(
                ruta.Replace("\\", "/"));

            if (!fileName.EndsWith(
                ".mp3",
                StringComparison.OrdinalIgnoreCase))
            {
                return string.Empty;
            }

            return ResolveUrl(
                "~/SongFiles/" +
                Uri.EscapeDataString(fileName));
        }
    }
}
