
using System;
using System.Data;
using System.Configuration;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebAppPoliMusicV3
{
    public partial class Login : System.Web.UI.Page
    {
        private readonly string strConnString =
            ConfigurationManager.ConnectionStrings[
                "BDD_PoliMusicConnectionString"
            ].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                // No colocar contraseñas automáticas.
                txtLogin.Text = string.Empty;
                txtPassword.Text = string.Empty;
                lblMessage.Text = string.Empty;
            }
        }

        protected void BtnLogin_Click(object sender, EventArgs e)
        {
            string login = txtLogin.Text.Trim();
            string password = txtPassword.Text;

            // Validar campos obligatorios.
            if (string.IsNullOrWhiteSpace(login) ||
                string.IsNullOrEmpty(password))
            {
                lblMessage.Text =
                    "Por favor, ingrese su usuario y contraseña.";
                return;
            }

            try
            {
                // Generar el hash de la contraseña.
                password =
                    EntityLayer.PoliMusicV3.Util.Hash
                    .GeneratePasswordHash(password);

                // Consultar las credenciales mediante BLL.
                DataTable dtUser =
                    new BLL.PoliMusicV3.User(strConnString)
                    .AuthenticateUser(login, password);

                if (dtUser == null || dtUser.Rows.Count == 0)
                {
                    lblMessage.Text =
                        "Usuario o contraseña incorrectos.";
                    return;
                }

                // Obtener los datos del usuario.
                DataRow row = dtUser.Rows[0];

                EntityLayer.PoliMusicV3.User user =
                    new EntityLayer.PoliMusicV3.User();

                user.ID = Convert.ToInt32(row["ID_USER"]);
                user.UserName = row["USERNAME"].ToString();
                user.Email = row["EMAIL"].ToString();
                user.Photo = row["USER_PHOTO"].ToString();
                user.Birthday = row["BIRTHDAY"].ToString();
                user.UserType = Convert.ToInt32(row["USER_TYPE"]);

                // Validar tipo de usuario.
                if (user.UserType !=
                    EntityLayer.PoliMusicV3.Util.Constants.ID_USER_NORMAL
                    &&
                    user.UserType !=
                    EntityLayer.PoliMusicV3.Util.Constants.ID_USER_ADMIN)
                {
                    lblMessage.Text =
                        "El tipo de usuario no es válido.";
                    return;
                }

                // Guardar el usuario en la sesión.
                Session[
                    EntityLayer.PoliMusicV3.Util.Constants.USER
                ] = user;

                // Crear la autenticación.
                FormsAuthentication.SetAuthCookie(login, false);

                // Redirigir según el tipo de usuario.
                if (user.UserType ==
                    EntityLayer.PoliMusicV3.Util.Constants.ID_USER_ADMIN)
                {
                    Response.Redirect(
                        "~/DesktopAdmin.aspx?uid=" + user.ID,
                        false);
                }
                else
                {
                    Response.Redirect("~/Default.aspx", false);
                }

                Context.ApplicationInstance.CompleteRequest();
            }
            catch (Exception)
            {
                lblMessage.Text =
                    "No se pudo iniciar sesión. " +
                    "Verifique la conexión con la base de datos.";
            }
        }

        protected void LinkButtonNewUser_Click(
            object sender, EventArgs e)
        {
            Response.Redirect("~/SignUp.aspx", false);
            Context.ApplicationInstance.CompleteRequest();
        }
    }
}
