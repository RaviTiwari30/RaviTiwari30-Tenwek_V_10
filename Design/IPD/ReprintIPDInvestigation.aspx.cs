using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_IPD_ReprintIPDInvestigation : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
           
            
            txtFromDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");

        }
        txtFromDate.Attributes.Add("readOnly", "true");
        txtToDate.Attributes.Add("readOnly", "true");
    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";

        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT CONCAT(pm.Title,' ',pm.Pname)Pname,REPLACE(lt.TransactionID,'ISHHI','')IPDNo,pm.Mobile ContactNo,pm.PatientID,SUM(ltd.Amount)Amount,  ");
        sb.Append(" lt.LedgerTransactionNo,em.Name,REPLACE(REPLACE(ltd.LedgerTransactionNo,'LISHHI','3'),'LSHHI',2)LabNo ");
        sb.Append(" FROM f_ledgertransaction lt  INNER JOIN f_ledgertnxdetail ltd ON lt.LedgerTransactionNo=ltd.LedgerTransactionNo ");
        sb.Append(" INNER JOIN patient_master pm On pm.PatientID=lt.PatientID INNER JOIN employee_master em ON em.Employee_ID=lt.UserID ");
        sb.Append(" WHERE lt.Typeoftnx='IPD-LAB' AND ltd.IsVerified=1 ");
        if (txtLabNo.Text.Trim() != string.Empty)
            sb.Append(" AND ltd.LedgerTransactionNo=CONCAT(REPLACE(SUBSTRING('" + txtLabNo.Text.Trim() + "', 1, 1),'3','LISHHI'),SUBSTRING('" + txtLabNo.Text.Trim() + "' FROM 2) )");

        if (txtIPDNo.Text.Trim() != string.Empty)
            sb.Append(" AND lt.TransactionID='ISHHI" + txtIPDNo.Text.Trim() + "'");
        if (txtIPDNo.Text.Trim() == string.Empty && txtLabNo.Text.Trim() == string.Empty)
            sb.Append(" AND DATE(ltd.EntryDate)>='" + (Convert.ToDateTime(txtFromDate.Text)).ToString("yyyy-MM-dd") + "' AND DATE(ltd.EntryDate)<='" + (Convert.ToDateTime(txtToDate.Text)).ToString("yyyy-MM-dd") + "'");
        sb.Append(" GROUP BY lt.LedgerTransactionNo ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            grdReprintInv.DataSource = dt;
            grdReprintInv.DataBind();
        }
        else
        {
            grdReprintInv.DataSource = null;
            grdReprintInv.DataBind();
            lblMsg.Text = "Record Not Found";
        }

    }
    protected void grdReprintInv_SelectedIndexChanged(object sender, EventArgs e)
    {
        string LedgerTransactionNo = ((Label)grdReprintInv.SelectedRow.FindControl("lblLedgerTransactionNo")).Text.Trim();
        ScriptManager.RegisterStartupScript(this, this.GetType(), "key2", "window.open('CommonReceipt.aspx?LedgerTransactionNo=" + LedgerTransactionNo + "&Duplicate=0');", true);

    }
}