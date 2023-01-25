<%@ WebHandler Language="C#" Class="HandlerCS" %>

using System;
using System.IO;
using System.Net;
using System.Web;
using System.Web.Script.Serialization;
using MySql.Data.MySqlClient;
using System.Data;
using System.Collections;
public class HandlerCS : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {

        HttpPostedFile postedFile = context.Request.Files[0];
        //Check if Request is to Upload the File.
        if (context.Request.Files.Count > 0)
        {
            string patdetail = context.Request["patdetail"];
            if (context.Request["Flag"] == "Addreport")
            {
                string LedgerTransactionNo = patdetail.Split(',')[1];
                string Test_ID = patdetail.Split(',')[2];
                string department = StockReports.ExecuteScalar("SELECT io.ObservationType_ID FROM `patient_labinvestigation_opd` plo " +
                                  " INNER JOIN investigation_master im ON im.Investigation_Id=plo.Investigation_ID " +
                                  " INNER JOIN investigation_observationtype io ON io.Investigation_Id = im.Investigation_Id " +
                                  " WHERE plo.`Test_ID`='" + Test_ID + "' ");

                if ((LedgerTransactionNo == "") || (Test_ID == ""))
                {
                    // lblMsg.Text = "Error Occured Please Contact To Administrator";
                    // ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('Error Occured Please Contact To Administrator');", true);
                    return;
                }

                string orgfilename = Path.GetFileName(postedFile.FileName);
                string newfilename = Test_ID;
                string fileExt = System.IO.Path.GetExtension(postedFile.FileName);
                string FileName = LedgerTransactionNo + "_" + postedFile.FileName.Replace(fileExt, "").Trim() + "_" + DateTime.Now.ToString("yyyyMMddHHmmss") + "" + fileExt;
                var RootDir = All_LoadData.createDocumentFolder("LABINVESTIGATION", "OutSourceLabReport");
                string filePath = Path.Combine(RootDir.ToString(), FileName);
                if (File.Exists(filePath))
                {
                    File.Delete(filePath);
                }
                MySqlConnection con = Util.GetMySqlCon();
                con.Open();
                MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);

                try
                {
                    patient_labinvestigation_attachment plo = new patient_labinvestigation_attachment(tnx);
                    plo.Test_ID = Test_ID;
                    plo.AttachedFile = postedFile.FileName;
                    plo.FileUrl = FileName;
                    plo.UploadedBy = patdetail.Split(',')[0];
                    plo.IsOutSrc = "1";
                    plo.InsertReport();

                    postedFile.SaveAs(filePath);

                    //Comment According to Ravi and Sagar  to avoid auto approval of Result
                    
                    //string str = "update patient_labinvestigation_opd set  ResultEnteredBy=if(Result_Flag=0,'" + patdetail.Split(',')[0] + "',ResultEnteredBy),ResultEnteredDate=if(Result_Flag=0,NOW(),ResultEnteredDate),ResultEnteredName=if(Result_Flag=0,'" + Util.GetString(patdetail.Split(',')[3]) + "',ResultEnteredName),Result_Flag=1 ";
                    //str += ",Approved='1',ApprovedName='" + patdetail.Split(',')[3] + "',ApprovedBy='" + patdetail.Split(',')[0] + "',ApprovedDate=NOW()  ";
                    //str += " where test_id='" + Test_ID + "'   ";
                    //int RowsAffected = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);

                    //string Status = LabOPD.UpdateSampleStatus(tnx, Test_ID, patdetail.Split(',')[0], patdetail.Split(',')[3], Util.GetInt(patdetail.Split(',')[4]), Util.GetInt(patdetail.Split(',')[5]), "Report Uploaded", "");

                    tnx.Commit();
                    tnx.Dispose();
                    con.Close();
                    con.Dispose();

                }
                catch (Exception ex)
                {
                    string json = new JavaScriptSerializer().Serialize(
                   new
                   {
                       name = ex.Message
                   });
                    context.Response.StatusCode = (int)HttpStatusCode.OK;
                    context.Response.ContentType = "text/json";
                    context.Response.Write(json);
                    context.Response.End();
                    tnx.Rollback();
                    con.Close();
                    con.Dispose();
                }
                string json1 = new JavaScriptSerializer().Serialize(
                  new
                  {
                      name = "File uploaded successfully"
                  });
                context.Response.StatusCode = (int)HttpStatusCode.OK;
                context.Response.ContentType = "text/json";
                context.Response.Write(json1);
                context.Response.End();
            }
            if (context.Request["Flag"] == "AddFile")
            {

                string fileName = Path.GetFileName(postedFile.FileName);
                string RootDir = Util.GetString(All_LoadData.createDocumentFolder("LABINVESTIGATION", "Documents"));
                string fileExt = System.IO.Path.GetExtension(postedFile.FileName);
                string FileName = patdetail.Split(',')[4] + "_" + postedFile.FileName.Replace(fileExt, "").Trim() + "_" + DateTime.Now.ToString("yyyyMMddHHmmss") + "" + fileExt;
                string filePath = Path.Combine(RootDir.ToString(), FileName);

                if (File.Exists(filePath))
                {
                    File.Delete(filePath);
                }

                MySqlConnection con = Util.GetMySqlCon();
                con.Open();
                MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
                try
                {
                    patient_labinvestigation_attachment plo = new patient_labinvestigation_attachment(tnx);
                    plo.LedgerTransactionNo = patdetail.Split(',')[4];
                    plo.PatientID = patdetail.Split(',')[1];
                    plo.FileName = postedFile.FileName;
                    plo.FileUrl = FileName;
                    plo.UploadedBy = patdetail.Split(',')[3].Trim();
                    plo.DocumentName = patdetail.Split(',')[5].Trim();
                    plo.Insert();
                    postedFile.SaveAs(RootDir + @"\" + FileName);
                    tnx.Commit();
                    tnx.Dispose();
                    con.Close();
                    con.Dispose();
                }
                catch (Exception ex)
                {
                    //   ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "modelAlert('" + ex.Message + "');", true);
                    // lblMsg.Text = ex.Message;
                    tnx.Rollback();
                    con.Close();
                    con.Dispose();
                    string json1 = new JavaScriptSerializer().Serialize(
                   new
                   {
                       error = "Some Technically Error Please Try Again."
                   });
                    context.Response.StatusCode = (int)HttpStatusCode.OK;
                    context.Response.ContentType = "text/json";
                    context.Response.Write(json1);
                    context.Response.End();
                }
                //Send File details in a JSON Response.
                string json = new JavaScriptSerializer().Serialize(
                    new
                    {
                        name = "File uploaded successfully"
                    });
                context.Response.StatusCode = (int)HttpStatusCode.OK;
                context.Response.ContentType = "text/json";
                context.Response.Write(json);
                context.Response.End();
            }
        }
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
}