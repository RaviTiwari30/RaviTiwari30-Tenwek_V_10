using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.Script.Serialization;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.IO;
public partial class Design_OPD_Mlc : System.Web.UI.Page
{

    #region Events

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtPatientID.Focus();
          
            ViewState["LoginType"] = Session["LoginType"].ToString();

            FillDateTime();
        }
        lblMsg.Text = "";
     
        
    }

    private void FillDateTime()
    {
        txtReport_sentToPolice_Date.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        txtReport_sentToPolice_Time.Text = DateTime.Now.ToString("h:mm tt");

        txtExamnation_Date.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        txtExamnation_time.Text = DateTime.Now.ToString("h:mm tt");

        txtArrivalHour_Date.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        txtArrivalHour_time.Text = DateTime.Now.ToString("h:mm tt");
    }
    #endregion

    #region DataLoad


     [WebMethod(EnableSession = true)]
    public static string getPatientDetails(string PatientId, string PatientName, string IPNO)
    {
        DataTable dt = new DataTable();
        try
        {
            StringBuilder str = new StringBuilder();
            str.Append(" SELECT DISTINCT  pm.PatientId,pmh.`TransactionID`,pmh.TransNo IPDNo, pm.gender,CONCAT(pm.title,' ',pm.pname)Pname,pm.gender,pm.PatientID,pnl.Company_Name PanelName,pnl.PanelID , ");
            str.Append("   CONCAT(pm.House_No,' ',pm.Street_Name,' ',pm.Locality,' ',pm.City)Address,pm.Relation,pm.RelationName   ");
            str.Append("  From patient_master pm  ");
            str.Append("  INNER JOIN patient_medical_history pmh ON pmh.`PatientID` = pm.`PatientID` ");
            str.Append("  INNER JOIN f_panel_master pnl ON pnl.PanelID= pm.PanelID ");
            str.Append("  WHERE  pm.CentreID=" + HttpContext.Current.Session["CentreID"].ToString() + " ");

            if (!String.IsNullOrEmpty(PatientId))
                 str.Append("AND pm.PatientID='" + PatientId + "'");
            else  if (!String.IsNullOrEmpty(IPNO))
                str.Append("AND pmh.TransNo='" + IPNO + "'");
            else  if (!String.IsNullOrEmpty(PatientName))
                str.Append("AND pm.pname like '%" + PatientName + "%'");
         
            str.Append(" and  pm.Active=1 limit 10 ");
             dt = StockReports.GetDataTable(str.ToString()).Copy();
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);

        }
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }


     [WebMethod(EnableSession = true)]
     public static string getPatientHistory(string PatientId, string PatientName, string IPNO)
     {
         DataTable dt = new DataTable();
         try
         {
             StringBuilder str = new StringBuilder();
             str.Append(" SELECT pmh.transno ipno,IFNULL(mlc.Id,'') ofpbid,pm.gender,CONCAT(pm.title,' ',pm.pname)pname,pm.PatientID,pnl.Company_Name PanelName,pnl.PanelID, ");
             str.Append("   CONCAT(pm.House_No,' ',pm.Street_Name,' ',pm.Locality,' ',pm.City)Address,pm.Relation,pm.RelationName,   ");
             str.Append("mlc.TransactionId, mlc.Caste,mlc.PoliceStation ,mlc.S_O,mlc.Occupation,  ");
             str.Append("mlc.Residence,mlc.RelativeName,  ");
             str.Append("mlc.Examnation,mlc.ArrivalHour,mlc.PoliceDocket,mlc.NameOfConstable,  ");
             str.Append("mlc.Report_sentToPoliceHour,mlc.NameOfInjuries,  ");
             str.Append("mlc.Portable_Duration_Of_Injuries,mlc.Weapons_Used_Or_Poison,  ");
             str.Append("mlc.Case_Of_Poisoning,mlc.Identification_Marks_1,mlc.Identification_Marks_2,  ");
             str.Append("mlc.Identification_Marks_3,mlc.imgSpaceForBase64,  ");
             str.Append("mlc.imgSpaceForPath,mlc.imgPrivatePartyBase64,  ");
             str.Append("mlc.imgPrivatePartyPath,mlc.imgMedicalOfficerBase64,  ");
             str.Append("mlc.imgMedicalOfficerPath,mlc.Particulars,mlc.EntryBy,  ");
             str.Append(" DATE_FORMAT(mlc.Report_sentToPolice_Date,'%d-%b-%Y')Report_sentToPolice_Date,TIME_FORMAT(mlc.Report_SentToPolice_Time,'%h:%i %p') Report_SentToPolice_Time,  ");
             str.Append(" DATE_FORMAT(mlc.Examnation_Date,'%d-%b-%Y')Examnation_Date,TIME_FORMAT(mlc.Examnation_time,'%h:%i %p') Examnation_time,  ");
             str.Append(" DATE_FORMAT(mlc.ArrivalHour_Date,'%d-%b-%Y')ArrivalHour_Date,TIME_FORMAT(mlc.ArrivalHour_time,'%h:%i %p') ArrivalHour_time,date_format(mlc.EntryDate,'%d-%b-%Y')EntryDate ");

             str.Append("  From patient_master pm  ");
             str.Append(" INNER JOIN patient_medical_history pmh ON pmh.`PatientID` = pm.`PatientID` ");
             str.Append(" inner join tbl_mlc mlc on pm.patientid=mlc.patientid and pmh.`transactionId`=mlc.transactionId and mlc.IsActive=1    ");
             str.Append("  INNER JOIN f_panel_master pnl ON pnl.PanelID= pmh.PanelID ");
             str.Append(" WHERE pm.Active=1 AND pm.CentreID=" + HttpContext.Current.Session["CentreID"].ToString() + " ");
          
             if (!string.IsNullOrEmpty(PatientId))
             str.Append(" AND pm.PatientID='" + PatientId + "' ");

             if (!string.IsNullOrEmpty(IPNO))
                 str.Append(" AND pmh.transno='" + IPNO + "' ");

             if (!string.IsNullOrEmpty(PatientName))
                 str.Append(" AND pm.pname='%" + PatientName + "%' ");


             dt = StockReports.GetDataTable(str.ToString()).Copy();
         }
         catch (Exception ex)
         {
             ClassLog cl = new ClassLog();
             cl.errLog(ex);

         }
         return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
     }


     [WebMethod(EnableSession = true)]
     public static string Save(string pid, string patientID, string transactionId, string S_O, string Caste, string PoliceStation, string Occupation, string Residence, string RelativeName, string PoliceDocket, string NameOfConstable, string NameOfInjuries, string Portable_Duration_Of_Injuries, string Weapons_Used_Or_Poison, string Case_Of_Poisoning, string Identification_Marks_1, string Identification_Marks_2, string Identification_Marks_3, string imgSpaceFor, string imgPrivateParty, string imgMedicalOfficer, string Particulars, string Examnation_Date, string Examnation_time, string ArrivalHour_Date, string ArrivalHour_time, string Report_sentToPolice_Date, string Report_sentToPolice_Time)
     {






        string imgSpaceForPath=string.Empty;
        string imgPrivatePartyPath=string.Empty;
        string imgMedicalOfficerPath=string.Empty;

         MySqlConnection con = Util.GetMySqlCon();
         con.Open();
         MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
         ExcuteCMD excuteCMD = new ExcuteCMD();
         try
         {
             
         if (All_LoadData.chkDocumentDrive() == 0)
         {
             return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Please Create " + Resources.Resource.DocumentDriveName + " Drive" });
         }


                imgSpaceForPath = uploadBase64Url(patientID, transactionId, "imgSpaceFor", imgSpaceFor);
                imgPrivatePartyPath = uploadBase64Url(patientID, transactionId, "imgPrivateParty", imgSpaceFor);
                imgMedicalOfficerPath = uploadBase64Url(patientID, transactionId, "imgMedicalOfficer", imgSpaceFor);

             if (string.IsNullOrEmpty(pid))
             {


                 excuteCMD.DML(tnx, " insert into tbl_mlc(TransactionId,patientID,S_O,Caste,PoliceStation,Occupation,Residence,RelativeName,PoliceDocket,NameOfConstable,NameOfInjuries,Portable_Duration_Of_Injuries,Weapons_Used_Or_Poison,Case_Of_Poisoning,Identification_Marks_1,Identification_Marks_2,Identification_Marks_3,imgSpaceForBase64,imgSpaceForPath,imgPrivatePartyBase64,imgPrivatePartyPath,imgMedicalOfficerBase64,imgMedicalOfficerPath,Particulars,EntryBy,Examnation_Date,Examnation_time,ArrivalHour_Date,ArrivalHour_time,Report_sentToPolice_Date,Report_sentToPolice_Time) values(@TransactionId,@patientID,@S_O,@Caste,@PoliceStation,@Occupation,@Residence,@RelativeName,@PoliceDocket,@NameOfConstable,@NameOfInjuries,@Portable_Duration_Of_Injuries,@Weapons_Used_Or_Poison,@Case_Of_Poisoning,@Identification_Marks_1,@Identification_Marks_2,@Identification_Marks_3,@imgSpaceForBase64,@imgSpaceForPath,@imgPrivatePartyBase64,@imgPrivatePartyPath,@imgMedicalOfficerBase64,@imgMedicalOfficerPath,@Particulars,@createdby,@Examnation_Date,@Examnation_time,@ArrivalHour_Date,@ArrivalHour_time,@Report_sentToPolice_Date,@Report_sentToPolice_Time) ", CommandType.Text, new
                 {

                     transactionId = transactionId,
                     patientID = patientID,
                     PoliceStation = PoliceStation,
                     Caste = Caste,
                     S_O = S_O,
                     Occupation = Occupation,
                     Residence = Residence,
                     RelativeName = RelativeName,
                     PoliceDocket = PoliceDocket,
                     NameOfConstable = NameOfConstable,
                   
                     NameOfInjuries = NameOfInjuries,
                     Portable_Duration_Of_Injuries = Portable_Duration_Of_Injuries,
                     Weapons_Used_Or_Poison = Weapons_Used_Or_Poison,
                     Case_Of_Poisoning = Case_Of_Poisoning,
                     Identification_Marks_1 = Identification_Marks_1,
                     Identification_Marks_2 = Identification_Marks_2,
                     Identification_Marks_3 = Identification_Marks_3,
                     imgSpaceForBase64 = imgSpaceFor,
                     imgSpaceForPath = imgSpaceForPath,
                     imgPrivatePartyBase64 = imgPrivateParty,
                     imgPrivatePartyPath = imgPrivatePartyPath,
                     imgMedicalOfficerBase64 = imgMedicalOfficer,
                     imgMedicalOfficerPath=imgMedicalOfficerPath,
                     Particulars=Particulars,
                     createdby = HttpContext.Current.Session["ID"].ToString(),
                     Examnation_Date = Util.GetDateTime(Examnation_Date).ToString("yyyy-MM-dd"),
                     Examnation_time = Util.GetDateTime(Examnation_time).ToString("HH:mm:ss"),
                     ArrivalHour_Date = Util.GetDateTime(ArrivalHour_Date).ToString("yyyy-MM-dd"),
                     ArrivalHour_time = Util.GetDateTime(ArrivalHour_time).ToString("HH:mm:ss"),
                     Report_sentToPolice_Date = Util.GetDateTime(Report_sentToPolice_Date).ToString("yyyy-MM-dd"),
                     Report_sentToPolice_Time = Util.GetDateTime(Report_sentToPolice_Time).ToString("HH:mm:ss")
                 });
                 tnx.Commit();


                 return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = " Save Successfully" });
             }
             else
             {


                 excuteCMD.DML(tnx, "UPDATE tbl_mlc set Examnation_Date=@Examnation_Date,Examnation_time=@Examnation_time,ArrivalHour_Date=@ArrivalHour_Date,ArrivalHour_time=@ArrivalHour_time,Report_sentToPolice_Date=@Report_sentToPolice_Date,Report_sentToPolice_Time=@Report_sentToPolice_Time, Caste=@Caste,PoliceStation=@PoliceStation, S_O=@S_O,Occupation = @Occupation, Residence = @Residence,  PoliceDocket = @PoliceDocket, NameOfConstable = @NameOfConstable,Portable_Duration_Of_Injuries = @Portable_Duration_Of_Injuries,Weapons_Used_Or_Poison = @Weapons_Used_Or_Poison,Case_Of_Poisoning = @Case_Of_Poisoning,Identification_Marks_1 = @Identification_Marks_1,Identification_Marks_2 = @Identification_Marks_2,Identification_Marks_3 = @Identification_Marks_3,imgSpaceForBase64 = @imgSpaceForBase64,imgSpaceForPath = @imgSpaceForPath,imgPrivatePartyBase64 = @imgPrivatePartyBase64,imgPrivatePartyPath = @imgPrivatePartyPath,imgMedicalOfficerBase64 = @imgSpaceForBase64,imgMedicalOfficerPath = @imgMedicalOfficerPath,Particulars = @Particulars, UpdatedDate=@updatedate,UpdatedBy=@updatedby WHERE id=@pid and transactionId=@transactionId ", CommandType.Text, new
                 {

                     transactionId = transactionId,
                     patientID = patientID,
                     S_O = S_O,
                     PoliceStation = PoliceStation,
                     Caste = Caste,
                     Occupation = Occupation,
                     Residence = Residence,
                     RelativeName = RelativeName,
                     PoliceDocket = PoliceDocket,
                     NameOfConstable = NameOfConstable,
                     NameOfInjuries = NameOfInjuries,
                     Portable_Duration_Of_Injuries = Portable_Duration_Of_Injuries,
                     Weapons_Used_Or_Poison = Weapons_Used_Or_Poison,
                     Case_Of_Poisoning = Case_Of_Poisoning,
                     Identification_Marks_1 = Identification_Marks_1,
                     Identification_Marks_2 = Identification_Marks_2,
                     Identification_Marks_3 = Identification_Marks_3,
                     imgSpaceForBase64 = imgSpaceFor,
                     imgSpaceForPath = imgSpaceForPath,
                     imgPrivatePartyBase64 = imgPrivateParty,
                     imgPrivatePartyPath = imgPrivatePartyPath,
                     imgMedicalOfficerBase64 = imgMedicalOfficer,
                     imgMedicalOfficerPath = imgMedicalOfficerPath,
                     Particulars = Particulars,
                     pid = pid,
                     updatedate = Util.GetDateTime(DateTime.Now),
                     updatedby = HttpContext.Current.Session["ID"].ToString(),
                     Examnation_Date = Util.GetDateTime(Examnation_Date).ToString("yyyy-MM-dd"),
                     Examnation_time = Util.GetDateTime(Examnation_time).ToString("HH:mm:ss"),
                     ArrivalHour_Date = Util.GetDateTime(ArrivalHour_Date).ToString("yyyy-MM-dd"),
                     ArrivalHour_time = Util.GetDateTime(ArrivalHour_time).ToString("HH:mm:ss"),
                     Report_sentToPolice_Date = Util.GetDateTime(Report_sentToPolice_Date).ToString("yyyy-MM-dd"),
                     Report_sentToPolice_Time = Util.GetDateTime(Report_sentToPolice_Time).ToString("HH:mm:ss")
                 });
                 tnx.Commit();


                 return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = " Update Successfully" });
             }








         }
         catch (Exception ex)
         {
             tnx.Rollback();
             ClassLog cl = new ClassLog();
             cl.errLog(ex);
             return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Record Not Saved", message = ex.Message });
         }
         finally
         {
             tnx.Dispose();
             con.Close();
             con.Dispose();
         }
     }


     [WebMethod(EnableSession = true)]
     public static string cancelRecord(string pid, string patientID)
     {


         MySqlConnection con = Util.GetMySqlCon();
         con.Open();
         MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
         ExcuteCMD excuteCMD = new ExcuteCMD();
         try
         {

             if (!string.IsNullOrEmpty(pid))
             {
                 excuteCMD.DML(tnx, "UPDATE tbl_mlc pmh SET pmh.IsActive=0 WHERE pmh.id=@pid and pmh.patientID=@patientID ", CommandType.Text, new
                 {
                     patientID = patientID,
                     pid = pid
                 });


             }
             tnx.Commit();
             return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = " Record Deleted Successfully" });
         }
         catch (Exception ex)
         {
             tnx.Rollback();
             ClassLog cl = new ClassLog();
             cl.errLog(ex);
             return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Record Not Saved", message = ex.Message });
         }
         finally
         {
             tnx.Dispose();
             con.Close();
             con.Dispose();
         }
     }



    
     [WebMethod(EnableSession = true)]
     public static string printCard(string pid)
     {

         string Output = string.Empty;
         DataTable dt = new DataTable();
         try
         {


             StringBuilder str = new StringBuilder();
             str.Append(" SELECT IFNULL(mlc.Id,'') ofpbid,pm.gender,CONCAT(pm.title,' ',pm.pname)pname,pm.PatientID,pnl.Company_Name PanelName,pnl.PanelID, ");
             str.Append(" pm.age,CONCAT(pm.House_No,' ',pm.Street_Name,' ',pm.Locality,' ',pm.City)Address,pm.Relation,pm.RelationName,''  MLCNO,'' MLCTYPE,if(pmh.dateofAdmit<>'0001-01-01',DATE_FORMAT(dateofAdmit,'%d-%b-%Y'),'') DOA,IF(pmh.DateofDischarge<>'0001-01-01',DATE_FORMAT(pmh.DateofDischarge,'%d-%b-%Y'),'') DOD, ");
             str.Append(" date_format(mlc.EntryDate,'%d-%b-%Y')Date,mlc.TransactionId,mlc.S_O,mlc.Occupation,  ");
             str.Append(" mlc.Caste Cast,mlc.Residence,mlc.PoliceStation,mlc.RelativeName,  ");
             str.Append(" CONCAT(DATE_FORMAT(mlc.Examnation_Date,'%d-%b-%Y'),' ',TIME_FORMAT(mlc.Examnation_time,'%h:%i %p'))   Examnation,CONCAT(DATE_FORMAT(mlc.ArrivalHour_Date,'%d-%b-%Y'),' ',TIME_FORMAT(mlc.ArrivalHour_time,'%h:%i %p')) ArrivalHour,mlc.PoliceDocket,mlc.NameOfConstable,  ");
             str.Append(" concat(DATE_FORMAT(mlc.Report_sentToPolice_Date,'%d-%b-%Y'),' ',TIME_FORMAT(mlc.Report_SentToPolice_Time,'%h:%i %p')) Report_sentToPoliceHour,mlc.NameOfInjuries,  ");
             str.Append(" mlc.Portable_Duration_Of_Injuries,mlc.Weapons_Used_Or_Poison,  ");
             str.Append(" mlc.Case_Of_Poisoning,mlc.Identification_Marks_1,mlc.Identification_Marks_2,  ");
             str.Append(" mlc.Identification_Marks_3,mlc.imgSpaceForBase64,  ");
             str.Append(" mlc.imgPrivatePartyBase64,  ");
             str.Append(" mlc.imgMedicalOfficerBase64,  ");
             str.Append(" mlc.Particulars,mlc.EntryBy  ");
             str.Append("  From patient_master pm  ");
             str.Append(" INNER JOIN patient_medical_history pmh ON pmh.`PatientID` = pm.`PatientID` ");
             str.Append(" inner join tbl_mlc mlc on pm.patientid=mlc.patientid and pmh.`transactionId`=mlc.transactionId and mlc.IsActive=1    ");
             str.Append("  INNER JOIN f_panel_master pnl ON pnl.PanelID= pmh.PanelID ");
             str.Append(" WHERE pm.Active=1 and mlc.Id='" + pid + "' ");


             dt = StockReports.GetDataTable(str.ToString()).Copy();

             dt.Columns.Add("imgSpaceForBlob", System.Type.GetType("System.Byte[]"));
             dt.Columns.Add("imgPrivatePartyBlob", System.Type.GetType("System.Byte[]"));
             dt.Columns.Add("imgMedicalOfficerBlob", System.Type.GetType("System.Byte[]"));


             if (dt.Rows.Count > 0)
             {
                 dt.Rows[0]["imgSpaceForBlob"] = Convert.FromBase64String( dt.Rows[0]["imgSpaceForBase64"].ToString().Replace(dt.Rows[0]["imgSpaceForBase64"].ToString().Split(',')[0] + ",", ""));
                 dt.Rows[0]["imgPrivatePartyBlob"] =  Convert.FromBase64String(dt.Rows[0]["imgPrivatePartyBase64"].ToString().Replace(dt.Rows[0]["imgPrivatePartyBase64"].ToString().Split(',')[0] + ",", ""));
                 dt.Rows[0]["imgMedicalOfficerBlob"] = Convert.FromBase64String(dt.Rows[0]["imgMedicalOfficerBase64"].ToString().Replace(dt.Rows[0]["imgMedicalOfficerBase64"].ToString().Split(',')[0] + ",", ""));


                 DataSet ds = new DataSet();
                 ds.Tables.Add(dt.Copy());
                 ds.Tables[0].TableName = "mlctable";

                 //ds.WriteXmlSchema(@"E:\NewReport.xml");

                 HttpContext.Current.Session["ReportName"] = "MLCCardPrint";
                 HttpContext.Current.Session["ds"] = ds;
                 Output = "../../Design/common/Commonreport.aspx";
             }

         }
         catch (Exception ex)
         {
             ClassLog cl = new ClassLog();
             cl.errLog(ex);

         }
         return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = "Record Not Saved", Output = Output });
    
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


     public static string uploadBase64Url(string patientID, string transactionId, string DocumentName, string imagebase64)
     {

        try
        {
         var directoryPath = All_LoadData.createDocumentFolder("MLCDocument", patientID.ToString().Replace("/", "_"), transactionId.ToString());
         if (directoryPath == null)
         {
             return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = AllGlobalFunction.errorMessage });
         }
         var strData = imagebase64.Replace(imagebase64.Split(',')[0] + ",", "");
         AttachmentType attachmentType = GetMimeType(strData);
         var filePath = Path.Combine(directoryPath.ToString(),DocumentName + attachmentType.Extension);
         string uploadFilePath = filePath.Replace("\\", "''");
         uploadFilePath = uploadFilePath.Replace("'", "\\");
         System.IO.File.WriteAllBytes(uploadFilePath, Convert.FromBase64String(strData));

         return filePath;
        }
        catch (Exception ex)
        {

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return string.Empty;
        }
     }
    #endregion

   
}
