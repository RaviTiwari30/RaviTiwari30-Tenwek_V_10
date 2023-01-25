using System;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Linq;

public partial class Design_IPD_IPDReceptReprint : System.Web.UI.Page
{
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

        ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Design/IPD/ReceiptIPD.aspx?PID=" + Util.GetString(dtReceipt.Rows[0]["PatientID"]) + "&cmd=reprint');", true);
    }

    public DataTable GetReceiptDetailnew(string FromDate, string ToDate, string ReceiptNo, string BillNo, string PatientName, string PatientID)
    {
        DataTable Items = new DataTable();
        try
        {
            string IsAllowedOriginalPrint = "false";
            DataTable Authority = (DataTable)ViewState["Authority"];
            if (Authority.Rows.Count > 0)
            {
                if (Authority.Rows[0]["IsAllowedOriginalPrint"].ToString() == "1")
                {
                    IsAllowedOriginalPrint = "true";
                }
            }

            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT * FROM ( ");
            sb.Append(" SELECT '" + IsAllowedOriginalPrint + "' IsAllowedOriginalPrint,");
            sb.Append(" PM.PName,CONCAT(IFNULL(PM.House_No,''),' ',IFNULL(PM.Street_Name,''),' ',IFNULL(PM.Locality,''),'-',IFNULL(PM.City,''),', ',IFNULL(PM.Country,''))Address , ");
            sb.Append(" IF(ReceiptNo<>'','CASH','CREDIT')PaymentMode,RP.ReceiptNo,BillNo,DATE_FORMAT(RP.date,'%d-%b-%Y')DATE , ");
            sb.Append(" ROUND(rp.AmountPaid,2)AmountPaid, CASE WHEN ( TypeOfTnx IS NULL AND RP.TransactionID = '' ) THEN 'OPD Advance/Settlement' WHEN (RP.LedgerNoDr='HOSP0005') THEN 'OPDSettlement' ");
            sb.Append(" WHEN ( TypeOfTnx IS NULL AND RP.TransactionID <> '' ) THEN 'IPD' ELSE TypeOfTnx END AS TypeOfTnx,rp.depositor,LedgerNoCr,RP.TransactionID, ");
            sb.Append(" (Select DoctorID from patient_medical_history where TransactionID=RP.TransactionID)DoctorID,LedgerTransactionNo , IFNULL((SELECT IFNULL(ConfigID,'')ConfigID FROM f_ledgertnxdetail ltd WHERE ltd.LedgerTransactionNo=rp.LedgerTransactionNo AND ltd.ConfigID=5 LIMIT 1),'')ConfigID ");
            sb.Append(" FROM ( SELECT rt.ReceiptNo, ");
            sb.Append(" IF(ltl.NetAmount IS NOT NULL,ltl.NetAmount,IF(lt.NetAmount IS NULL,IF(rtl.AmountPaid IS NOT NULL,rtl.AmountPaid,rt.AmountPaid), ");
            sb.Append("  IF(rt.`LedgerNoCr`='OPD003',rt.`AmountPaid`,lt.NetAmount) ");
            sb.Append("    ))AmountPaid, ");
            sb.Append(" lt.TypeOfTnx,rt.TransactionID,rt.AsainstLedgerTnxNo, lt.LedgerTransactionNo,lt.BillNo,rt.date,rt.time, ");
            sb.Append(" IF(lt.LedgerNoCr IS NULL,rt.LedgerNoCr,lt.LedgerNoCr)LedgerNoCr,rt.depositor,lt.PaymentModeID,IFNULL(rt.LedgerNoDr,'')LedgerNoDr  ");
            sb.Append("  FROM f_reciept rt ");
            sb.Append(" LEFT JOIN f_ledgertransaction lt ON rt.AsainstLedgerTnxNo = lt.LedgerTransactionNo AND lt.Iscancel=0 ");
            sb.Append(" LEFT JOIN f_reciept_log rtl ON rtl.ReceiptNo=rt.ReceiptNo LEFT JOIN f_ledgertransaction_log ltl ON rt.AsainstLedgerTnxNo = ltl.LedgerTransactionNo AND ltl.Iscancel=0  ");
            sb.Append(" WHERE rt.IsCancel=0 AND rt.CentreID='" + Session["CentreID"].ToString() + "' ");

            if (PatientID != "")
                sb.Append(" and rt.depositor ='" + Util.GetFullPatientID(PatientID) + "' ");
            if (ReceiptNo != "")
                sb.Append(" and rt.ReceiptNo like '" + ReceiptNo + "' ");

            if (ReceiptNo == "" && BillNo == "" && PatientID == "")
            {
                if (FromDate != "" && ToDate != "")
                {
                    sb.Append(" and Date(rt.date)>='" + FromDate + "' and date(rt.date)<='" + ToDate + "'  ");
                }
            }

            sb.Append(" )rp INNER JOIN Patient_master PM ON rp.depositor=PM.PatientID and pm.PatientID<>'CASH002'");

            if (PatientName != "")
            {
                sb.Append(" and PM.PName like '" + PatientName + "%'");
            }
            if (PatientID != "")
            {
                sb.Append(" and PM.PatientID ='" + Util.GetFullPatientID(PatientID) + "'");
            }
            if (ReceiptNo != "")
            {
                sb.Append(" and ReceiptNo= '" + ReceiptNo + "'");
            }
            sb.Append(" ORDER BY ReceiptNo DESC ");
            sb.Append(" )a WHERE TypeOfTnx IN ('IPD') ORDER BY DATE DESC ");

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

        DataTable dt = GetReceiptDetailnew(fromDate, toDate, receiptNo, billNo, patientName, pateintID);
        ViewState["search"] = dt;
        if (dt != null && dt.Rows.Count > 0)
        {
            lblMsg.Text = "";
            GridView1.DataSource = dt;
            GridView1.DataBind();
            pnlHide.Visible = true;
            decimal total = dt.AsEnumerable().Sum(row => row.Field<decimal>("AmountPaid"));
            GridView1.FooterRow.Cells[4].Text = "Total :";
            GridView1.FooterRow.Cells[4].HorizontalAlign = HorizontalAlign.Right;

            GridView1.FooterRow.Cells[5].Text = total.ToString("N2");
            GridView1.FooterRow.Cells[5].HorizontalAlign = HorizontalAlign.Right;
        }
        else
        {
            pnlHide.Visible = false;
            lblMsg.Text = "No Record Found";
        }
    }

    protected void GridView1_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        GridView1.PageIndex = e.NewPageIndex;
        DataTable dt = ViewState["search"] as DataTable;
        GridView1.DataSource = dt;
        GridView1.DataBind();
    }

    protected void GridView1_SelectedIndexChanged(object sender, EventArgs e)
    {
        string dtLedTno = ""; int ChkOriginalPrint = 1;
        string receiptNo = ((Label)GridView1.SelectedRow.FindControl("lblReceiptNo")).Text.Trim();
        string billNo = ((Label)GridView1.SelectedRow.FindControl("lblBillNo")).Text.Trim();

        Label lbPaymentMode = (Label)GridView1.SelectedRow.FindControl("lblPaymentMode");
        Label lblTypeofTnx = (Label)GridView1.SelectedRow.FindControl("lblTypeofTnx");

        string tid = ((Label)GridView1.SelectedRow.FindControl("lblTID")).Text;
        string patientID = ((Label)GridView1.SelectedRow.FindControl("lblPID")).Text;
        string doctorID = ((Label)GridView1.SelectedRow.FindControl("lblDoctorID")).Text;
        string LedgerTransactionNo = ((Label)GridView1.SelectedRow.FindControl("lblLedgerTransactionNo")).Text;
        string format = ((RadioButtonList)GridView1.SelectedRow.FindControl("rbtformat")).SelectedValue;
        string Isconfig = Util.GetString(StockReports.ExecuteScalar("select ConfigID from f_ledgertnxdetail ltd where ltd.ledgertransactionNo='" + LedgerTransactionNo + "' and ltd.ConfigID=5"));

        CheckBox chkAllowedOriginalPrint = (CheckBox)GridView1.SelectedRow.FindControl("chkAllowedOriginalPrint");
        if (chkAllowedOriginalPrint.Checked)
            ChkOriginalPrint = 0;

        int IsBill = 0;
        dtLedTno = LedgerTransactionNo;
        if (lblTypeofTnx.Text.ToUpper() != "IPD")
        {
            if (Resources.Resource.ReceiptPrintFormat == "0")
            {
                if (lblTypeofTnx.Text.ToUpper() == "OPD-PROCEDURE" || lblTypeofTnx.Text.ToUpper() == "OPD-LAB" || lblTypeofTnx.Text.ToUpper() == "OPD-OTHERS" || lblTypeofTnx.Text.ToUpper() == "OPD-BILLING" || lblTypeofTnx.Text.ToUpper() == "OPD-ADVANCE" || lblTypeofTnx.Text.ToUpper() == "EMERGENCY")
                {
                    PrintOPDCard(receiptNo, patientID, doctorID, lblTypeofTnx.Text.ToUpper(), billNo, lbPaymentMode.Text.Trim().ToUpper(), format, ChkOriginalPrint);
                }
                else if (lblTypeofTnx.Text.ToUpper() == "OPD-PACKAGE")
                {
                    PrintReport(LedgerTransactionNo, format, ChkOriginalPrint, receiptNo);
                }
                else if (Isconfig == "3")//lblTypeofTnx.Text.ToUpper() == "OPD-APPOINTMENT"
                {
                    PrintOPDCard(receiptNo, patientID, doctorID, "OPD-APPOINTMENT", billNo, lbPaymentMode.Text.Trim(), format, ChkOriginalPrint);
                }
                else if (lblTypeofTnx.Text.ToUpper() == "OPD ADVANCE/SETTLEMENT")
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Design/Common/ReceiptOPD.aspx?ReceiptNo=" + receiptNo + "&TransactionID=" + tid + "&Duplicate=" + ChkOriginalPrint + "');", true);
                }
                if (lblTypeofTnx.Text.ToUpper() == "OPDSETTLEMENT" && lbPaymentMode.Text == "CREDIT")
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key3", "window.open('../../Design/common/CreditBillReceipt.aspx?LedgerTransactionNo=" + dtLedTno + "&ReceiptNo=" + receiptNo + "');", true);
                }
                else if (lblTypeofTnx.Text.ToUpper() == "OPDSETTLEMENT")
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key3", "window.open('../../Design/common/ReceiptOPD.aspx?LedgerTransactionNo=" + dtLedTno + "&ReceiptNo=" + receiptNo + "&TransactionID=" + tid + "');", true);
                    //  ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Design/Common/CommonReceipt.aspx?ReceiptNo=" + receiptNo + "&LedgerTransactionNo=" + dtLedTno + "&IsBill=" + IsBill + "&Duplicate=" + ChkOriginalPrint + "');", true);
                }
            }
            else
            {
                if (rblCon.SelectedIndex == 0)
                    IsBill = 1;
                if (format == "2" && Isconfig == "5")
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key5", "window.open('../../Design/common/OPDCard.aspx?LedgerTransactionNo=" + dtLedTno + "');", true);
                }
                else
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Design/Common/CommonReceipt_pdf.aspx?ReceiptNo=" + receiptNo + "&LedgerTransactionNo=" + dtLedTno + "&IsBill=" + IsBill + "&Duplicate=" + ChkOriginalPrint + "&Type=OPD');", true);
                }
            }
        }
        if (lblTypeofTnx.Text.ToUpper() == "IPD")
        {
            if (Resources.Resource.ReceiptPrintFormat == "0")
            {
                int count = Util.GetInt(StockReports.ExecuteScalar("select count(*) from f_reciept_log where ReceiptNo = '" + receiptNo + "' "));

                StringBuilder sb = new StringBuilder();
                sb.Append(" select rec.Depositor AS PatientID,rec.AmountPaid AS Amount,rpd.PaymentMode,rpd.BankName,rpd.RefNo,rec.TransactionID As TransactionID,");
                sb.Append(" rec.ReceiptNo AS ReceiptNo,Date_format(rec.Date,'%d-%b-%y')Date,Time_format(rec.Time,'%H:%I:%S')Time,rec.Naration,");
                sb.Append(" (select CONCAT(Title,' ',PName) from patient_master where PatientID = rec.Depositor) AS Patient_Name,(select CONCAT(Title,' ',Name) from employee_master where Employee_id = rec.Reciever) AS PreparedBy,");
                sb.Append(" (select CONCAT(Title,' ',Name) from doctor_master where DoctorID = (select DoctorID from patient_medical_history where TransactionID = rec.TransactionID)) AS ");
                sb.Append(" Consultant_Name,(select CONCAT(Floor,'/',Name) from room_master where Room_Id in (select Room_ID from patient_ipd_profile");
                sb.Append(" where TransactionID = rec.TransactionID and Status = 'IN' ))AS Room_No,");
                sb.Append(" (select Company_Name from f_panel_master where PanelID = (select PanelID from patient_medical_history where TransactionID = rec.TransactionID)) AS CompanyName");
                if (count == 0)
                {
                    sb.Append(" from f_reciept rec INNER JOIN f_receipt_paymentdetail rpd ON rpd.ReceiptNo = rec.ReceiptNo WHERE rec.ReceiptNo = '" + receiptNo + "'");
                }
                else
                {
                    sb.Append(" from f_reciept_log rec INNER JOIN f_receipt_paymentdetail_log rpd ON rpd.ReceiptNo = rec.ReceiptNo WHERE rec.ReceiptNo = '" + receiptNo + "'");
                }
                DataTable dt = new DataTable();
                dt = StockReports.GetDataTable(sb.ToString()).Copy();
                if (dt.Rows.Count > 0)
                    GetReceipt(dt);
            }
            else
            {
                //ScriptManager.RegisterStartupScript(this, this.GetType(), "IPD", "window.open('../../Design/common/commonReceipt_pdf.aspx?ReceiptNo=" + receiptNo + "'&Type=IPD&Duplicate=1);", true);
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Design/Common/CommonPrinterOPDThermal.aspx?ReceiptNo=" + receiptNo + "&Duplicate=" + ChkOriginalPrint + "&Type=IPD');", true);
            }
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtReceiptNo.Focus();
            ucFromDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            ucToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            ViewState["RoleDept"] = Session["RoleID"].ToString();
            ViewState["EmpName"] = Session["LoginName"].ToString();
            ViewState["EmpID"] = Session["ID"].ToString();
            DataTable dtAuthority = StockReports.GetAuthorization(Util.GetInt(Session["RoleID"]), Util.GetString(Session["ID"]));
            ViewState["Authority"] = dtAuthority;
        }

        ucFromDate.Attributes.Add("readOnly", "true");
        ucToDate.Attributes.Add("readOnly", "true");
    }

    private void PrintOPDCard(string receiptNo, string PatientID, string DoctorID, string TypeOfTnx, string billNo, string receiptPaymentType, string format, int ChkOriginalPrint)
    {
        string dtLedTno = "";
        if (receiptPaymentType == "CREDIT")
            dtLedTno = StockReports.ExecuteScalar("SELECT LedgerTransactionNo FROM f_ledgertransaction  WHERE BillNo='" + billNo + "'");
        else
            dtLedTno = StockReports.ExecuteScalar("SELECT LedgerTransactionNo FROM f_ledgertransaction lt INNER JOIN f_reciept r ON r.AsainstLedgerTnxNo = lt.LedgerTransactionNo WHERE r.ReceiptNo='" + receiptNo + "'");
        if ((format == "0") || (format == "1"))
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key4", "window.open('../../Design/common/CommonReceipt.aspx?LedgerTransactionNo=" + dtLedTno + "&IsBill=" + format + "&ReceiptNo=" + receiptNo + "&Duplicate=" + ChkOriginalPrint + "');", true);
        else
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key5", "window.open('../../Design/common/OPDCard.aspx?LedgerTransactionNo=" + dtLedTno + "');", true);
    }

    private void PrintReport(string LedgerTransactionNo, string format, int ChkOriginalPrint, string receiptNo)
    {
        ScriptManager.RegisterStartupScript(this, this.GetType(), "key4", "window.open('../../Design/common/OPDPackageReceipt.aspx?LedgerTransactionNo=" + LedgerTransactionNo + "&IsBill=" + format + "&Duplicate=" + ChkOriginalPrint + "&ReceiptNo=" + receiptNo + "');", true);
    }

    protected void GridView1_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowIndex > -1)
        {
            if (rblCon.SelectedValue == "1")
            {
                ((RadioButtonList)e.Row.FindControl("rbtformat")).Items[0].Text = "Bill";
                ((RadioButtonList)e.Row.FindControl("rbtformat")).Items[0].Value = "1";
            }
            else
            {
                ((RadioButtonList)e.Row.FindControl("rbtformat")).Items[0].Text = "Receipt";
                ((RadioButtonList)e.Row.FindControl("rbtformat")).Items[0].Value = "0";
            }
        }
    }
}