using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Lab_ClimsLabReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            FrmDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            ToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        }
        FrmDate.Attributes.Add("readonly", "true");
        ToDate.Attributes.Add("readonly", "true");
    }
    [WebMethod]
    public static string SearchPatient(List<string> searchdata)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT ACC_ID,CLNT_PTNT_ID,CLIENT,DATE_FORMAT(CONCAT(ACC_DT,' ',ACC_Time),'%d-%b-%y %H:%m:%s')ACC_DT,PTNT_NM,File_Name ");
        sb.Append("FROM clims_labresult clr LEFT JOIN Patient_master pm ON pm.OldPatientID=CLNT_PTNT_ID WHERE clr.ID >0 ");
        if (!String.IsNullOrEmpty(searchdata[0]))
            sb.Append("AND Acc_ID='" + searchdata[0] + "' ");
        if (!String.IsNullOrEmpty(searchdata[1]))
            sb.Append("AND (CLNT_PTNT_ID='" + searchdata[1] + "' OR pm.PatientID='" + searchdata[1] + "') ");
        if (!String.IsNullOrEmpty(searchdata[2]))
            sb.Append("AND PTNT_NM LIKE '%" + searchdata[2] + "%' ");
        if (String.IsNullOrEmpty(searchdata[0]) && String.IsNullOrEmpty(searchdata[1]) && String.IsNullOrEmpty(searchdata[2]))
            sb.Append("AND Acc_DT>='" + Util.GetDateTime(searchdata[3]).ToString("yyyy-MM-dd") + "' AND Acc_DT<='" + Util.GetDateTime(searchdata[4]).ToString("yyyy-MM-dd") + "' ");

        sb.Append("LIMIT 500 ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, data = dt });
        else
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "No Record Found.", message = "No Record Found." });
    }
}