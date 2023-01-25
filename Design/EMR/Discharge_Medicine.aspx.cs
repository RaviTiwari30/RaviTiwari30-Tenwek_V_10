using System;
using System.Data;
using System.Text;

public partial class Design_EMR_Discharge_Medicine : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ViewState["ID"] = Session["ID"].ToString();
            ViewState["UserID"] = Session["ID"].ToString(); ;
            string a = ViewState["ID"].ToString();


            string TID = string.Empty;

            if (Request.QueryString["TransactionID"] == null)
                TID = Request.QueryString["TID"].ToString();
            else
                TID = Request.QueryString["TransactionID"].ToString();

            ViewState["PID"] = string.Empty;

            if (Request.QueryString["PatientID"] == null)
                ViewState["PID"] = Request.QueryString["PID"].ToString();
            else
                ViewState["PID"] = Request.QueryString["PatientID"].ToString();


            ViewState["TransID"] = TID;
            BindDetail();
            BindMedicine();
            HospitalOtherMedicine();
        }
    }
    protected void BindDetail()
    {
        All_LoadData.bindMedicineQuan(ddlTime, "Time");
        All_LoadData.bindMedicineQuan(ddlDays, "Duration");
        ddlnxtdose.DataSource = AllGlobalFunction.Medicinenextdosetime;
        ddlnxtdose.DataBind();
        ddlRoute.DataSource = AllGlobalFunction.Route;
        ddlRoute.DataBind();
    }
    private void BindMedicine()
    {

        AllQuery AQ = new AllQuery();
        DateTime AdmitDate = Util.GetDateTime(AQ.getAdmitDate(ViewState["TransID"].ToString()));
        DataTable dtDischarge = AQ.GetPatientDischargeStatus(ViewState["TransID"].ToString());
        StringBuilder sb = new StringBuilder();

        var disChargeStatus = "IN";

        if (dtDischarge != null)
            disChargeStatus = dtDischarge.Rows[0]["Status"].ToString().Trim().ToUpper();

        sb.Append(" SELECT * FROM (SELECT 'IPD' STATUS, ");
        sb.Append(" im.ItemID,SoldUnits IssueQty,sd.Date Date1,DATE_FORMAT(CONCAT(sd.Date,' ',sd.time),'%d-%b-%y %l:%i %p')DATE, ");
        sb.Append(" ltd.ItemName FROM f_salesdetails sd INNER JOIN f_stock st ON sd.StockID = st.StockID   ");
        sb.Append(" INNER JOIN f_itemmaster im ON im.ItemID = st.ItemID  ");
        sb.Append(" INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID=im.SubCategoryID  ");
        sb.Append(" INNER JOIN f_ledgertransaction LT ON sd.LedgerTransactionNo = LT.LedgerTransactionNo  ");
        sb.Append(" INNER JOIN f_ledgertnxdetail ltd ON Ltd.LedgerTransactionNo = LT.LedgerTransactionNo AND ltd.StockID = sd.StockID  ");
        sb.Append(" LEFT JOIN (SELECT STATUS,itemID,IssueDate FROM cpoe_medication_record mr WHERE STATUS=1)a ON a.itemID=im.itemID  ");
        sb.Append(" AND a.IssueDate=sd.date WHERE sd.TrasactionTypeID = 3  AND LT.IsCancel = 0 AND ltd.IsVerified <> 2 AND LT.TransactionID = '" + ViewState["TransID"].ToString() + "'  ");
        sb.Append(" UNION ALL  ");
        sb.Append(" SELECT 'OPD'STATUS,  ");
        sb.Append(" im.ItemID,SoldUnits IssueQty,sd.Date Date1,DATE_FORMAT(CONCAT(sd.Date,' ',sd.time),'%d-%b-%y %l:%i %p')DATE, ");
        sb.Append(" ltd.ItemName FROM f_salesdetails sd INNER JOIN f_stock st ON sd.StockID = st.StockID   ");
        sb.Append(" INNER JOIN f_itemmaster im ON im.ItemID = st.ItemID  ");
        sb.Append(" INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID=im.SubCategoryID  ");
        sb.Append(" INNER JOIN f_ledgertransaction LT ON sd.LedgerTransactionNo = LT.LedgerTransactionNo  ");
        sb.Append(" INNER JOIN f_ledgertnxdetail ltd ON Ltd.LedgerTransactionNo = LT.LedgerTransactionNo AND ltd.StockID = sd.StockID   ");
        sb.Append(" LEFT JOIN (SELECT STATUS,itemID,IssueDate FROM cpoe_medication_record mr WHERE STATUS=1)a ON a.itemID=im.itemID   ");
        sb.Append(" AND a.IssueDate=sd.date WHERE lt.TypeOfTnx='Pharmacy-Issue'  AND LT.IsCancel = 0 AND ltd.IsVerified <> 2 AND LT.PatientID='" + ViewState["PID"].ToString() + "'   ");
        sb.Append(" AND sd.Date>='" + AdmitDate.ToString("yyyy-MM-dd") + "'  ");
        if (disChargeStatus == "OUT")
            sb.Append(" AND sd.Date<='" + Util.GetDateTime(dtDischarge.Rows[0]["DischargeDate"].ToString().Trim()).ToString("yyyy-MM-dd") + "'   ");
        sb.Append(" )a GROUP BY ItemID,Date1  ORDER BY Date1 DESC,ItemName DESC  ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        ddlHospitalMedicine.DataSource = null;
        if (dt.Rows.Count > 0)
        {
            ddlHospitalMedicine.DataSource = dt;
            ddlHospitalMedicine.DataTextField = "ItemName";
            ddlHospitalMedicine.DataValueField = "ItemName";
            ddlHospitalMedicine.DataBind();
        }
    }
    private void HospitalOtherMedicine()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" Select ID,ItemName,ItemID,TransactionID,DATE_FORMAT(DATE,'%d-%b-%Y')DATE,DATE_FORMAT(TIME,'%l:%i %p')TIME,(SELECT CONCAT(title,' ',NAME) FROM Employee_master WHERE EmployeeID=EntryBy)EntryBy,DATE_FORMAT(EntryDateTime,'%d-%b-%Y %l:%i %p')EntryDate,Dose,Route,Frequency,StatusType ");
        sb.Append(" from cpoe_medication_record_other where TransactionID='" + ViewState["TransID"].ToString() + "' group by ItemName ORDER BY DATE DESC,TIME DESC ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        ddlHospitalMedicine.DataSource = null;
        if (dt.Rows.Count > 0)
        {
            ddlHospitalMedicine.DataSource = dt;
            ddlHospitalMedicine.DataTextField = "ItemName";
            ddlHospitalMedicine.DataValueField = "ItemName";
            ddlHospitalMedicine.DataBind();
        }
    }
}



