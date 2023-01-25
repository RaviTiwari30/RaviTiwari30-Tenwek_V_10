using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_IPD_PharmacyInvoice : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            string TID = Request.QueryString["TransactionID"].ToString();
            ViewState["TID"] = TID;
        }
    }

    protected void btnReport_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        //string TransID = StockReports.getTransactionIDbyTransNo(ViewState["TID"].ToString());
        getPharmacyDetails(ViewState["TID"].ToString());
    }
    private void getPharmacyDetails(string TransID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT 'Sales' Type,ltd.Quantity,ltd.Rate,(ltd.Quantity*ltd.Rate-ltd.`DiscAmt`)Amount,ltd.Amount as amt,st.batchNumber,DATE_FORMAT(st.MedExpiryDate,'%d-%b-%y')ExpiryDate,");
        sb.Append("  DATE_FORMAT(ltd.`EntryDate`,'%d-%b-%y')EntryDate,ltd.ItemName,ltd.ItemID FROM   f_ledgertransaction LT  INNER JOIN f_ledgertnxdetail ltd ");

        sb.Append(" ON lt.LedgerTransactionNo = ltd.LedgerTransactionNo ");
        sb.Append(" INNER JOIN f_stock st ON st.stockid=ltd.StockID ");
        sb.Append(" WHERE LT.IsCancel = 0 AND ltd.IsVerified =1 AND lt.TypeOfTnx in ('Sales') AND ltd.ConfigID='11' AND lt.TransactionID ='" + TransID + "'  ORDER BY DATE(LTd.EntryDate) ");
  
     DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(sb.ToString());

        if (dt.Rows.Count > 0)
        {
            DataColumn dc = new DataColumn();
            dc.ColumnName = "User";
            dc.DefaultValue = Convert.ToString(Session["LoginName"]);
            dt.Columns.Add(dc);

            StringBuilder psb = new StringBuilder();

            psb.Append("SELECT pmh.Transno as Transaction_ID,date_format(if(pmh.DateOfAdmit = '0001-01-01',CURDATE(),pmh.DateOfAdmit),'%d-%b-%Y')DateOfAdmit,date_format(if(pmh.DateOfDischarge = '0001-01-01',CURDATE(),pmh.DateOfDischarge),'%d-%b-%Y')DateOfDischarge, ");
            psb.Append(" CONCAT(pm.Title,' ',pm.PName)Name,pm.House_No Address,CONCAT(pm.Age,'/',pm.Gender)AgeSex,pnl.Company_Name,IFNULL(pm.RelationName,'')RelationName,");
            psb.Append(" CONCAT(dm.Title,' ',dm.Name)Consultant from  patient_medical_history pmh");
            psb.Append("  inner join patient_master pm on pmh.PatientID = pm.PatientID");
            psb.Append(" inner join f_panel_master pnl on pmh.PanelID = pnl.PanelID inner join doctor_master dm on pmh.DoctorID = dm.DoctorID");
            psb.Append(" where pmh.TransactionID = '" + TransID + "'");

            DataTable dtPatient = new DataTable();
            dtPatient = StockReports.GetDataTable(psb.ToString());

            DataSet ds = new DataSet();
            dtPatient.TableName = "PatientDetail";
            ds.Tables.Add(dtPatient.Copy());

            dt.TableName = "PharmacyDetails";
            ds.Tables.Add(dt.Copy());

            Session["ds"] = ds;
           // ds.WriteXml(@"E://PharmacyBillIPD.xml");
            Session["ReportName"] = "PharmacyBillIPD";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/Commonreport.aspx');", true);
        }

        else
        {
            lblMsg.Text = "No Record Found";
            return;
        }
    }
}