
using System;
using System.IO;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;

namespace WebAppPoliMusicV2
{
    public class FileManagement : System.Web.UI.Page
    {
        // Guardar una imagen en el servidor
        public string SaveImageOnServer(
            FileUpload fileUpload,
            string strFolder,
            string newFileName)
        {
            try
            {
                if (!fileUpload.HasFile)
                {
                    return "Image is required!!";
                }

                // Validar el tipo de imagen
                if (!(fileUpload.PostedFile.ContentType == "image/jpeg" ||
                      fileUpload.PostedFile.ContentType == "image/jpg" ||
                      fileUpload.PostedFile.ContentType == "image/png"))
                {
                    return "Only JPEG or PNG files are accepted!";
                }

                string fileExt =
                    Path.GetExtension(fileUpload.FileName).ToLower();

                if (!(fileExt == ".jpg" ||
                      fileExt == ".jpeg" ||
                      fileExt == ".png"))
                {
                    return "Only JPEG or PNG extensions are allowed!";
                }

                // Tamaño máximo: 10 MB
                if (fileUpload.PostedFile.ContentLength > 10485760)
                {
                    return "The file must be less than 10 MB!";
                }

                string strServerFolder = Server.MapPath(strFolder);

                string strFileName;

                if (!string.IsNullOrEmpty(newFileName))
                {
                    strFileName = Path.GetFileName(newFileName);
                }
                else
                {
                    strFileName =
                        Path.GetFileNameWithoutExtension(
                            fileUpload.FileName);
                }

                if (!Directory.Exists(strServerFolder))
                {
                    Directory.CreateDirectory(strServerFolder);
                }

                string newServerFileNameWithExtension =
                    Path.Combine(
                        strServerFolder,
                        strFileName + fileExt);

                fileUpload.SaveAs(newServerFileNameWithExtension);

                return string.Empty;
            }
            catch (Exception ex)
            {
                return "The image could not be uploaded: " +
                       ex.Message;
            }
        }

        // Guardar una imagen predeterminada
        public string SaveDefaultImageOnServer(
            string strFolder,
            string newFileName)
        {
            try
            {
                string strServerFolder = Server.MapPath(strFolder);

                string serverFileNameWithExtension =
                    Path.Combine(strServerFolder, "default.jpg");

                string serverNewFileNameWithExtension =
                    Path.Combine(
                        strServerFolder,
                        Path.GetFileName(newFileName) + ".jpg");

                if (!Directory.Exists(strServerFolder))
                {
                    Directory.CreateDirectory(strServerFolder);
                }

                if (!File.Exists(serverFileNameWithExtension))
                {
                    return "Default image was not found!";
                }

                File.Copy(
                    serverFileNameWithExtension,
                    serverNewFileNameWithExtension,
                    true);

                return string.Empty;
            }
            catch (Exception ex)
            {
                return "The default image could not be saved: " +
                       ex.Message;
            }
        }

        // Guardar una canción MP3 en el servidor
        public string SaveSongOnServer(
            FileUpload fileUpload,
            string strFolder,
            string newFileName)
        {
            try
            {
                if (!fileUpload.HasFile)
                {
                    return "Select a song file first!";
                }

                // Validar el tipo de archivo
                if (!(fileUpload.PostedFile.ContentType == "audio/mpeg" ||
                      fileUpload.PostedFile.ContentType == "audio/mpeg3" ||
                      fileUpload.PostedFile.ContentType == "audio/mp3"))
                {
                    return "The selected file must be MP3!";
                }

                string strFileNameExtension =
                    Path.GetExtension(fileUpload.FileName).ToLower();

                if (strFileNameExtension != ".mp3")
                {
                    return "Only .mp3 extensions are allowed!";
                }

                // Obtener el tamaño máximo desde Web.config
                string strMaxFileSize =
                    ConfigurationManager.AppSettings["maxSongLength"];

                int maxFileSize =
                    string.IsNullOrEmpty(strMaxFileSize)
                    ? 1024
                    : Convert.ToInt32(strMaxFileSize);

                if (fileUpload.PostedFile.ContentLength > maxFileSize)
                {
                    return "MP3 file is too large. Maximum size: " +
                           maxFileSize / 1024 + " KB";
                }

                string strFileName;

                if (!string.IsNullOrEmpty(newFileName))
                {
                    strFileName = Path.GetFileName(newFileName);
                }
                else
                {
                    strFileName =
                        Path.GetFileNameWithoutExtension(
                            fileUpload.FileName);
                }

                string strServerFolder = Server.MapPath(strFolder);

                if (!Directory.Exists(strServerFolder))
                {
                    Directory.CreateDirectory(strServerFolder);
                }

                string newServerFileNameWithExtension =
                    Path.Combine(
                        strServerFolder,
                        strFileName + strFileNameExtension);

                fileUpload.SaveAs(newServerFileNameWithExtension);

                return string.Empty;
            }
            catch (Exception ex)
            {
                return "The MP3 file could not be uploaded: " +
                       ex.Message;
            }
        }
    }
}
