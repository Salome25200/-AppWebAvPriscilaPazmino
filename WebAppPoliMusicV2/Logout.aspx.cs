
using System;
using System.Web.Security;

namespace WebAppPoliMusicV2
{
    public partial class Logout : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Cerrar la autenticación
            FormsAuthentication.SignOut();

            // Eliminar los datos de la sesión
            Session.Clear();
            Session.Abandon();

            // Regresar a la página de inicio de sesión
            Response.Redirect("Login.aspx", true);
        }
    }
}
