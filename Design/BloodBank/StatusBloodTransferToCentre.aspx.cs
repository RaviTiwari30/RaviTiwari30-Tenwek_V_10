using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Text;
using System.Web.Services;
using System.Web;
using System.Collections.Generic;

public partial class Design_BloodBank_StatusBloodTransferToCentre : System.Web.UI.Page
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
    public static string LoadCentre()
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
    public static string SearchSentRequest(string CentreID, string Component, string BloodGroup, string fromDate, string toDate)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT bdr.ID AS 'RequestID',cm.CentreName AS 'ToCentre',cm1.CentreName AS 'FromCentre',bdr.ComponentName,bdr.BloodGroup,bdr.EntryReason,IF(bdr.Status=1,'Pending',IF(bdr.Status=2,'Issue','Reject'))STATUS, ");
        sb.Append(" bdr.Quantity,IFNULL(bdr.IssueQuantity,0)IssueQuantity,IFNULL(bdr.RejectQty,0)RejectQty,( bdr.Quantity-IFNULL(bdr.IssueQuantity,0)-IFNULL(bdr.RejectQty,0))PendingQty,DATE_FORMAT( bdr.EntryDate,'%d-%b-%Y')RequestDate  ");
        sb.Append(" FROM bb_Department_BloodRequest bdr INNER JOIN center_master cm ON cm.CentreID=bdr.ToCentreID INNER JOIN center_master cm1 ON cm1.CentreID=bdr.FromCentreID WHERE bdr.FromCentreID=" + CentreID + " ");
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
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }

    [WebMethod(EnableSession = true)]
    public static string SearchIssueRequest(string CentreID, string Component, string BloodGroup, string fromDate, string toDate)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT bdr.ID AS 'RequestID',cm1.CentreName AS 'ToCentre',cm.CentreName AS 'FromCentre',bdr.ComponentName,bdr.BloodGroup,bdr.EntryReason,IF(bdr.Status=1,'Pending',IF(bdr.Status=2,'Issue','Reject'))STATUS, ");
        sb.Append(" bdr.Quantity,IFNULL(bdr.IssueQuantity,0)IssueQuantity,IFNULL(bdr.RejectQty,0)RejectQty,( bdr.Quantity-IFNULL(bdr.IssueQuantity,0)-IFNULL(bdr.RejectQty,0))PendingQty,DATE_FORMAT( bdr.EntryDate,'%d-%b-%Y')RequestDate  ");
        sb.Append(" FROM bb_Department_BloodRequest bdr INNER JOIN center_master cm ON cm.CentreID=bdr.ToCentreID INNER JOIN center_master cm1 ON cm1.CentreID=bdr.FromCentreID WHERE bdr.ToCentreID=" + CentreID + " ");
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
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }

    [WebMethod(EnableSession = true)]
    public static string SearchIssuedetail(string RequestID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT bdr.ComponentName,bdr.BloodGroup RequestBG,sm.BloodGroup IssueBG,sm.Stock_Id,sm.BBTubeNo,DATE_FORMAT(sm.ExpiryDate,'%d-%b-%Y')ExpiryDate,DATE_FORMAT(sm1.IssueDate,'%d-%b-%Y')IssueDate ,CONCAT(em.Title,'',em.Name)IssueBy ");
        sb.Append(" FROM bb_stock_master sm INNER JOIN bb_stock_master sm1 ON sm.FromStockID=sm1.Stock_Id INNER JOIN bb_Department_BloodRequest bdr ON sm.DeptRequestID=bdr.ID INNER JOIN employee_master em ON sm1.IssuedBy=em.Employee_ID WHERE sm.DeptRequestID='" + RequestID + "' ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }

    [WebMethod(EnableSession = true)]
    public static string SearchSentRequestdetail(string RequestID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT bdr.ComponentName,bdr.BloodGroup RequestBG,sm.BloodGroup IssueBG,sm.Stock_Id,sm.BBTubeNo,DATE_FORMAT(sm.ExpiryDate,'%d-%b-%Y')ExpiryDate,DATE_FORMAT(sm.EntryDate,'%d-%b-%Y')IssueDate ,CONCAT(em.Title,'',em.Name)IssueBy ");
        sb.Append(" FROM bb_Department_BloodRequest bdr INNER JOIN bb_stock_master sm ON bdr.ID=SM.DEPTREQUESTID ");
        sb.Append(" INNER JOIN employee_master em ON bdr.IssueBy=em.Employee_ID WHERE bdr.ID='" + RequestID + "' ");        
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return "";
    }


}