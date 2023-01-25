using System;
using System.Data;
using System.Text;
using System.Web.UI;

public partial class Design_Store_OPD_PatientIssueDetails : System.Web.UI.Page
{
    protected void btnSearchByName_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT cm.CentreID,cm.CentreName,LT.LedgerTransactionNo, ");
        sb.Append(" ifnull((SELECT GROUP_CONCAT(rec.ReceiptNo) FROM f_reciept rec WHERE rec.`AsainstLedgerTnxNo`= lt.`LedgerTransactionNo`),'')ReceiptNo,LT.TransactionID, ROUND(LT.NetAmount,2)Netamount,lt.GrossAmount,ROUND(lt.Adjustment,2)Adjustment, ");
        sb.Append(" ltd.`Rate`,ltd.`Quantity`,ltd.`DiscountPercentage`,ltd.`DiscAmt`,CONCAT(LTD.`ItemName`,'Exp Date : ',DATE_FORMAT(ltd.`medExpiryDate`,'%d-%b-%Y'))ItemName, ");
        sb.Append(" DATE_FORMAT(LT.Date,'%d-%b-%Y')DATE,LT.TypeOfTnx,CONCAT(PM.title,PM.Pname)Pname,PM.Age,CONCAT(PM.House_No,' ',PM.Street_Name,' ',PM.Locality,' ',PM.City)Address, ");
        sb.Append(" pm.PatientID,LT.BillNo,(SELECT NAME FROM doctor_master WHERE DoctorID=pmh.DoctorID)Doctor FROM f_ledgertransaction LT ");
        //sb.Append(" LEFT OUTER JOIN f_reciept rec ON rec.AsainstLedgerTnxNo=lt.LedgerTransactionNo    ");
        sb.Append(" INNER JOIN f_ledgertnxdetail LTD ON LT.LedgerTransactionNo=LTD.LedgerTransactionNo INNER JOIN f_stock ST ON LTD.StockID=ST.StockID  ");
        sb.Append(" INNER JOIN patient_master PM ON LT.PatientID=PM.PatientID INNER JOIN patient_medical_history pmh ON lt.TransactionID = pmh.TransactionID INNER JOIN  center_master cm ON cm.centreid=lt.CentreID  ");
        sb.Append(" WHERE LT.TypeOfTnx IN ('Pharmacy-Issue','Pharmacy-Return') ");
        sb.Append(" AND DATE(LT.Date)>='" + Util.GetDateTime(DateFrom.Text).ToString("yyyy-MM-dd") + "' AND DATE(LT.Date)<='" + Util.GetDateTime(DateTo.Text).ToString("yyyy-MM-dd") + "' ");
        if (txtMRNo.Text.Trim() != "")
            sb.Append(" And PM.PatientID = '" + txtMRNo.Text.Trim() + "' ");
        if (txtName.Text.Trim() != "")
            sb.Append(" And PM.PName like '" + txtName.Text.Trim() + "%' ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            DataColumn dc = new DataColumn();
            dc.ColumnName = "User Name";
            dc.DefaultValue = Convert.ToString(Session["LoginName"]);
            dt.Columns.Add(dc);

            dc = new DataColumn();
            dc.ColumnName = "SearchDate";
            dc.DefaultValue = "Date From :" + Util.GetDateTime(DateFrom.Text).ToString("dd-MMM-yyyy") + " To :" + Util.GetDateTime(DateTo.Text).ToString("dd-MMM-yyyy") + " ";
            dt.Columns.Add(dc);

            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());
            //ds.WriteXmlSchema("D:/OpdIssue.xml");
            Session["ds"] = ds;
            Session["ReportName"] = "OpdPatientIssue";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../Common/Commonreport.aspx');", true);
            lblMsg.Text = "";
        }
        else
        {
            lblMsg.Text = "No Record Found";
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            DateFrom.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            DateTo.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
        }
        DateFrom.Attributes.Add("readonly", "readonly");
        DateTo.Attributes.Add("readonly", "readonly");
    }
}