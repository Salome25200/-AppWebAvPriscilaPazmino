
using System;
using System.Data;
using System.Configuration;
using System.Web.Security;
using System.Web.UI;

namespace WebAppPoliMusicV2
{
    public partial class Login : System.Web.UI.Page
    {
        string strConnString =
            ConfigurationManager.ConnectionStrings[
                "BDD_PoliMusicConnectionString"
            ].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
#if DEBUG
                
                txtLogin.Text = "priscila.pazmino";
#endif

                lblMessage.Text = string.Empty;
            }
        }

        protected void BtnLogin_Click(object sender, EventArgs e)
        {
            string login = txtLogin.Text;
            string password = txtPassword.Text;

            if (string.IsNullOrEmpty(login) ||
                string.IsNullOrEmpty(password))
            {
                lblMessage.Text =
                    "Please, write a login/password.";
                return;
            }

            // Generar el hash de la contraseña
            password = Util.Hash.GeneratePasswordHash(password);

            // Consultar el usuario en la base de datos
            DataTable dtUser = new BLL.User(strConnString)
                .AuthenticateUser(login, password);

            if (dtUser != null && dtUser.Rows.Count > 0)
            {
                Entities.User user = new Entities.User();

                user.ID = Convert.ToInt32(
                    dtUser.Rows[0]["ID_USER"]);

                user.UserName = login;

                user.Photo =
                    dtUser.Rows[0]["USER_PHOTO"].ToString();

                user.Email =
                    dtUser.Rows[0]["EMAIL"].ToString();

                user.Birthday =
                    dtUser.Rows[0]["BIRTHDAY"].ToString();

                user.UserType = Convert.ToInt32(
                    dtUser.Rows[0]["USER_TYPE"]);

                if (user.UserType ==
                    Util.Constants.ID_USER_NORMAL)
                {
                    Session[Util.Constants.USER] = user;

                    FormsAuthentication.RedirectFromLoginPage(
                        login, true);
                }
                else if (user.UserType ==
                    Util.Constants.ID_USER_ADMIN)
                {
                    Session[Util.Constants.USER] = user;

                    FormsAuthentication.SetAuthCookie(
                        login, true);

                    Response.Redirect(
                        "~/DesktopAdmin.aspx?uid=" + user.ID,
                        true);
                }
                else
                {
                    lblMessage.Text =
                        "Login/password incorrect, try again.";
                    return;
                }
            }
            else
            {
                lblMessage.Text =
                    "Login/password incorrect, try again.";
                return;
            }
        }

        protected void LinkButtonNewUser_Click(
            object sender, EventArgs e)
        {
            Response.Redirect("SignUp.aspx", true);
        }
    }
}
