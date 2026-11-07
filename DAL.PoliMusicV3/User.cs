
using System;
using System.Data;
using System.Data.SqlClient;

namespace DAL.PoliMusicV3
{
    public class User
    {
        private string strConnectionString;

        public User(string strConnString)
        {
            strConnectionString = strConnString;
        }

        public int Save(EntityLayer.PoliMusicV3.User user)
        {
            using (SqlConnection con = new SqlConnection(strConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    string sentence = "INSERT INTO [TBL_USER]([USERNAME], [PASSWORD], [EMAIL], [USER_TYPE]";

                    if (!string.IsNullOrEmpty(user.Birthday))
                        sentence += ", [BIRTHDAY]";

                    if (!string.IsNullOrEmpty(user.Photo))
                        sentence += ", [USER_PHOTO]";

                    sentence += ") VALUES(@USERNAME, @PASSWORD, @EMAIL, @USER_TYPE";

                    if (!string.IsNullOrEmpty(user.Birthday))
                        sentence += ", @BIRTHDAY";

                    if (!string.IsNullOrEmpty(user.Photo))
                        sentence += ", @USER_PHOTO";

                    sentence += ")";

                    cmd.CommandText = sentence;
                    cmd.Parameters.AddWithValue("@USERNAME", user.UserName);
                    cmd.Parameters.AddWithValue("@PASSWORD", user.Password);
                    cmd.Parameters.AddWithValue("@EMAIL", user.Email);
                    cmd.Parameters.AddWithValue("@USER_TYPE", user.UserType);

                    if (!string.IsNullOrEmpty(user.Birthday))
                        cmd.Parameters.AddWithValue("@BIRTHDAY", user.Birthday);

                    if (!string.IsNullOrEmpty(user.Photo))
                        cmd.Parameters.AddWithValue("@USER_PHOTO", user.Photo);

                    cmd.Connection = con;
                    con.Open();
                    return cmd.ExecuteNonQuery();
                }
            }
        }

        public int CheckExistUser(string userName)
        {
            using (SqlConnection con = new SqlConnection(strConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand(
                    "SELECT [ID_USER] FROM [TBL_USER] WHERE [USERNAME] = @USERNAME", con))
                {
                    cmd.Parameters.AddWithValue("@USERNAME", userName);
                    con.Open();
                    object result = cmd.ExecuteScalar();
                    return result == null ? 0 : Convert.ToInt32(result);
                }
            }
        }

        public int CheckExistEmail(string email)
        {
            using (SqlConnection con = new SqlConnection(strConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand(
                    "SELECT [ID_USER] FROM [TBL_USER] WHERE [EMAIL] = @EMAIL", con))
                {
                    cmd.Parameters.AddWithValue("@EMAIL", email);
                    con.Open();
                    object result = cmd.ExecuteScalar();
                    return result == null ? 0 : Convert.ToInt32(result);
                }
            }
        }

        public DataTable Read()
        {
            DataTable dtUser = new DataTable();

            using (SqlConnection con = new SqlConnection(strConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand(
                    "SELECT [ID_USER], [USERNAME], [PASSWORD], [EMAIL], [BIRTHDAY], [USER_PHOTO], [USER_TYPE] FROM [TBL_USER]", con))
                {
                    using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                    {
                        sda.Fill(dtUser);
                        return dtUser;
                    }
                }
            }
        }

        public int Update(EntityLayer.PoliMusicV3.User user)
        {
            using (SqlConnection con = new SqlConnection(strConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    string sentence = "UPDATE [TBL_USER] SET " +
                                      "[USERNAME] = @USERNAME, " +
                                      "[USER_TYPE] = @USER_TYPE";

                    if (!string.IsNullOrEmpty(user.Password))
                        sentence += ", [PASSWORD] = @PASSWORD";

                    sentence += ", [EMAIL] = @EMAIL";

                    if (!string.IsNullOrEmpty(user.Birthday))
                        sentence += ", [BIRTHDAY] = @BIRTHDAY";

                    if (!string.IsNullOrEmpty(user.Photo))
                        sentence += ", [USER_PHOTO] = @USER_PHOTO";

                    sentence += " WHERE [ID_USER] = @ID_USER";

                    cmd.CommandText = sentence;
                    cmd.Parameters.AddWithValue("@ID_USER", user.ID);
                    cmd.Parameters.AddWithValue("@USERNAME", user.UserName);
                    cmd.Parameters.AddWithValue("@USER_TYPE", user.UserType);
                    cmd.Parameters.AddWithValue("@EMAIL", user.Email);

                    if (!string.IsNullOrEmpty(user.Password))
                        cmd.Parameters.AddWithValue("@PASSWORD", user.Password);

                    if (!string.IsNullOrEmpty(user.Birthday))
                        cmd.Parameters.AddWithValue("@BIRTHDAY", user.Birthday);

                    if (!string.IsNullOrEmpty(user.Photo))
                        cmd.Parameters.AddWithValue("@USER_PHOTO", user.Photo);

                    cmd.Connection = con;
                    con.Open();
                    return cmd.ExecuteNonQuery();
                }
            }
        }

        public int Delete(int idUserName)
        {
            using (SqlConnection con = new SqlConnection(strConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand(
                    "DELETE [TBL_USER] WHERE [ID_USER] = @ID_USER", con))
                {
                    cmd.Parameters.AddWithValue("@ID_USER", idUserName);
                    con.Open();
                    return cmd.ExecuteNonQuery();
                }
            }
        }

        public DataTable AuthenticateUser(string login, string password)
        {
            DataTable dtUser = new DataTable();

            using (SqlConnection con = new SqlConnection(strConnectionString))
            {
                string sentence =
                    "SELECT [ID_USER], [USERNAME], [PASSWORD], [EMAIL], " +
                    "[BIRTHDAY], [USER_PHOTO], [USER_TYPE] " +
                    "FROM [TBL_USER] " +
                    "WHERE [USERNAME] = @USERNAME AND [PASSWORD] = @PASSWORD";

                using (SqlCommand cmd = new SqlCommand(sentence, con))
                {
                    cmd.Parameters.AddWithValue("@USERNAME", login);
                    cmd.Parameters.AddWithValue("@PASSWORD", password);

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
