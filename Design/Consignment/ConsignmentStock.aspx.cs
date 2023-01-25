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

public partial class Design_Consignment_ConsignmentStock : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindDepartment();
        }
    }
    public void BindDepartment()
    {
        ddlDpt.DataSource = StockReports.GetDataTable("SELECT LedgerNumber,LedgerName FROM f_ledgermaster WHERE GroupID='DPT'");
        ddlDpt.DataTextField = "LedgerName";
        ddlDpt.DataValueField = "LedgerNumber";
        
        ddlDpt.DataBind();
        ddlDpt.Items.Insert(0, "ALL");
    }
    protected void btnCloseStock_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT  con.ItemID,ItemName,UnitType,BatchNumber,ChallanNo,IF(ChallanDate='0001-01-01','',DATE_FORMAT(ChallanDate,'%d-%b-%Y'))ChallanDate,UnitPrice,MRP,date_format(MedExpiryDate,'%d-%b-%y')MedExpiryDate,SUM(InititalCount-ReleasedCount) Qty,SUM(UnitPrice*(InititalCount-ReleasedCount))Amount,lm.LedgerName,IsFree,con.ConsignmentNo,l.LedgerName VendorName FROM consignmentdetail con INNER JOIN f_itemmaster im ");
        sb.Append(" ON con.ItemID=im.ItemID  ");
        sb.Append(" INNER JOIN f_ledgermaster lm ON lm.LedgerNumber=con.DeptLedgerNo AND GroupID='DPT'  INNER JOIN f_ledgermaster l ON l.LedgerNumber=con.VendorLedgerNo AND l.GroupID='VEN' WHERE IsCancel=0  ");
        if (ddlDpt.SelectedIndex > 0)
        {
            sb.Append(" and con.DeptLedgerNo='" + ddlDpt.SelectedItem.Value + "' ");
        }
        sb.Append(" and (InititalCount-ReleasedCount)>0 GROUP BY ItemID ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            DataColumn dc = new DataColumn();
            dc.ColumnName = "Date";
            dc.DefaultValue = " As On : " + DateTime.Now.ToString("dd-MMM-yyyy HH:mm:ss");
            dt.Columns.Add(dc);

            //dt.WriteXml(@"C:\StockStatus.xml");
            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());
            Session["ds"] = ds;
            Session["ReportName"] = "StockStatus";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Design/Consignment/Reports/Commonreport.aspx');", true);

        }
        else
        {
            lblMsg.Text = "No Record Found";
        }

    }
}
