using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Dispatch_InvoiceSettlementReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");

            lblMsg.Text = "";
        }
        txtFromDate.Attributes.Add("readOnly", "readOnly");
        txtToDate.Attributes.Add("readOnly", "readOnly");
    }

    protected void btnReport_Click(object sender, EventArgs e)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append("SELECT p.ID,p.InvoiceNo,DATE_FORMAT(p.InvoiceDate,'%d-%b-%Y')InvoiceDate,p.InvoiceAmount,p.ReceivedAmount,p.TDSAmount,p.WriteOff,p.DeducationAmt,p.PatientType,pm.Company_Name PanelName");
        sb.Append(" FROM  f_panelonaccount p INNER JOIN f_panel_master pm ON pm.PanelID = p.PanelID WHERE p.IsActive=1 AND p.IsCancelled=0  ");
        if (txtInvoiceNo.Text.Trim() != "")
        {
            sb.Append(" AND p.InvoiceNo='" + txtInvoiceNo.Text.Trim() + "'");
        }
        else if ((txtFromDate.Text.Trim() != "") && (txtToDate.Text.Trim() != ""))
        {
            sb.Append(" AND DATE(p.createdDate)>='" + (Convert.ToDateTime(txtFromDate.Text)).ToString("yyyy-MM-dd") + "' ");
            sb.Append(" AND DATE(p.createdDate)<='" + (Convert.ToDateTime(txtToDate.Text)).ToString("yyyy-MM-dd") + "' ");
        }
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            grdSearch.DataSource = dt;
            grdSearch.DataBind();


            if (chkExtractToExcel.Checked)
            {
                Session["dtExport2Excel"] = dt;
                Session["ReportName"] = "Invoice Settlement Report ";
                Session["Period"] = "From " + Util.GetDateTime(txtFromDate.Text).ToString("dd-MMM-yyyy") + " To " + Util.GetDateTime(txtToDate.Text).ToString("dd-MMM-yyyy");
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../common/CreateExcel.aspx');", true);
            }
        }
        else
            lblMsg.Text = "Record Not Found";
    }

    protected void grdSearch_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Print")
        {
            lblMsg.Text = "";
            string ID = e.CommandArgument.ToString();
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT pm.PName,fpd.InvoiceNo,fpd.PatientID,fpd.ReceivedAmount,fpd.TDSAmount,fpd.WriteOff,fpd.DeducationAmt,fpm.PanelID,fpm.Company_Name,fpd.PaymentModeId,fpd.chequeNo CardNo,IF(fpa.PatientType='IPD',(SELECT TransNo FROM patient_medical_history WHERE TransactionID=fpd.TransactionID),'')IPDNo, ");
            sb.Append("   fpd.PaymentMode  PaymentType ,DATE_FORMAT(fpa.InvoiceDate,'%d-%b-%Y')InvoiceDate,fpa.PatientType, ");
            sb.Append(" if(fpd.ChequeDate='0001-01-01','',DATE_FORMAT(fpd.ChequeDate,'%d-%b-%Y'))ChequeDate,fpd.BankName FROM f_panelonaccount_detail fpd INNER JOIN f_panelonaccount fpa ON fpa.ID=fpd.PanelAccountID  ");
            sb.Append(" INNER JOIN f_panel_master fpm on fpd.PanelID=fpm.PanelID  INNER JOIN Patient_master pm ON pm.PatientID=fpd.PatientID ");
            sb.Append(" WHERE fpd.IsCancelled=0 AND  fpd.PanelAccountID ='" + ID + "' ");
            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
            {
                DataColumn dc = new DataColumn();
                dc.ColumnName = "ReportDate";
                dc.DefaultValue = "From : " + Util.GetDateTime(txtFromDate.Text).ToString("dd-MMM-yyyy") + "  To : " + Util.GetDateTime(txtToDate.Text).ToString("dd-MMM-yyyy");
                dt.Columns.Add(dc);
                dc = new DataColumn();
                dc.ColumnName = "UserName";
                dc = new DataColumn();
                dc.ColumnName = "UserName";
                dc.DefaultValue = StockReports.GetUserName(Convert.ToString(Session["ID"])).Rows[0][0];
                dt.Columns.Add(dc);

                DataSet ds = new DataSet();
                ds.Tables.Add(dt.Copy());

                DataTable dtImg = All_LoadData.CrystalReportLogo();
                ds.Tables.Add(dtImg.Copy());
                ds.Tables[1].TableName = "logo";
                //ds.WriteXmlSchema("E:\\InvoiceSettlementReport.xml");
                Session["ds"] = ds;
                Session["ReportName"] = "InvoiceSettlementReport";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Dispatch/Commonreport.aspx');", true);
            }
        }
    }
}