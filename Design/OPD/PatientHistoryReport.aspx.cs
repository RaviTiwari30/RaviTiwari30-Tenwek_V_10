using System;
using System.Data;
using System.Drawing;
using System.IO;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;
using MW6BarcodeASPNet;

public partial class Design_OPD_PatientHistoryReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtReceiptNo.Focus();
            ucFromDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            ucToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            All_LoadData.bindCentre(chkCentre, Session["ID"].ToString(), btnReport);
        }
        ucFromDate.Attributes.Add("readOnly", "true");
        ucToDate.Attributes.Add("readOnly", "true");
    }
    public void GetReceipt(DataTable dtReceipt)
    {
        DataTable dt = new DataTable();
        dt.Columns.Add("PatientID");
        dt.Columns.Add("Patient_Name");
        dt.Columns.Add("TransactionID");
        dt.Columns.Add("Room_No");
        dt.Columns.Add("Consultant Name");
        dt.Columns.Add("PreparedBy");
        dt.Columns.Add("ReceiptNo");
        dt.Columns.Add("Amount");
        dt.Columns.Add("CompanyName");
        dt.Columns.Add("PaymentMode");
        dt.Columns.Add("Date");
        dt.Columns.Add("Time");
        dt.Columns.Add("BillDate");
        dt.Columns.Add("BillNo");
        dt.Columns.Add("BankName");
        dt.Columns.Add("RefNo");

        DataRow dr = dt.NewRow();

        dr["PatientID"] = Util.GetString(dtReceipt.Rows[0]["PatientID"]);
        dr["Patient_Name"] = Util.GetString(dtReceipt.Rows[0]["Patient_Name"]);
        dr["TransactionID"] = Util.GetString(dtReceipt.Rows[0]["TransactionID"]);
        dr["Room_No"] = Util.GetString(dtReceipt.Rows[0]["Room_No"]);
        dr["PreparedBy"] = Util.GetString(dtReceipt.Rows[0]["PreparedBy"]);
        dr["Consultant Name"] = Util.GetString(dtReceipt.Rows[0]["Consultant_Name"]);
        dr["ReceiptNo"] = Util.GetString(dtReceipt.Rows[0]["ReceiptNo"]);
        dr["Amount"] = Util.GetDecimal(dtReceipt.Rows[0]["Amount"]);
        dr["CompanyName"] = Util.GetString(dtReceipt.Rows[0]["CompanyName"]);
        dr["PaymentMode"] = Util.GetString(dtReceipt.Rows[0]["PaymentMode"]);
        dr["Date"] = Util.GetString(dtReceipt.Rows[0]["Date"]);
        dr["Time"] = Util.GetString(dtReceipt.Rows[0]["Time"]);
        dr["BankName"] = Util.GetString(dtReceipt.Rows[0]["BankName"]);

        dr["RefNo"] = Util.GetString(dtReceipt.Rows[0]["RefNo"]);
        dt.Rows.Add(dr);

        Session["DataTableReceipt"] = dt;


    }

    public DataTable GetReceiptDetailnew(string FromDate, string ToDate, string ReceiptNo, string BillNo, string PatientName, string PatientID, string Centre)
    {
        DataTable Items = new DataTable();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT * FROM (  ");
            sb.Append("  SELECT CentreName,Pm.PatientID,PM.Age,Pm.Mobile,PM.PName,CONCAT(IFNULL(PM.House_No,''),'',IFNULL(PM.Street_Name,''),'',IFNULL(PM.Locality,''),'',IFNULL(PM.City,''))Address , ");
            sb.Append("  IF(ReceiptNo<>'','CASH','CREDIT')PaymentMode,RP.ReceiptNo,BillNo,DATE_FORMAT(RP.date,'%d-%b-%Y')DATE ,TIME_FORMAT(Rp.Time,'%h:%i %p')Time, ");
            sb.Append("  rp.AmountPaid,CASE WHEN ( TypeOfTnx IS NULL AND RP.TransactionID = '' ) THEN 'OPD Advance/Settlement' WHEN (ReceiptNo<>'' AND PaymentModeID=4) THEN 'OPDSettlement' ");
            sb.Append("  WHEN ( TypeOfTnx IS NULL AND RP.TransactionID <> '' ) THEN 'IPD' ELSE TypeOfTnx END AS TypeOfTnx,rp.depositor,LedgerNoCr,RP.TransactionID, ");
            sb.Append("  ( Select DoctorID from patient_medical_history where TransactionID=RP.TransactionID)DoctorID,LedgerTransactionNo,rp.TypeName  ");
            sb.Append("  FROM ( ");
            sb.Append("         SELECT cm.CentreName,rt.ReceiptNo,lt.NetAmount AmountPaid,lt.PatientID,lt.TypeOfTnx,rt.TransactionID,rt.AsainstLedgerTnxNo, lt.LedgerTransactionNo,lt.BillNo,rt.date,rt.time,    ");
            sb.Append("          IF(lt.LedgerNoCr IS NULL,rt.LedgerNoCr,lt.LedgerNoCr)LedgerNoCr,rt.depositor,lt.PaymentModeID , ");
            sb.Append("          ( SELECT TypeName FROM F_itemmaster WHERE ItemId = ltd.Itemid)TypeName FROM f_reciept rt LEFT JOIN f_ledgertransaction lt ON rt.AsainstLedgerTnxNo = lt.LedgerTransactionNo INNER JOIN Center_master cm ON cm.CentreID = lt.CentreID  ");
            sb.Append("           INNER JOIN f_ledgertnxdetail ltd ON ltd.LedgerTransactionNo = lt.LedgerTransactionNo WHERE rt.IsCancel=0 ");
           
            if (PatientID != "")
                sb.Append(" AND rt.depositor ='" + PatientID + "'");

            if (ReceiptNo != "")
                sb.Append(" AND rt.ReceiptNo like '" + ReceiptNo + "'");

            if (BillNo != "")
                sb.Append(" AND LT.BillNo = '" + BillNo + "'");

            if (ReceiptNo == "" && BillNo == "" && PatientID == "")
            {
                if (FromDate != "" && ToDate != "")
                    sb.Append(" AND Date(rt.date)>='" + FromDate + "' AND date(rt.date)<='" + ToDate + "'  ");
            }

            //for credit only
            sb.Append(" UNION ");
            sb.Append(" SELECT cm.CentreName,''ReceiptNo,lt.NetAmount AmountPaid,lt.PatientID ,lt.TypeOfTnx,lt.TransactionID,'' AsainstLedgerTnxNo,lt.LedgerTransactionNo,lt.BillNo,lt.Date,TIME_FORMAT(lt.time,'%h:%i %p')Time, ");
            sb.Append("    lt.LedgerNoCr,'' depositor,lt.PaymentModeID,( SELECT TypeName FROM F_itemmaster WHERE ItemId = ltd.Itemid)TypeName FROM f_ledgertransaction lt    ");
            sb.Append("      INNER JOIN f_ledgertransaction_paymentdetail ltpay ON lt.LedgerTransactionNo=ltpay.LedgerTransactionNo INNER JOIN Center_master cm ON cm.CentreID = lt.CentreID ");
            sb.Append("      INNER JOIN f_ledgertnxdetail ltd ON ltd.LedgerTransactionNo = lt.LedgerTransactionNo   ");
            sb.Append("      WHERE lt.TypeOfTnx NOT IN ('Pharmacy-Issue','Pharmacy-Return') AND lt.IsCancel=0 AND ltpay.PaymentModeID=4 ");

            if (BillNo == "" && PatientName == "" && PatientID == "" && ReceiptNo == "")
                sb.Append(" AND DATE(lt.date)>='" + FromDate + "' AND DATE(lt.date)<='" + ToDate + "'");
            if (BillNo != "")
                sb.Append(" AND LT.BillNo = '" + BillNo + "'");

            sb.Append("     )rp INNER JOIN Patient_master PM ON rp.PatientID=PM.PatientID and pm.PatientID<>'CASH002'");

            if (PatientName != "")
                sb.Append("   AND PM.PName like '" + PatientName + "%'");
            else if (PatientID != "")
                sb.Append("    AND PM.PatientID ='" + PatientID + "'");
            else if (ReceiptNo != "")
                sb.Append("   AND ReceiptNo= '" + ReceiptNo + "'");



            sb.Append("    order by DATE,ReceiptNo");
            sb.Append(" )a WHERE a.TypeOfTnx NOT IN ('Pharmacy-Issue','Pharmacy-Return') ");
            Items = StockReports.GetDataTable(sb.ToString());
            return Items;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }

    protected void btnView_Click(object sender, EventArgs e)
    {
        string Centre = "";
        lblMsg.Text = "";
        Centre = All_LoadData.SelectCentre(chkCentre);
        if (Centre == "")
        {
            lblMsg.Text = "Please Select Centre";
            return;
        }
        GridView1.DataSource = null;
        GridView1.DataBind();
        string fromDate = "", toDate = "", receiptNo = "", patientName = "", billNo = "", pateintID = "";

        if (txtReceiptNo.Text != "")
        {
            receiptNo = txtReceiptNo.Text.Trim();
        }

        if (receiptNo == "")
        {
            fromDate = Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd");
            toDate = Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd");
        }

        if (txtPatientName.Text != "")
        {
            patientName = txtPatientName.Text.Trim();
        }

        if (txtBillNo.Text != "")
        {
            billNo = txtBillNo.Text.Trim();
        }
        if (txtRegNo.Text != "")
        {
            pateintID = txtRegNo.Text.Trim();
        }

        DataTable dt = GetReceiptDetailnew(fromDate, toDate, receiptNo, billNo, patientName, pateintID, Centre);
        ViewState["search"] = dt;
        if (dt != null && dt.Rows.Count > 0)
        {
            lblMsg.Text = "";
            GridView1.DataSource = dt;
            GridView1.DataBind();
            pnlHide.Visible = true;
        }
        else
        {
            lblMsg.Text = "No Record Found";
            pnlHide.Visible = false;
        }
    }

    protected void GridView1_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        GridView1.PageIndex = e.NewPageIndex;
        DataTable dt = ViewState["search"] as DataTable;
        GridView1.DataSource = dt;
        GridView1.DataBind();
    }




    protected void btnReport_Click(object sender, EventArgs e)
    {
        string Centre = "";
        lblMsg.Text = "";
        Centre = All_LoadData.SelectCentre(chkCentre);
        if (Centre == "")
        {
            lblMsg.Text = "Please Select Centre";
            return;
        }
        string fromDate = "", toDate = "", receiptNo = "", patientName = "", billNo = "", pateintID = "";

        if (txtReceiptNo.Text != "")
        {
            receiptNo = txtReceiptNo.Text.Trim();
        }

        if (receiptNo == "")
        {
            fromDate = Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd");
            toDate = Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd");
        }

        if (txtPatientName.Text != "")
        {
            patientName = txtPatientName.Text.Trim();
        }

        if (txtBillNo.Text != "")
        {
            billNo = txtBillNo.Text.Trim();
        }
        if (txtRegNo.Text != "")
        {
            pateintID = txtRegNo.Text.Trim();
        }
        DataTable dt = GetReceiptDetailnew(fromDate, toDate, receiptNo, billNo, patientName, pateintID, Centre);
        if (dt != null && dt.Rows.Count > 0)
        {
            DataColumn dc = new DataColumn();
            dc.ColumnName = "Period";
            dc.DefaultValue = "Period From : " + Util.GetDateTime(ucFromDate.Text).ToString("dd-MMM-yyyy") + " To : " + Util.GetDateTime(ucToDate.Text).ToString("dd-MMM-yyyy");
            dt.Columns.Add(dc);
            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());
            ds.Tables[0].TableName = "table1";
            //ds.WriteXmlSchema(@"E:\PatientHistoryReport1.xml");
            Session["ds"] = ds;
            Session["ReportName"] = "PatientHistoryReport";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Design/common/Commonreport.aspx');", true);
        }
    }
}