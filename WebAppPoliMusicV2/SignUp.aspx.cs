
using System;
using System.Configuration;
using System.Globalization;
using System.Text.RegularExpressions;
using System.Web.UI;

namespace WebAppPoliMusicV2
{
    public partial class SignUp : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnSumbit_Click(object sender, EventArgs e)
        {
            string userName = txtUserName.Text.Trim();
            string password = txtPassword.Text;
            string confirmPassword = txtConfirmPassword.Text;
            string email = txtEmail.Text.Trim();
            string birthday = string.Empty;

            // Validar fecha de nacimiento
            if (!string.IsNullOrEmpty(txtBirthDate.Text))
            {
                DateTime date;

                if (DateTime.TryParseExact(
                    txtBirthDate.Text,
                    "dd/MM/yyyy",
                    CultureInfo.InvariantCulture,
                    DateTimeStyles.None,
                    out date))
                {
                    birthday = date.ToString("yyyy-MM-dd");
                }
                else
                {
                    lblMessage.Text =
                        "Invalid birth date. Use dd/MM/yyyy.";
                    return;
                }
            }

            // Validar contraseña de confirmación
            if (password != confirmPassword)
            {
                lblMessage.Text =
                    "Passwords do not match!";
                return;
            }

            // Crear entidad de usuario
            Entities.User user = new Entities.User();

            user.UserName = userName;
            user.Email = email;
            user.Password = password;
            user.Birthday = birthday;
            user.UserType = Util.Constants.ID_USER_NORMAL;

            // Validar campos obligatorios
            string messageValidations =
                UserFieldsRequiredValidations(user);

            if (messageValidations != string.Empty)
            {
                lblMessage.Text = messageValidations;
                return;
            }

            // Obtener cadena de conexión
            string strConnString =
                ConfigurationManager.ConnectionStrings[
                    "BDD_PoliMusicConnectionString"
                ].ConnectionString;

            // Validar usuario y correo duplicados
            messageValidations =
                new BLL.User(strConnString)
                .ValidationsDuplicated(user);

            if (messageValidations != string.Empty)
            {
                lblMessage.Text = messageValidations;
                return;
            }

            // Configurar fotografía
            string strImageFolder =
                ConfigurationManager.AppSettings["userPhotoPath"];

            string newImageName =
                userName.Replace(" ", string.Empty);

            // Evitar caracteres inválidos en el nombre del archivo
            foreach (char invalidChar in
                System.IO.Path.GetInvalidFileNameChars())
            {
                newImageName = newImageName.Replace(
                    invalidChar.ToString(), "");
            }

            if (newImageName == "." ||
                newImageName == "..")
            {
                lblMessage.Text = "Invalid username.";
                return;
            }

            string extension = ".jpg";

            if (fupPhoto.HasFile)
            {
                extension = System.IO.Path.GetExtension(
                    fupPhoto.FileName).ToLower();

                messageValidations =
                    new FileManagement().SaveImageOnServer(
                        fupPhoto,
                        strImageFolder,
                        newImageName);
            }
            else
            {
                messageValidations =
                    new FileManagement().SaveDefaultImageOnServer(
                        strImageFolder,
                        newImageName);
            }

            if (messageValidations != string.Empty)
            {
                lblMessage.Text = messageValidations;
                return;
            }

            user.Photo =
                strImageFolder + newImageName + extension;

            // Generar hash de contraseña
            user.Password =
                Util.Hash.GeneratePasswordHash(password);

            // Guardar usuario en la base de datos
            int result =
                new BLL.User(strConnString).Save(user);

            if (result > 0)
            {
                lblMessage.Text =
                    "User registered successfully! " +
                    "Please go to the login page.";
            }
            else
            {
                lblMessage.Text =
                    "User could not be registered.";
            }
        }

        // Validar campos obligatorios
        public string UserFieldsRequiredValidations(
            Entities.User user)
        {
            if (string.IsNullOrEmpty(user.UserName))
            {
                return "Username is required!";
            }

            if (string.IsNullOrEmpty(user.Email))
            {
                return "Email is required!";
            }

            if (string.IsNullOrEmpty(user.Password))
            {
                return "Password is required!";
            }

            if (!IsValidEmail(user.Email))
            {
                return "Email is not valid!";
            }

            return string.Empty;
        }

        // Validar formato del correo electrónico
        public static bool IsValidEmail(string email)
        {
            if (string.IsNullOrEmpty(email))
            {
                return false;
            }

            try
            {
                return Regex.IsMatch(
                    email,
                    @"^[^@\s]+@[^@\s]+\.[^@\s]+$",
                    RegexOptions.IgnoreCase);
            }
            catch (Exception)
            {
                return false;
            }
        }
    }
}
