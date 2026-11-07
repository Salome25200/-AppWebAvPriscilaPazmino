
using System;
using System.Data;
using System.Data.SqlClient;

namespace DAL.PoliMusicV3
{
    public class Song
    {
        private readonly string strConnectionString;

        public Song(string strConnString)
        {
            strConnectionString = strConnString;
        }

        public DataTable Read()
        {
            DataTable dtSongs = new DataTable();

            using (SqlConnection con =
                new SqlConnection(strConnectionString))
            {
                string query =
                    "SELECT * FROM TBL_SONG";

                using (SqlCommand cmd =
                    new SqlCommand(query, con))
                {
                    using (SqlDataAdapter adapter =
                        new SqlDataAdapter(cmd))
                    {
                        adapter.Fill(dtSongs);
                    }
                }
            }

            return dtSongs;
        }
    }
}
