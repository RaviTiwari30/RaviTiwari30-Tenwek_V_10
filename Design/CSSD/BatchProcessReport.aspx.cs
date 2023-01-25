using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_CSSD_BatchProcessReport : System.Web.UI.Page
{
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        lblmsg.Text = "";
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT DATE_FORMAT(fbt.`startDate`,'%d-%b-%Y') AS 'Start Date',DATE_FORMAT(fbt.`startDate`,'%h:%i %p') AS 'Start Time',DATE_FORMAT(fbt.`EndDate`,'%d-%b-%Y') AS 'End Date',DATE_FORMAT(fbt.`EndDate`,'%h:%i %p') AS 'End Time',fbt.`BoilerName` AS 'Boiler Name',fbt.`BatchName` AS 'Batch Name',em.`Name`,fbt.`Remark`,fbt.BatchNo FROM cssd_f_batch_tnxdetails fbt INNER JOIN employee_master em ON fbt.`UserID` = em.`EmployeeID` WHERE ''='' ");
        if (txtfromDate.Text != "")
            sb.Append("AND DATE(fbt.`EntryDate`) >= '" + Util.GetDateTime(txtfromDate.Text).ToString("yyyy-MM-dd") + "'");
        if (txtToDate.Text != "")
            sb.Append(" AND DATE(fbt.`EntryDate`) <= '" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "'");
        sb.Append("GROUP BY fbt.`BatchNo`");
        DataTable oDT = StockReports.GetDataTable(sb.ToString());
        if (oDT.Rows.Count > 0)
        {
            grdReport.DataSource = oDT;
            grdReport.DataBind();
        }
        else
        {
            grdReport.DataSource = null;
            grdReport.DataBind();
            lblmsg.Text = "Record Not Found";
        }
    }

    protected void grdReport_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "View")
        {
            DataTable oDT = StockReports.GetDataTable("SELECT SetName AS 'Set Name',BatchName 'Batch Name',ItemName 'Item Name',Quantity FROM cssd_f_batch_tnxdetails WHERE BatchNo='" + e.CommandArgument.ToString() + "'");
            Session["dtExport2Excel"] = oDT;
            Session["ReportName"] = "Batch Process Report from " + txtfromDate.Text + " to " + txtToDate.Text + ".";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/ExportToExcel.aspx');", true);
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtfromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        }
        txtfromDate.Attributes.Add("readonly", "true");
        txtToDate.Attributes.Add("readonly", "true");
    }
}