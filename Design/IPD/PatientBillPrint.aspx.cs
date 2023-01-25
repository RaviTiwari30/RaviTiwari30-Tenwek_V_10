using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
public partial class Design_IPD_PatientBillPrint : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.QueryString["TransactionID"] != null)
        {
            string TransactionID = Request.QueryString["TransactionID"].ToString();
            string billNo = StockReports.ExecuteScalar("SELECT IFNULL(BillNo,'')BillNo from patient_medical_history WHERE TransactionID='" + TransactionID + "'");
            if (!IsPostBack)
            {
                if (!string.IsNullOrEmpty(billNo)){
                    lblBillNo.Text = billNo;
                }
                lblissurgery.Text = StockReports.ExecuteScalar("SELECT COUNT(*)  FROM  f_ledgertnxdetail ltd WHERE  ltd.IsSurgery=1  AND ltd.TransactionID='" + TransactionID + "'  AND ltd.IsVerified=1");
                lblIsPackage.Text = StockReports.ExecuteScalar("SELECT COUNT(*)  FROM  f_ledgertnxdetail ltd WHERE  ltd.isPackage=1  AND ltd.TransactionID='" + TransactionID + "'  AND ltd.IsVerified=1");
                PendingInvestigationReports();
            }
        }
    }

    private void PendingInvestigationReports()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT OM.NAME Department,im.Name ,DATE_FORMAT(pli.Date,'%d-%b-%Y')DATE,IF(Approved=1,'APPROVED',IF(IFNULL(PLI.Result_Flag,0)=0,'RESULT-NOT-DONE','NOT-APPROVED'))Approved ");
        sb.Append(" FROM patient_labinvestigation_opd pli  ");
        sb.Append(" INNER JOIN investigation_master im ON im.Investigation_Id=pli.Investigation_ID ");
        sb.Append(" INNER JOIN f_ledgertnxdetail ltd ON ltd.ID=pli.LedgertnxID ");
        sb.Append(" INNER JOIN investigation_observationtype IO ON PLI.Investigation_Id = IO.Investigation_ID  ");
        sb.Append(" INNER JOIN observationtype_master OM ON OM.ObservationType_ID = IO.ObservationType_Id  ");
        sb.Append(" WHERE pli.TransactionID='" + Request.QueryString["TransactionID"].ToString() + "' AND LTD.IsVerified=1 AND pli.Approved<>1 ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt != null && dt.Rows.Count > 0)
        {
            grdInvestigations.DataSource = dt;
            grdInvestigations.DataBind();
            //ScriptManager.RegisterStartupScript(this, this.GetType(), "keylab", "PendingInvestigation();", true);
        }
        else
        {
            grdInvestigations.DataSource =null;
            grdInvestigations.DataBind();
        }
    }
}
