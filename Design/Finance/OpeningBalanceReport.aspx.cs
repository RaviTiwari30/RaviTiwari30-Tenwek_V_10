using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Text;
using MySql.Data.MySqlClient;
using CrystalDecisions.CrystalReports.Engine;
using CrystalDecisions.Shared;
using System.Web.Services;
using System.IO;
using System.Collections.Generic;

public partial class Design_CommonReports_OpeningBalanceReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromDate.Text = txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            ceFromDate.EndDate = ceToDate.EndDate = DateTime.Now;
        }
        txtFromDate.Attributes.Add("readonly", "true");
        txtToDate.Attributes.Add("readonly", "true");
    }
    [WebMethod]
    public static string BindCentre()
    {
        DataTable dt = All_LoadData.dtbind_Center();
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    [WebMethod]
    public static string BindPanel()
    {
        DataTable dt = All_LoadData.LoadPanelIPD();
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    [WebMethod]
    public static string GetExcelReports(int centreID, string fromDate, string toDate, string reporttype, string PanelID)
    {
        DataTable dt_ = new DataTable();
        try
        {
            StringBuilder sb = new StringBuilder();
            if (reporttype == "B")
            {
                sb.Append("SELECT cm.CentreName,DATE_FORMAT(adj.BillDate,'%d-%b-%y')BillDate,adj.BillNo,REPLACE(adj.TransactionID,'ISHHI','')AS 'IPD No.',pm.PatientID AS 'UHID', ");
                sb.Append("TRIM(pm.PName)PatientName,SUM(ltd.NetItemAmt) AS BillAmt,pnl.Company_Name AS PanelName,dm.Name AS DoctorName FROM f_ipdadjustment adj  ");
                sb.Append("INNER JOIN f_ledgertnxdetail ltd ON ltd.TransactionID=adj.TransactionID ");
                sb.Append("INNER JOIN patient_master pm ON pm.PatientID=adj.PatientID LEFT JOIN f_panel_master pnl ON pnl.PanelID=adj.PanelID LEFT JOIN doctor_master dm ON dm.DoctorID=ltd.DoctorID ");
                sb.Append("INNER JOIN center_master cm ON cm.centreID=adj.CentreID ");
                sb.Append("WHERE ltd.IsVerified=1 AND adj.IsOpeningBalance=1 AND adj.CentreID=" + centreID + " ");
                sb.Append("AND adj.OpeningBalanceDate>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + " 00:00:00' AND adj.OpeningBalanceDate<='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + " 23:59:59'  ");
                if (PanelID != "")
                    sb.Append(" AND adj.PanelID IN (" + PanelID + ") ");

                sb.Append("GROUP BY adj.TransactionID ORDER BY adj.BillDate    ");
            }
            else if (reporttype == "I")
            {
                sb.Append("SELECT cm.CentreName,DATE(adj.BillDate)BillDate,adj.BillNo,REPLACE(adj.TransactionID,'ISHHI','')AS 'IPD No.',pm.PatientID AS 'UHID',TRIM(pm.PName)PatientName,ltd.ItemName,ltd.NetItemAmt,pnl.Company_Name AS PanelName,dm.Name AS DoctorName FROM f_ipdadjustment adj  ");
                sb.Append("INNER JOIN f_ledgertnxdetail ltd ON ltd.TransactionID=adj.TransactionID  ");
                sb.Append("INNER JOIN patient_master pm ON pm.PatientID=adj.PatientID  ");
                sb.Append("INNER JOIN center_master cm ON cm.centreID=adj.CentreID   LEFT JOIN f_panel_master pnl ON pnl.PanelID=adj.PanelID LEFT JOIN doctor_master dm ON dm.DoctorID=ltd.DoctorID ");
                sb.Append("WHERE ltd.IsVerified=1 AND adj.IsOpeningBalance=1 AND adj.CentreID=" + centreID + "  ");
                if (PanelID != "")
                    sb.Append(" AND adj.PanelID IN (" + PanelID + ") ");

                sb.Append("AND adj.OpeningBalanceDate>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + " 00:00:00' AND adj.OpeningBalanceDate<='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + " 23:59:59' GROUP BY ltd.ID ORDER BY adj.BillDate  ");
            }
            dt_ = Util.GetDataTableRowSum(StockReports.GetDataTable(sb.ToString()));
            HttpContext.Current.Session["dtExport2Excel"] = dt_;
            HttpContext.Current.Session["ReportName"] = "OPENING BALANCE REPORT";
            HttpContext.Current.Session["Period"] = "From " + Util.GetDateTime(fromDate).ToString("dd-MMM-yyyy") + " To " + Util.GetDateTime(toDate).ToString("dd-MMM-yyyy");
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, URL = "../common/ExportToExcel.aspx" });
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = ex.Message, message = AllGlobalFunction.errorMessage });
        }
        finally
        {

        }
    }
}