<%@ WebService Language="C#" Class="InvoiceSearch" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Web.Script;
using System.Collections.Generic;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[System.Web.Script.Services.ScriptService]
public class InvoiceSearch : System.Web.Services.WebService
{
    [WebMethod(EnableSession = true, Description = "")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string TPAInvoiceSearch(string FromDate, string ToDate, string MRNo, string IPNo, string InvNo, string PanelID)
    {
        string result = "0";
        string IsReject = "false";
        StringBuilder sb = new StringBuilder();
        DataTable dtAuthority = StockReports.GetAuthorization(Util.GetInt(Session["RoleID"]), Util.GetString(Session["ID"]));
        sb.Append("   SELECT IFNULL((select IF(FilePath<>'','Yes','No')IsRecUploaded from f_tpadocument_detail WHERE TPAInvNo=TI.TPAInvNo AND TPADocumentID=1),'No')IsRecUploaded,TI.TPAInvNo,TI.PanelID,pnl.Company_Name Panel,DATE_FORMAT(TI.TPAInvDate,'%d-%b-%Y')TPAInvDate,em.Name TPAInvCreatedBy,if(TI.IsActive=1,'YES','NO')IsActive, ");
        sb.Append("   pnl.Add1 PanelAddress1,pnl.Add2 PanelAddress2,pnl.Mobile,pnl.EmailID PanelEmail,pnl.Contact_Person PanelContactPerson, ");
        if (dtAuthority.Rows.Count > 0)
            if (dtAuthority.Rows[0]["IsReject"].ToString() == "1")
                IsReject = "true";      

        sb.Append(" '" + IsReject + "' IsReject");
        sb.Append("     FROM f_generate_tpa_invoice TI INNER JOIN Employee_Master em ON TI.UserID=em.Employee_ID ");
        sb.Append("     INNER JOIN f_panel_master pnl ON TI.PanelID =pnl.PanelID INNER JOIN tpa_invoice_detail Invd ON TI.TPAInvNo=Invd.TPAInvNo  ");
        sb.Append("     where TI.IsActive=1 ");

        if (MRNo != "")
            sb.Append(" AND Invd.PatientID= 'LSHHI" + MRNo + "' ");
        if (IPNo != "")
            sb.Append(" AND Invd.TransactionID=ISHHI" + IPNo + "");
        if (PanelID != "ALL")
            sb.Append(" AND TI.PanelID=" + PanelID + " ");
        if (InvNo != "")
            sb.Append(" AND TI.TPAInvNo='" + InvNo + "' ");

        sb.Append("   AND Date(TI.TPAInvDate)>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' AND Date(TI.TPAInvDate) <='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "' ");
        sb.Append("   GROUP BY TI.TPAInvNo ");                
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        return result;
    }
    
     [WebMethod(EnableSession = true, Description = "")]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string SearchFileUpload(string InvNo)
    {
           string result = "0";
           MySqlConnection con = new MySqlConnection();
           con = Util.GetMySqlCon();
           con.Open();
           MySqlTransaction MySqltrans = con.BeginTransaction(IsolationLevel.Serializable);
           try
           {                
                 StringBuilder sb = new StringBuilder();
                 sb.Append("  SELECT tdm.TPADocumentID,tdm.Document,IF(IFNULL(t.FilePath,'')='','false','true')STATUS,  ");
                 sb.Append("  IFNULL(t.FilePath,'') FilePath,IFNULL(FileName,'')FileName,IF(IFNULL(t.FilePath,'')='','false','true')FileStatus,IF(IFNULL(t.FilePath,'')='','true','false')BrowseStatus   ");
                 sb.Append("  FROM f_TPAdocumentMaster tdm  ");
                 sb.Append("  LEFT JOIN ( ");
                 sb.Append("         SELECT TPADocumentID,FilePath,FileName,TPAInvNo FROM f_TPAdocument_detail ");
                 sb.Append("         WHERE TPAInvNo='" + InvNo + "' AND IsActive=1 ");
                 sb.Append("  )t ON tdm.TPADocumentID = t.TPADocumentID WHERE tdm.IsActive=1 AND t.TPADocumentID IS NULL ");

                 DataTable dtInsert = StockReports.GetDataTable(sb.ToString());
                 if (dtInsert != null && dtInsert.Rows.Count > 0)
                 {
                     foreach (DataRow drDocs in dtInsert.Rows)
                     {
                         sb = new StringBuilder();
                         sb.Append("Insert into f_tpadocument_detail(TPADocumentID,TPAInvNo,UserID,IsActive)");
                         sb.Append("values(" + drDocs["TPADocumentID"].ToString() + ",'" + InvNo + "','" + HttpContext.Current.Session["ID"].ToString() + "',1)");
                         MySqlHelper.ExecuteNonQuery(MySqltrans, CommandType.Text, sb.ToString());
                     }
                 }

                 sb = new StringBuilder();
                 sb.Append("  SELECT tdm.TPADocumentID,tdm.Document,IF(IFNULL(t.FilePath,'')='','false','true')Status, ");
                 sb.Append("  IFNULL(t.FilePath,'') FilePath,IFNULL(FileName,'')FileName,IF(IFNULL(t.FilePath,'')='','false','true')FileStatus,IF(IFNULL(t.FilePath,'')='','true','false')BrowseStatus,UploadedDate,UploadedBy,ReceivingDate,IsRec ");
                 sb.Append("  FROM f_TPAdocumentMaster tdm  ");
                 sb.Append("  LEFT JOIN ( ");
                 sb.Append("           SELECT TPADocumentID,FilePath,FileName,TPAInvNo,DATE_FORMAT(UpdateDate,'%d-%b-%Y %I:%i %p')UploadedDate, ");
                 sb.Append("           (SELECT CONCAT(Title,' ',NAME) FROM Employee_Master WHERE Employee_ID=tdm.UpdatedBy)UploadedBy,IFNULL(DATE_FORMAT(ReceivingDate,'%d-%b-%Y'),'')ReceivingDate,IF(ReceivingDate is not null,'false','true')IsRec FROM f_TPAdocument_detail tdm ");
                 sb.Append("           WHERE TPAInvNo='" + InvNo + "' AND IsActive=1 ");
                 sb.Append("  )t ON tdm.TPADocumentID = t.TPADocumentID WHERE tdm.IsActive=1 ");
                 DataTable dt = StockReports.GetDataTable(sb.ToString());
                 if (dt.Rows.Count > 0)
                 {
                     return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
                 }
                                  
                 MySqltrans.Commit();
                 con.Close();
                 con.Dispose();
           }                  
           catch (Exception ex)
           {
                 MySqltrans.Rollback();
                 con.Close();
                 con.Dispose();
                 ClassLog cl = new ClassLog();
                 cl.errLog(ex);
                 result = "0";
           }
         
        return result;
    }

   
    
    
}