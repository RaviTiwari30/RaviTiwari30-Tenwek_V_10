using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Text;
using System.Web.Services;
using System.Web;
using System.Collections.Generic;

public partial class Design_BloodBank_StockPurchaseReturnReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            fromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            ToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            All_LoadData.bindCentre(chkCentre, Session["ID"].ToString(),btnSearch);
        }
        fromDate.Attributes.Add("readOnly", "readOnly");
        ToDate.Attributes.Add("readOnly", "readOnly");
    }

    [WebMethod(EnableSession = true)]
    public static string LoadOrganisation()
    {
        DataTable dtCentre = StockReports.GetDataTable(" SELECT organisaction,id FROM bb_organisation_master WHERE IsActive=1  order by Id ");
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
    public static string SearchReport(string Organisation, string Component, string BloodGroup, string fromDate, string toDate, string ReportType, List<string> selectedCentreIDs)
    {
        string CentreID = string.Join(",",selectedCentreIDs);

        StringBuilder sb = new StringBuilder();
        if (ReportType == "Purchase" || ReportType == "All")
        {
            sb.Append(" SELECT cm.CentreName,cm.CentreID, Organisation,bsm.ComponentName,bsm.ComponentID,bsm.Bloodgroup,bsm.InitialCount AS Quantity,bsm.BBtubeno, ");
            sb.Append(" bsm.Rate,DATE_FORMAT(bsm.Entrydate,'%d-%b-%Y')Entrydate,DATE_FORMAT(bsm.expirydate,'%d-%b-%Y')expirydate ,'Purchase' AS TnxType ");
            sb.Append(" FROM bb_stockpost bsp INNER JOIN bb_stock_master bsm ON bsm.bloodcollection_id=bsp.bb_directstockID  ");
            sb.Append(" INNER JOIN employee_master emp ON emp.employee_id=bsp.CreatedBy INNER JOIN center_master cm ON bsm.CentreID=cm.CentreID  ");
            sb.Append(" WHERE bsp.Status=1 AND bsm.CentreID IN (" + CentreID + ")  ");
            if (fromDate != string.Empty && toDate != string.Empty)
            {
                sb.Append(" AND  bsp.CreatedDate >= '" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + " 00:00:00'  AND bsp.CreatedDate <='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + " 23:59:59'    ");
            }
            if (Organisation != "All")
            {
                sb.Append(" and bsp.Organisation='" + Organisation + "'");
            }
            if (Component != "0")
            {
                sb.Append(" and bsm.ComponentID='" + Component + "'");
            }
            if (BloodGroup != "All")
            {
                sb.Append(" and bsm.BloodGroup='" + BloodGroup + "'");
            }
            sb.Append(" GROUP BY bsm.Stock_Id  ");
        }
        if (ReportType == "All")
        {
            sb.Append(" UNION ALL ");
        }
        if (ReportType == "Return" || ReportType == "All")
        {
            sb.Append(" SELECT cm.CentreName,cm.CentreID,bsp.Organisation,bsm.ComponentName,bsm.ComponentID,bsm.BloodGroup,concat('-',bsm.InitialCount) AS Quantity,bsm.BBTubeNo,bsm.Rate, ");
            sb.Append(" DATE_FORMAT(bv.EntryDate,'%d-%b-%Y')EntryDate,DATE_FORMAT(bsm.expirydate,'%d-%b-%Y')expirydate ,'Return' AS TnxType ");
            sb.Append(" FROM  bb_venderreturn bv INNER JOIN bb_stock_master bsm ON bv.Stockid=bsm.Stock_id ");
            sb.Append(" INNER JOIN bb_stockpost bsp ON bsp.bb_directstockID=bsm.BloodCollection_Id INNER JOIN center_master cm ON bv.CentreID=cm.CentreID   ");
            sb.Append(" INNER JOIN employee_master em ON em.employee_id= bv.entryby WHERE bsm.isvenderReturn=1 AND bv.CentreID IN (" + CentreID + ") ");
            if (fromDate != string.Empty && toDate != string.Empty)
            {
                sb.Append(" AND bv.EntryDate>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + " 00:00:00' AND bv.EntryDate<='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + " 23:59:59'    ");
            }
            if (Organisation != "All")
            {
                sb.Append(" and bsp.Organisation='" + Organisation + "'");
            }
            if (Component != "0")
            {
                sb.Append(" and bsm.ComponentID='" + Component + "'");
            }
            if (BloodGroup != "All")
            {
                sb.Append(" AND bsm.BloodGroup='" + BloodGroup + "'");
            }
            sb.Append(" GROUP BY bv.StockID ");
        } 
        sb.Append(" ORDER BY entrydate ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            DataColumn dc = new DataColumn();
            dc.ColumnName = "Period";
            dc.DefaultValue = "Period From " + Util.GetDateTime(fromDate).ToString("dd-MMM-yyyy") + " To : " + Util.GetDateTime(toDate).ToString("dd-MMM-yyyy");
            dt.Columns.Add(dc);

            dc = new DataColumn();
            dc.ColumnName = "UserName";
            dc.DefaultValue = StockReports.GetUserName(HttpContext.Current.Session["ID"].ToString());
            dt.Columns.Add(dc);
            dc = new DataColumn();
            dc.ColumnName = "HeaderName";
            if (ReportType == "Purchase")
            {
                dc.DefaultValue = "Blood Stock Purchase Report";
            }
            else if (ReportType == "Return")
            {
                dc.DefaultValue = "Blood Stock Return Report";
            }
            else
                dc.DefaultValue = "Blood Stock Purchase/Return Report";
            dt.Columns.Add(dc);
            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());
            //ds.WriteXmlSchema(@"D:\BBStockPurchaseReturnReport.xml");
            HttpContext.Current.Session["ds"] = ds;
            HttpContext.Current.Session["ReportName"] = "BBStockPurchaseReturnReport";
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = true, responseURL = "../Bloodbank/Commenreport.aspx" });
        }
        else
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "No Record Found." });
    }
}