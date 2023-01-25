using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Web.Services;
using System.Web;

public partial class Design_EDP_MergePatientID : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
    }
    [WebMethod(EnableSession = true)]
    public static string bindPatientDetail(string DestPatientID, string SourcePatientID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT 'Source Patient' as PatientType,PatientID as Patient_ID,CONCAT(Title,Pname)Pname,CONCAT(age,'/',Gender)AgeSex,CONCAT(house_no,city,',',locality,city,country)Address,Mobile FROM Patient_master WHERE Patientid='" + SourcePatientID.ToString() + "' and active=1");
        sb.Append(" Union All");
        sb.Append(" SELECT 'Destination Patient' as PatientType,PatientID as Patient_ID,CONCAT(Title,Pname)Pname,CONCAT(age,'/',Gender)AgeSex,CONCAT(house_no,city,',',locality,city,country)Address,Mobile FROM Patient_master WHERE Patientid='" + DestPatientID.ToString() + "' and active=1");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0 && dt != null)
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        else
            return "";
    }
    [WebMethod(EnableSession = true)]
    public static string MapUHID(string SourceUHID, string DestUHID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction();
        ExcuteCMD excuteCMD = new ExcuteCMD();
        string result = "0";
        try
        {

            excuteCMD.DML(tnx, "TRUNCATE TABLE merge_patientid", CommandType.Text, new { });

            excuteCMD.DML(tnx, "call Create_Merge_PatientID_SQLCMD()", CommandType.Text, new { });
            
            string str = "Call Merge_PatientID('" + DestUHID.ToString() + "','" + SourceUHID.ToString() + "','" + HttpContext.Current.Session["ID"].ToString() + "')";
            excuteCMD.DML(tnx, str, CommandType.Text, new {});

            excuteCMD.DML(tnx, "delete from Patient_master where PatientID='"+ SourceUHID.ToString() + "'", CommandType.Text, new { });

            tnx.Commit();
            result = "1";
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            result = "0";
        }
        finally 
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
        return result;
    }
}