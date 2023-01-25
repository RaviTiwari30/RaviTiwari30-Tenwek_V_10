using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Text;
using System.Web.Services;
using System.Web;
using System.Collections.Generic;

public partial class Design_BloodBank_CentreStockTransferReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            fromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            ToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        }
        fromDate.Attributes.Add("readOnly", "readOnly");
        ToDate.Attributes.Add("readOnly", "readOnly");
    }

    [WebMethod(EnableSession = true)]
    public static string LoadFromCentre()
    {
        DataTable dtCentre = StockReports.GetDataTable("SELECT CentreID,CentreName FROM center_master WHERE isactive=1  order by CentreName");
        if (dtCentre.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dtCentre);
        else
            return "";
    }
    [WebMethod(EnableSession = true)]
    public static string LoadToCentre()
    {
        DataTable dtCentre = StockReports.GetDataTable("SELECT CentreID,CentreName FROM center_master WHERE isactive=1  order by CentreName");
        if (dtCentre.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dtCentre);
        else
            return "";
    }
    [WebMethod(EnableSession = true)]
    public static string LoadComponent()
    {
        DataTable dtCentre = StockReports.GetDataTable("SELECT ComponentName ,ID FROM bb_component_master  WHERE active='1' order by ComponentName");
        if (dtCentre.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dtCentre);
        else
            return "";
    }

    [WebMethod(EnableSession = true)]
    public static string LoadBloodGroup()
    {
        DataTable dtCentre = StockReports.GetDataTable("SELECT ID,BloodGroup FROM bb_BloodGroup_master WHERE IsActive=1 AND bloodgroup<>' NA'  order by bloodgroup ");
        if (dtCentre.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dtCentre);
        else
            return "";
    }

    [WebMethod(EnableSession = true)]
    public static string SearchReport(string FromCentreID, string toCentreID, string Component, string BloodGroup, string fromDate, string toDate)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT cm.CentreName AS 'From Centre',cm1.CentreName AS 'To Centre',sm.ComponentName,sm.BloodGroup,sm.BBTubeNo AS 'Bag Number',DATE_FORMAT(sm.ExpiryDate,'%d-%b-%Y')ExpiryDate,DATE_FORMAT(bdr.EntryDate,'%d-%b-%Y')RequestDate, ");
        sb.Append(" DATE_FORMAT(sm1.IssueDate,'%d-%b-%Y')IssueDate,CONCAT(em.Title,'',em.Name)IssueBy,sm.Rate As Amount ");
        sb.Append(" FROM bb_department_bloodrequest bdr INNER JOIN center_master cm ON cm.CentreID=bdr.ToCentreID INNER JOIN center_master cm1 ON cm1.CentreID=bdr.FromCentreID ");
        sb.Append(" INNER JOIN bb_stock_master sm ON bdr.ID=sm.DeptRequestID INNER JOIN bb_stock_master sm1 ON sm.FromStockID=sm1.Stock_Id INNER JOIN employee_master em ON sm1.IssuedBy=em.Employee_ID ");
        sb.Append(" WHERE bdr.ToCentreID=" + FromCentreID + " ");
        if (toCentreID != "0")
        {
            sb.Append(" and bdr.FromCentreID=" + toCentreID + "");
        }
        if (Component != "0")
        {
            sb.Append(" and bdr.ComponentID='" + Component + "'");
        }
        if (BloodGroup != "Select")
        {
            sb.Append(" AND bdr.BloodGroup='" + BloodGroup + "'");
        }
        if (fromDate != string.Empty && toDate != string.Empty)
        {
            sb.Append(" AND bdr.EntryDate>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + " 00:00:00' AND bdr.EntryDate<='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + " 23:59:59' ");
        }
        sb.Append(" ORDER BY bdr.Id ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            DataSet ds = new DataSet();
            HttpContext.Current.Session["dtExport2Excel"] = dt;
            HttpContext.Current.Session["ReportName"] = "Centre Stock Transfer Report";
            HttpContext.Current.Session["Period"] = "From : " + Util.GetDateTime(fromDate).ToString("dd-MMM-yyyy") + " To : " + Util.GetDateTime(toDate).ToString("dd-MMM-yyyy");
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, responseURL = "../../Design/common/ExportToExcel.aspx" });
        }
        else
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "No Record Found." });
    }
}