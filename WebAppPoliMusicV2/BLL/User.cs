
using System;
using System.Data;

namespace WebAppPoliMusicV2.BLL
{
    public class User
    {
        private string strConnectionString;

        public User(string strConnString)
        {
            strConnectionString = strConnString;
        }

        // Guardar usuario
        public int Save(Entities.User user)
        {
            return new DAL.User(strConnectionString).Save(user);
        }

        // Consultar usuarios
        public DataTable Read()
        {
            return new DAL.User(strConnectionString).Read();
        }

        // Actualizar usuario
        public int Update(Entities.User user)
        {
            return new DAL.User(strConnectionString).Update(user);
        }

        // Eliminar usuario
        public int Delete(int id)
        {
            return new DAL.User(strConnectionString).Delete(id);
        }

        // Autenticar usuario
        public DataTable AuthenticateUser(string login, string password)
        {
            return new DAL.User(strConnectionString)
                .AuthenticateUser(login, password);
        }

        // Comprobar si existe el nombre de usuario
        public int CheckExistUser(string userName)
        {
            return new DAL.User(strConnectionString)
                .CheckExistUser(userName);
        }

        // Comprobar si existe el correo electrónico
        public int CheckExistEmail(string email)
        {
            return new DAL.User(strConnectionString)
                .CheckExistEmail(email);
        }

        // Validar usuarios o correos duplicados
        public string ValidationsDuplicated(Entities.User user)
        {
            int returnValue = CheckExistUser(user.UserName);

            if (returnValue != 0)
            {
                return "Username already registered!";
            }

            returnValue = CheckExistEmail(user.Email);

            if (returnValue != 0)
            {
                return "Email already used!";
            }

            return string.Empty;
        }
    }
}
