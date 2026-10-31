
using System;
using System.Data;
using System.Data.SqlClient;

namespace WebAppPoliMusicV2.DAL
{
    public class Song
    {
        private string strConnectionString;

        public Song(string strConnString)
        {
            strConnectionString = strConnString;
        }

        // Consultar todas las canciones
        public DataTable Read()
        {
            DataTable dtSong = new DataTable();

            using (SqlConnection con =
                new SqlConnection(strConnectionString))
            {
                string sql =
                    "SELECT [ID_SONG], [SONG_NAME], " +
                    "[SONG_PATH], [PLAYS] " +
                    "FROM [TBL_SONG] " +
                    "ORDER BY [SONG_NAME]";

                using (SqlCommand cmd =
                    new SqlCommand(sql, con))
                {
                    using (SqlDataAdapter sda =
                        new SqlDataAdapter(cmd))
                    {
                        sda.Fill(dtSong);
                        return dtSong;
                    }
                }
            }
        }
    }
}
