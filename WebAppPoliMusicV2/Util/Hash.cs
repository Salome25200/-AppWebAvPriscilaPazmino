
using System;
using System.Text;
using System.Security.Cryptography;

namespace WebAppPoliMusicV2.Util
{
    public class Hash
    {
        // Genera un hash SHA1 de la contraseña
        public static string GeneratePasswordHash(string input)
        {
            using (SHA1Managed sha1 = new SHA1Managed())
            {
                byte[] hash = sha1.ComputeHash(
                    Encoding.UTF8.GetBytes(input));

                StringBuilder sb = new StringBuilder(hash.Length * 2);

                foreach (byte b in hash)
                {
                    sb.Append(b.ToString("X2"));
                }

                return sb.ToString();
            }
        }

        // Genera un hash PBKDF2 con una sal aleatoria
        public static string HashPassword(string password)
        {
            byte[] salt = new byte[16];

            RNGCryptoServiceProvider rng = new RNGCryptoServiceProvider();
            rng.GetBytes(salt);

            Rfc2898DeriveBytes pbkdf2 =
                new Rfc2898DeriveBytes(password, salt, 100000);

            byte[] hash = pbkdf2.GetBytes(20);

            byte[] hashBytes = new byte[36];

            Array.Copy(salt, 0, hashBytes, 0, 16);
            Array.Copy(hash, 0, hashBytes, 16, 20);

            return Convert.ToBase64String(hashBytes);
        }
    }
}
