using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Web.Services;
using System.Linq;
using MySql.Data.MySqlClient;

public partial class Design_IPD_PatientCode : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    [WebMethod(EnableSession = true)]
    public static string bindCodemasterlist()
    {
        DataTable dt = StockReports.GetDataTable(" select ID,CodeType from CodeMaster where active=1 ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod(EnableSession = true)]

    public static string SavePatientCode(string Pcode, string TID, string PID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        ExcuteCMD excuteCMD = new ExcuteCMD();
        var message = "";
        try
        {

            string sqlCMD = "update patient_medical_history pmh set pmh.PatientCodeType=@PatientCodeType,pmh.PatientCodeUpdateby=@PatientCodeUpdateby,pmh.PatientCodeUpdateDate=now() where pmh.TransactionID=@TransactionID";

                excuteCMD.DML(tnx, sqlCMD, CommandType.Text, new
                {
                    PatientCodeType = Util.GetInt(Pcode),
                    PatientCodeUpdateby = HttpContext.Current.Session["ID"].ToString(),
                    TransactionID=TID
                });

                message = "Patient Code Save Sucssfully";
            

            tnx.Commit();
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = message });

        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact Administrator", message = ex.Message });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public static string BindPCode(string TID)
    {
        var dt = Util.GetString(StockReports.ExecuteScalar("SELECT  IFNULL(PatientCodeType,'')PatientCode FROM patient_medical_history WHERE TransactionID='" + TID + "'"));

        if (dt != "")
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, response = dt });
        }
        else { return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "" }); }

    }
}