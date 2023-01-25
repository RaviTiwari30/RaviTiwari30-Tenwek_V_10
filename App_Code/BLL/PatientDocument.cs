using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.IO;
using System.Data;
/// <summary>
/// Summary description for PatientDocuments
/// </summary>
public static class PatientDocument
{




    public static void SaveDocument(object patientDocuments, string patientID)
    {
        try
        {
            if (string.IsNullOrEmpty(patientID))
                return;


            List<PatientDocuments> patientDocumentsDetails = new JavaScriptSerializer().ConvertToType<List<PatientDocuments>>(patientDocuments);
            if (patientDocumentsDetails.Count > 0)
            {
                if (All_LoadData.chkDocumentDrive() == 0)
                    throw new Exception("Please Create " + Resources.Resource.DocumentDriveName + " Drive");

                var pathname = All_LoadData.createDocumentFolder("OPDDocument", patientID.Replace("/", "_"));

                patientDocumentsDetails.ForEach(i =>
                {
                    string url = System.IO.Path.Combine(pathname + "\\" + i.name.Replace('/', '-') + ".jpeg");
                    if (File.Exists(url))
                    {
                        var files = Directory.GetFiles(pathname.ToString(), i.name.Replace('/', '-') + "*");
                        File.Move(url, System.IO.Path.Combine(pathname + "\\" + i.name.Replace('/', '-') + files.Length + ".jpeg"));
                    }
                    var strImage = i.data.Replace(i.data.Split(',')[0] + ",", "");
                    System.IO.File.WriteAllBytes(url, Convert.FromBase64String(strImage));

                });
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }


    public class PanelDocumentSaveResponse
    {
        private string _message;

        public string message
        {
            get { return _message; }
            set { _message = value; }
        }

        private List<PanelDocument> _panelDocuments;

        public List<PanelDocument> panelDocuments
        {
            get { return _panelDocuments; }
            set { _panelDocuments = value; }
        }


    }




    public static PanelDocumentSaveResponse SavePanelDocument(List<PanelDocument> panelDocuments, string transactionID, string patientID, int panelID)
    {
        var response = new PanelDocumentSaveResponse();
        response.panelDocuments = panelDocuments;
        try
        {




            if (All_LoadData.chkDocumentDrive() == 0)
            {
                response.message = "Please Create " + Resources.Resource.DocumentDriveName + " Drive";
                return response;
            }


            ExcuteCMD excuteCMD = new ExcuteCMD();
            var directoryPath = All_LoadData.createDocumentFolder("PanelDocuments", patientID.ToString().Replace("/", "_"), panelID.ToString());
            if (directoryPath == null)
            {
                response.message = AllGlobalFunction.errorMessage;
                return response;
            }

            string sqlUpdateCMD = "UPDATE f_paneldocument_patient SET PatientID=@patientID,FilePath=@filePath,FileName =@fileName,UpdatedBy = @updatedBy,UpdateDate =NOW(),ImageInBase64=@ImageInBase64 WHERE TransactionID =@TransactionID AND PanelID =@panelID AND PanelDocumentID = @panelDocumentID ";
            string sqlInsertCMD = "Insert into f_paneldocument_patient(TransactionID,PatientID,FilePath,FileName,IsActive,PanelID,PanelDocumentID,ImageInBase64) VALUES(@TransactionID,@patientID,@filePath,@fileName,1,@panelID,@panelDocumentID,@ImageInBase64) ";

            for (int i = 0; i < panelDocuments.Count; i++)
            {

                var strData = panelDocuments[i].DocumentBase64.Replace(panelDocuments[i].DocumentBase64.Split(',')[0] + ",", "");
                AttachmentType attachmentType = GetMimeType(strData);
                var filePath = Path.Combine(directoryPath.ToString(), panelDocuments[i].DocumentName + attachmentType.Extension);
                string uploadFilePath = filePath.Replace("\\", "''");
                uploadFilePath = uploadFilePath.Replace("'", "\\");
                int IsExistDocuments = Util.GetInt(StockReports.ExecuteScalar(" SELECT COUNT(*) FROM f_paneldocument_patient WHERE TransactionID='" + transactionID + "' AND PanelDocumentID='" + panelDocuments[i].ID + "' "));

                var panelDocument = new
                {
                    TransactionID = transactionID,
                    filePath = filePath,
                    fileName = panelDocuments[i].DocumentName,
                    updatedBy = HttpContext.Current.Session["ID"].ToString(),
                    panelID = panelID,
                    panelDocumentID = panelDocuments[i].ID,
                    patientID = patientID,
                    ImageInBase64 = panelDocuments[i].DocumentBase64
                };




                response.panelDocuments[i].DocumentSaveURLPath = filePath;
                if (IsExistDocuments > 0)
                excuteCMD.DML(sqlUpdateCMD, CommandType.Text, panelDocument);
                else
                    excuteCMD.DML(sqlInsertCMD, CommandType.Text, panelDocument);

                System.IO.File.WriteAllBytes(uploadFilePath, Convert.FromBase64String(strData));
                response.message = "Record Saved Successfully.";
            }

            return response;

        }
        catch (Exception ex)
        {

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            response.message = ex.Message;
            return response;
        }


    }



    public static string SaveFile(string filePathWithOutExt, string fileBase64)
    {
        try
        {
            var strData = fileBase64.Replace(fileBase64.Split(',')[0] + ",", "");
            AttachmentType attachmentType = GetMimeType(strData);
            var filePath = Path.Combine(filePathWithOutExt + attachmentType.Extension);
            string uploadFilePath = filePath.Replace("\\", "''");
            uploadFilePath = uploadFilePath.Replace("'", "\\");
            System.IO.File.WriteAllBytes(uploadFilePath, Convert.FromBase64String(strData));   
            return uploadFilePath;
        }
        catch (Exception ex)
        {

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return string.Empty;
        }

    }














    public static AttachmentType GetMimeType(string value)
    {
        if (String.IsNullOrEmpty(value))
            return new AttachmentType
            {
                FriendlyName = "Unknown",
                MimeType = "application/octet-stream",
                Extension = ""
            };

        var data = value.Substring(0, 5);

        switch (data.ToUpper())
        {
            case "IVBOR":
            case "/9J/4":
                return new AttachmentType
                {
                    FriendlyName = "Photo",
                    MimeType = "image/png",
                    Extension = ".png"
                };

            case "AAAAF":
                return new AttachmentType
                {
                    FriendlyName = "Video",
                    MimeType = "video/mp4",
                    Extension = ".mp4"
                };
            case "JVBER":
                return new AttachmentType
                {
                    FriendlyName = "Document",
                    MimeType = "application/pdf",
                    Extension = ".pdf"
                };

            default:
                return new AttachmentType
                {
                    FriendlyName = "Unknown",
                    MimeType = string.Empty,
                    Extension = ""
                };
        }
    }

    public class AttachmentType
    {
        public string MimeType { get; set; }
        public string FriendlyName { get; set; }
        public string Extension { get; set; }
    }

}