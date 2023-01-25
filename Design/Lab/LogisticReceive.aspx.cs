using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;
using System.Web.Services;

public partial class Design_Lab_LogisticReceive : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            FrmDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            ToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        }
        FrmDate.Attributes.Add("readonly", "readonly");
        ToDate.Attributes.Add("readonly", "readonly");
    }
    [WebMethod]
    public static string SearchInvestigation(List<string> data)
    {
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT CONCAT(pm.Title,' ',pm.PName)PatientName,cm.CentreName FromCenter,cm1.CentreName ToCenter,plo.BarcodeNo,sl.ID,plo.Test_ID, ");
            sb.Append("im.Name TestName, sl.DipatchCode, DATE_FORMAT(sl.DispatchDate,'%d-%b-%y %l:%i %p')DispatchDate,CONCAT(em.Title,' ',em.Name)DispatchBy,plo.PatientID,sl.CourierBoy  ");
            sb.Append("FROM sample_logistic sl  ");
            sb.Append("INNER JOIN patient_labinvestigation_opd plo ON plo.Test_ID=sl.Test_ID ");
            sb.Append("INNER JOIN patient_master pm ON pm.PatientID=plo.PatientID ");
            sb.Append("INNER JOIN investigation_master im ON im.Investigation_Id=plo.Investigation_ID ");
            sb.Append("INNER JOIN center_master cm ON cm.CentreID=sl.FromCentreID ");
            sb.Append("INNER JOIN center_master cm1 ON cm1.CentreID=sl.ToCentreID ");
            sb.Append("INNER JOIN employee_master em ON em.EmployeeID=sl.DispatchBy ");
            sb.Append("WHERE plo.IsSampleCollected='S' AND sl.Status='Dispatch' AND plo.sampleTransferCentreID='" + HttpContext.Current.Session["CentreID"].ToString() + "' ");
            if (data[1] != "")
                sb.Append("AND plo.BarcodeNo='" + data[1] + "' ");
            if (data[2] != "")
                sb.Append("AND sl.DipatchCode='" + data[2] + "' ");
            if (data[0] == "0" && data[1] == "" && data[2] == "")
            {
                if (data[3] != "" && data[4] != "")
                    sb.Append("AND sl.DispatchDate>='" + Util.GetDateTime(data[3]).ToString("yyyy-MM-dd") + " 00:00:00' AND sl.DispatchDate<='" + Util.GetDateTime(data[4]).ToString("yyyy-MM-dd") + " 23:59:59' ");
            }
            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            else
                return "";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "";
        }
    }
    [WebMethod]
    public static string SaveLogistic(List<string> data)
    {
       MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction();
        try
        {
            foreach (string s in data)
            {
                StringBuilder sb = new StringBuilder();
                sb.Append("UPDATE sample_logistic sl SET sl.LogisticReceiveBy=@LogisticReceiveBy,sl.LogisticReceiveDate=NOW(),sl.IsLogisticReceive=1,sl.Status='LogisticReceive' ");
                sb.Append("WHERE sl.ID=@ID ");
                int cnt = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                new MySqlParameter("@LogisticReceiveBy", HttpContext.Current.Session["ID"].ToString()),
                new MySqlParameter("@ID", s.Split('#')[0]));
                string Status = LabOPD.UpdateSampleStatus(tnx, s.Split('#')[1], HttpContext.Current.Session["ID"].ToString(), HttpContext.Current.Session["LoginName"].ToString(), Util.GetInt(HttpContext.Current.Session["CentreID"].ToString()), Util.GetInt(HttpContext.Current.Session["RoleID"].ToString()), "Logistic Receive", "");
                if (Status == "0")
                {
                    tnx.Rollback();
                    return "0";
                }
            }
            tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
}