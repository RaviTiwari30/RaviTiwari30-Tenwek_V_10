using System;
using System.Data;
using System.Web.UI;
using System.Text;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Web;
using Newtonsoft.Json;


public partial class Design_IPD_MissingItemReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ucFromDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            ucToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
          
            //if (Convert.ToString(Session["LoginType"]).ToUpper() == "DOCTOR SPECIALIST")
            //{
            //    string str = StockReports.ExecuteScalar("SELECT DoctorID FROM doctor_employee de INNER JOIN f_center_doctor d ON d.DoctorID=de.DoctorID WHERE d.CentreID=" + Session["CentreID"].ToString() + " AND Employeeid='" + Convert.ToString(Session["ID"]) + "'");
            //    if (!string.IsNullOrEmpty(str))
            //    {
            //        ViewState["DoctorID"] = Util.GetString(str);
            //    }
            //    else
            //    {
            //        ViewState["DoctorID"] = "";
            //        lblMsg.Text = "You are not authorize for this center.";
            //    }
            //}
            //else
            //    ViewState["DoctorID"] = "1";
            ViewState["DoctorID"] = "1";
        }
      

    }
    [WebMethod(EnableSession = true)]
    public static string PatientSearch(string MRNo, string PName, string Department, string ItemID, string Floor, string AgeFrom, string ddlAgeFrom, string AgeTo, string ddlAgeTo, string RoomType, string IPDNo, string DoctorID, string Panel, string ParentPanel, string FromDate, string ToDate, string AdmitDischarge, string Type, string id, int IsPatientReceived)
    {

       
        StringBuilder sb = new StringBuilder();
        if (IPDNo != "")
            IPDNo = StockReports.getTransactionIDbyTransNo(IPDNo.Trim());

        sb.Append("CALL sp_MissingitemReport('" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "'," + HttpContext.Current.Session["CentreID"].ToString() + ",'" + IPDNo + "','" + MRNo + "','" + Panel + "','" + PName + "','"+ItemID+"','" + AdmitDischarge + "');");

        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            //DataColumn dc = new DataColumn();
            //dc.ColumnName = "Period";
            //dc.DefaultValue = "From : " + FromDate.Trim() + "";
            //dt.Columns.Add(dc);
            HttpContext.Current.Session["dtExport2Excel"] = dt;
            HttpContext.Current.Session["Reportname"] = "Missing Item Report";
            HttpContext.Current.Session["Period"] = "Period From : " + FromDate.Trim() + "";
          //return  "2";
            return JsonConvert.SerializeObject(new { items = dt });
           
        }
        else
        return "";

    }
}