
using System;
using System.Data;
using System.Data.SqlClient;

namespace WebAppPoliMusicV2.DAL
{
    public class User
    {
        private string strConnectionString;

        public User(string strConnString)
        {
            strConnectionString = strConnString;
        }

        // Guardar un usuario
        public int Save(Entities.User user)
        {
            using (SqlConnection con = new SqlConnection(strConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    string sentence = "INSERT INTO [TBL_USER]([USERNAME], [PASSWORD], [EMAIL], [USER_TYPE]";

                    if (!string.IsNullOrEmpty(user.Birthday))
                    {
                        sentence += ", [BIRTHDAY]";
                    }

                    if (!string.IsNullOrEmpty(user.Photo))
                    {
                        sentence += ", [USER_PHOTO]";
                    }

                    sentence += ") VALUES(@USERNAME, @PASSWORD, @EMAIL, @USER_TYPE";

                    if (!string.IsNullOrEmpty(user.Birthday))
                    {
                        sentence += ", @BIRTHDAY";
                    }

                    if (!string.IsNullOrEmpty(user.Photo))
                    {
                        sentence += ", @USER_PHOTO";
                    }

                    sentence += ")";

                    cmd.CommandText = sentence;
                    cmd.Parameters.AddWithValue("@USERNAME", user.UserName);
                    cmd.Parameters.AddWithValue("@PASSWORD", user.Password);
                    cmd.Parameters.AddWithValue("@EMAIL", user.Email);
                    cmd.Parameters.AddWithValue("@USER_TYPE", user.UserType);

                    if (!string.IsNullOrEmpty(user.Birthday))
                    {
                        cmd.Parameters.AddWithValue("@BIRTHDAY", user.Birthday);
                    }

                    if (!string.IsNullOrEmpty(user.Photo))
                    {
                        cmd.Parameters.AddWithValue("@USER_PHOTO", user.Photo);
                    }

                    cmd.Connection = con;
                    con.Open();

                    return cmd.ExecuteNonQuery();
                }
            }
        }

        // Comprobar si existe un nombre de usuario
        public int CheckExistUser(string userName)
        {
            using (SqlConnection con = new SqlConnection(strConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText =
                        "SELECT [ID_USER] FROM [TBL_USER] WHERE [USERNAME] = @USERNAME";

                    cmd.Parameters.AddWithValue("@USERNAME", userName);
                    cmd.Connection = con;

                    con.Open();

                    object returnValue = cmd.ExecuteScalar();

                    return returnValue == null ? 0 : Convert.ToInt32(returnValue);
                }
            }
        }

        // Comprobar si existe un correo electrónico
        public int CheckExistEmail(string email)
        {
            using (SqlConnection con = new SqlConnection(strConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText =
                        "SELECT [ID_USER] FROM [TBL_USER] WHERE [EMAIL] = @EMAIL";

                    cmd.Parameters.AddWithValue("@EMAIL", email);
                    cmd.Connection = con;

                    con.Open();

                    object returnValue = cmd.ExecuteScalar();

                    return returnValue == null ? 0 : Convert.ToInt32(returnValue);
                }
            }
        }

        // Consultar todos los usuarios
        public DataTable Read()
        {
            DataTable dtUser = new DataTable();

            using (SqlConnection con = new SqlConnection(strConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand(
                    "SELECT [ID_USER], [USERNAME], [PASSWORD], [EMAIL], " +
                    "[BIRTHDAY], [USER_PHOTO], [USER_TYPE] FROM [TBL_USER]", con))
                {
                    using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                    {
                        sda.Fill(dtUser);
                        return dtUser;
                    }
                }
            }
        }

        // Actualizar un usuario
        public int Update(Entities.User user)
        {
            using (SqlConnection con = new SqlConnection(strConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    string sentence =
                        "UPDATE [TBL_USER] SET " +
                        "[USERNAME] = @USERNAME, " +
                        "[USER_TYPE] = @USER_TYPE";

                    if (!string.IsNullOrEmpty(user.Password))
                    {
                        sentence += ", [PASSWORD] = @PASSWORD";
                    }

                    sentence += ", [EMAIL] = @EMAIL";

                    if (!string.IsNullOrEmpty(user.Birthday))
                    {
                        sentence += ", [BIRTHDAY] = @BIRTHDAY";
                    }

                    if (!string.IsNullOrEmpty(user.Photo))
                    {
                        sentence += ", [USER_PHOTO] = @USER_PHOTO";
                    }

                    sentence += " WHERE [ID_USER] = @ID_USER";

                    cmd.CommandText = sentence;

                    cmd.Parameters.AddWithValue("@ID_USER", user.ID);
                    cmd.Parameters.AddWithValue("@USERNAME", user.UserName);
                    cmd.Parameters.AddWithValue("@USER_TYPE", user.UserType);
                    cmd.Parameters.AddWithValue("@EMAIL", user.Email);

                    if (!string.IsNullOrEmpty(user.Password))
                    {
                        cmd.Parameters.AddWithValue("@PASSWORD", user.Password);
                    }

                    if (!string.IsNullOrEmpty(user.Birthday))
                    {
                        cmd.Parameters.AddWithValue("@BIRTHDAY", user.Birthday);
                    }

                    if (!string.IsNullOrEmpty(user.Photo))
                    {
                        cmd.Parameters.AddWithValue("@USER_PHOTO", user.Photo);
                    }

                    cmd.Connection = con;
                    con.Open();

                    return cmd.ExecuteNonQuery();
                }
            }
        }

        // Eliminar un usuario
        public int Delete(int idUser)
        {
            using (SqlConnection con = new SqlConnection(strConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText =
                        "DELETE FROM [TBL_USER] WHERE [ID_USER] = @ID_USER";

                    cmd.Parameters.AddWithValue("@ID_USER", idUser);
                    cmd.Connection = con;

                    con.Open();

                    return cmd.ExecuteNonQuery();
                }
            }
        }

        // Autenticar un usuario
        public DataTable AuthenticateUser(string login, string password)
        {
            DataTable dtUser = new DataTable();

            using (SqlConnection con = new SqlConnection(strConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText =
                        "SELECT [ID_USER], [USERNAME], [PASSWORD], [EMAIL], " +
                        "[BIRTHDAY], [USER_PHOTO], [USER_TYPE] " +
                        "FROM [TBL_USER] " +
                        "WHERE [USERNAME] = @USERNAME AND [PASSWORD] = @PASSWORD";

                    cmd.Parameters.AddWithValue("@USERNAME", login);
                    cmd.Parameters.AddWithValue("@PASSWORD", password);

                    cmd.Connection = con;

                    using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                    {
                        sda.Fill(dtUser);
                        return dtUser;
                    }
                }
            }
        }
    }
}
