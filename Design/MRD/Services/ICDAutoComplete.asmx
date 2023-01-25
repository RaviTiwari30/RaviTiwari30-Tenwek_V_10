<%@ WebService Language="C#" Class="ICDAutoComplete" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Web.Script;
using System.Data;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Text;
using MySql.Data.MySqlClient;
using System.Collections.Generic;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
// [System.Web.Script.Services.ScriptService]
[ScriptService]
public class ICDAutoComplete  : System.Web.Services.WebService {

    [WebMethod]
    public string HelloWorld() {
        return "Hello World";
    }
    [WebMethod]
    public string[] GetCompletionList(string prefixText, int count)
    {
        string sql = "Select who_full_desc from icd_10_new Where ISActive=1 AND who_full_desc like '" + prefixText + "%'";
        DataTable ICD = StockReports.GetDataTable(sql);
        string[] items = new string[ICD.Rows.Count];
        int i = 0;
        foreach (DataRow dr in ICD.Rows)
        {
            items.SetValue(dr["who_full_desc"].ToString(), i);
            i++;
        }
        return items;
    }
    [WebMethod]
    public string[] GetCompletionListCode(string prefixText, int count)
    {
        string sql = "Select ICD10_Code from icd_10_new Where ISActive=1 AND ICD10_Code like '" + prefixText + "%'";
        DataTable ICD = StockReports.GetDataTable(sql);
        string[] items = new string[ICD.Rows.Count];
        int i = 0;
        foreach (DataRow dr in ICD.Rows)
        {
            items.SetValue(dr["ICD10_Code"].ToString(), i);
            i++;
        }
        return items;
    }
    [WebMethod]
    public string GetFileStatus(string TransactionID, string Status,string PatientID,string type)
    {
       
        StringBuilder sb = new StringBuilder();
        //if (type == "IPD")
       // {
            if (Status.ToUpper() != "ALL")
            {
                sb.Append("        SELECT mfm.FileID,mfm.PatientID as PID,mfm.TransactionID,IF(pmh.Type<>'IPD','',pmh.Transno)TransNO,  ");
                sb.Append("        (SELECT NAME FROM mrd_room_master WHERE RmID=mfm.RmID)RoomName, ");
                sb.Append("        (SELECT NAME FROM mrd_almirah_master WHERE AlmId= mfm.AlmID)Almirah, ");
                sb.Append("        (SELECT NAME FROM mrd_document_master WHERE DocumentID=mfd.DocumentID)Document,mfd.Status,mfs.Description FROM mrd_file_master mfm  ");
                sb.Append("        INNER JOIN mrd_file_detail mfd ON mfm.FileID=mfd.FileID inner join mrd_file_status mfs on mfs.FileStatus=mfd.Status INNER JOIN patient_medical_history pmh ON pmh.TransactionID=mfm.Transactionid  WHERE mfm.TransactionID='" + TransactionID + "' AND mfd.Status in ('" + Status + "') order by mfd.Status");
            }
            else
            {
                sb.Append("        SELECT mfm.FileID,mfm.PatientID as PID,mfm.TransactionID, IF(pmh.Type<>'IPD','',pmh.Transno)TransNO, ");
                sb.Append("        (SELECT NAME FROM mrd_room_master WHERE RmID=mfm.RmID)RoomName, ");
                sb.Append("        (SELECT NAME FROM mrd_almirah_master WHERE AlmId= mfm.AlmID)Almirah, ");
                sb.Append("        (SELECT NAME FROM mrd_document_master WHERE DocumentID=mfd.DocumentID)Document,mfd.Status,mfs.Description FROM mrd_file_master mfm  ");
                sb.Append("        INNER JOIN mrd_file_detail mfd ON mfm.FileID=mfd.FileID inner join mrd_file_status mfs on mfs.FileStatus=mfd.Status INNER JOIN patient_medical_history pmh ON pmh.TransactionID=mfm.Transactionid WHERE mfm.TransactionID='" + TransactionID + "' order by mfd.Status");

            }
        //}
        //else
        //{
        //    if (Status.ToUpper() != "ALL")
        //    {
        //        sb.Append("        SELECT mfm.FileID,mfm.PatientID as PID,REPLACE(mfm.TransactionID,'ISHHI','')TransactionID, ");
        //        sb.Append("        (SELECT NAME FROM mrd_room_master WHERE RmID=mfm.RmID)RoomName, ");
        //        sb.Append("        (SELECT NAME FROM mrd_almirah_master WHERE AlmId= mfm.AlmID)Almirah, ");
        //        sb.Append("        (SELECT NAME FROM mrd_document_master WHERE DocID=mfd.DocID)Document,mfd.Status,mfs.Description FROM mrd_file_master mfm  ");
        //        sb.Append("        INNER JOIN mrd_file_detail mfd ON mfm.FileID=mfd.FileID inner join mrd_file_status mfs on mfs.FileStatus=mfd.Status  WHERE mfm.PatientID='" + PatientID + "' AND mfd.Status in ('" + Status + "') order by mfd.Status");
        //    }
        //    else
        //    {
        //        sb.Append("        SELECT mfm.FileID,mfm.PatientID as PID,REPLACE(mfm.TransactionID,'ISHHI','')TransactionID, ");
        //        sb.Append("        (SELECT NAME FROM mrd_room_master WHERE RmID=mfm.RmID)RoomName, ");
        //        sb.Append("        (SELECT NAME FROM mrd_almirah_master WHERE AlmId= mfm.AlmID)Almirah, ");
        //        sb.Append("        (SELECT NAME FROM mrd_document_master WHERE DocID=mfd.DocID)Document,mfd.Status,mfs.Description FROM mrd_file_master mfm  ");
        //        sb.Append("        INNER JOIN mrd_file_detail mfd ON mfm.FileID=mfd.FileID inner join mrd_file_status mfs on mfs.FileStatus=mfd.Status WHERE mfm.PatientID='" + PatientID + "' order by mfd.Status");

        //    }
        //}
        DataTable dtGridTable = StockReports.GetDataTable(sb.ToString());
        return  Newtonsoft.Json.JsonConvert.SerializeObject(dtGridTable);

    }
}