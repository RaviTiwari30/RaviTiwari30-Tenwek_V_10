using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_OPD_PaymentModeWiseCollection : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtFromTime.Text = "00:00 AM";
            txtToTime.Text = "11:59 PM";
            All_LoadData.bindCentre(chkCentre, Session["ID"].ToString(), btnReport);

            BindPaymentMode();
        }
    }
    private void BindPaymentMode()
    {
        DataTable dt = StockReports.GetDataTable("SELECT PaymentModeID,PaymentMode FROM paymentmode_master WHERE Active=1 AND PaymentModeID NOT IN(1,4)");
        if (dt.Rows.Count > 0)
        {
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                chkPaymentMode.Items.Add(new ListItem(dt.Rows[i]["PaymentMode"].ToString(), dt.Rows[i]["PaymentModeID"].ToString()));
                chkPaymentMode.Items[i].Selected = true;
            }



        }
    }
    private string GetSelection(CheckBoxList cbl)
    {
        string str = string.Empty;

        foreach (ListItem li in cbl.Items)
        {
            if (li.Selected)
            {
                if (str != string.Empty)
                    str += ",'" + li.Value + "'";
                else
                    str = "'" + li.Value + "'";
            }
        }

        return str;
    }
    protected void btnReport_Click(object sender, EventArgs e)
    {

        lblMsg.Text = string.Empty;
        if (Session["LoginType"] == null)
        {
            return;
        }
        string Centre = All_LoadData.SelectCentre(chkCentre);
        if (Centre == string.Empty)
        {
            lblMsg.Text = "Please Select Centre";
            return;
        }

        string startDate = string.Empty, toDate = string.Empty, PaymentModeID = string.Empty;

        PaymentModeID = GetSelection(chkPaymentMode);
        if (PaymentModeID == string.Empty)
        {
            lblMsg.Text = "Please Select PaymentMode";
            return;
        }
        if (Util.GetDateTime(txtFromDate.Text).ToString() != "")
            if (txtFromTime.Text.Trim() != string.Empty)
                startDate = Util.GetDateTime(Util.GetDateTime(txtFromDate.Text)).ToString("yyyy-MM-dd") + " " + Util.GetDateTime(txtFromTime.Text).ToString("HH:mm:ss");
            else
                startDate = Util.GetDateTime(Util.GetDateTime(txtFromDate.Text)).ToString("yyyy-MM-dd");

        if (Util.GetDateTime(txtToDate.Text).ToString() != string.Empty)
            if (txtToTime.Text.Trim() != string.Empty)
                toDate = Util.GetDateTime(Util.GetDateTime(txtToDate.Text)).ToString("yyyy-MM-dd") + " " + Util.GetDateTime(txtToTime.Text.Trim()).ToString("HH:mm:ss");
            else
                toDate = Util.GetDateTime(Util.GetDateTime(txtToDate.Text)).ToString("yyyy-MM-dd");



        StringBuilder sb1 = new StringBuilder();
        // for cash only
       
        sb1.Append("  SELECT lt.TransactionID,lt.BillNo,rec.ReceiptNo,lt.PatientID MRNo, IF(pm.PatientID='CASH002',(SELECT  NAME FROM patient_general_master WHERE AgainstLedgerTnxNo=lt.LedgerTransactionNo),(SELECT Pname FROM patient_master WHERE PatientID=pm.PatientID))Pname, ");
        sb1.Append("  CONCAT(DATE_FORMAT(rec.date,'%d %b %Y'),' ',DATE_FORMAT(rec.time,'%H:%i'))DATE,NetAmount,SUM(IF(rec_pay.PaymentModeID=5,0,rec_pay.Amount))PaidAmount,lt.RoundOff, ");
        sb1.Append("  rec_pay.S_Amount Amount,rec_pay.PaymentMode,rec_pay.BankName,rec_pay.refNo,em.Name UserName,cm.CentreName,cm.CentreID,DATE_FORMAT(rec.date,'%d %b %Y')ReceiptDate,rec_pay.PaymentModeID FROM f_reciept Rec ");
        sb1.Append("  INNER JOIN f_receipt_paymentdetail rec_pay ON rec_pay.ReceiptNo=rec.ReceiptNo  ");
        sb1.Append("  INNER JOIN f_ledgertransaction lt   ON lt.LedgerTransactionNo=rec.AsainstLedgerTnxNo   ");
        sb1.Append("  INNER JOIN patient_master pm ON pm.PatientID=lt.PatientID");
        sb1.Append("  INNER JOIN employee_master em ON rec.Reciever=em.EmployeeID INNER JOIN Center_master cm ON cm.CentreID = rec.CentreID ");
        sb1.Append("  WHERE lt.PaymentModeID<>4 AND rec.LedgerNoDr<>'HOSP0005'  AND rec_pay.isopdadvance=0   AND  rec.Iscancel=0 AND lt.IsCancel=0  ");
        sb1.Append("  AND CONCAT(rec.Date,' ',rec.Time)>='" + startDate + "' AND CONCAT(rec.Date,' ',rec.Time)<='" + toDate + "' ");
        sb1.Append("  AND rec_pay.PaymentModeID IN (" + PaymentModeID + ") AND rec.CentreID IN (" + Centre + ") ");
        sb1.Append("  GROUP BY rec_pay.ReceiptNo ");


        sb1.Append("  UNION ALL");
        sb1.Append(" SELECT rec.TransactionID,'' BillNo,rec.ReceiptNo,pm.PatientID MRNo,pm.Pname, ");
        sb1.Append(" CONCAT(DATE_FORMAT(rec.date,'%d %b %Y'),' ',DATE_FORMAT(rec.time,'%H:%i'))DATE,NetAmount,SUM(rec_pay.Amount)PaidAmount,lt.RoundOff,");
        sb1.Append(" rec_pay.S_Amount Amount,rec_pay.PaymentMode,rec_pay.BankName,rec_pay.refNo , ");
        sb1.Append(" em.Name UserName,cm.CentreName,cm.CentreID,DATE_FORMAT(rec.date,'%d %b %Y')ReceiptDate,rec_pay.PaymentModeID FROM f_reciept Rec ");
        sb1.Append(" INNER JOIN f_receipt_paymentdetail rec_pay  ON rec_pay.ReceiptNo=rec.ReceiptNo ");
        sb1.Append(" INNER JOIN f_ledgertransaction lt   ON lt.LedgerTransactionNo=rec.AsainstLedgerTnxNo   ");
        sb1.Append(" INNER JOIN patient_master pm ON pm.PatientID=lt.PatientID INNER JOIN employee_master em ON rec.Reciever=em.EmployeeID");
        sb1.Append(" INNER JOIN Center_master cm ON cm.CentreID = rec.CentreID  WHERE rec_pay.isopdadvance=1 AND TypeOfTnx='OPD-Advance' AND  rec.Iscancel=0 AND lt.IsCancel=0 ");
        sb1.Append(" AND CONCAT(rec.Date,' ',rec.Time)>='" + startDate + "' AND CONCAT(rec.Date,' ',rec.Time)<='" + toDate + "' AND rec_pay.PaymentModeID in (" + PaymentModeID + ") ");
        sb1.Append("  AND rec.CentreID IN (" + Centre + ")  GROUP BY rec_pay.ReceiptNo ");


        //for adjustment

        sb1.Append("  UNION ALL");
        sb1.Append("  SELECT rec.TransactionID,''BillNo,rec.ReceiptNo,rec.Depositor MR_NO,CONCAT(pm.Title,' ',pm.PName)PName ,");
        sb1.Append("  CONCAT(DATE_FORMAT(rec.date,'%d %b %Y'),' ',DATE_FORMAT(rec.time,'%H:%i'))DATE,AmountPaid NetAmount,SUM(IF(rec_pay.PaymentModeID=5 ,0,rec_pay.S_Amount))PaidAmount,rec.RoundOff, ");
        sb1.Append("  rec_pay.S_Amount Amount,rec_pay.PaymentMode,rec_pay.BankName,rec_pay.refNo ,em.Name UserName,cm.CentreName,cm.CentreID,DATE_FORMAT(rec.date,'%d %b %Y')ReceiptDate,rec_pay.PaymentModeID ");
        sb1.Append("  FROM  f_reciept rec  ");
        sb1.Append("  inner join patient_master pm on pm.PatientID=rec.Depositor ");
        sb1.Append("  inner join f_receipt_paymentdetail rec_pay on rec_pay.ReceiptNo=rec.ReceiptNo ");
        sb1.Append("  inner join employee_master em on em.EmployeeID=rec.Reciever INNER JOIN Center_master cm ON cm.CentreID = rec.CentreID ");
        sb1.Append("  where    rec.IsCancel=0 and CONCAT(rec.Date,' ',rec.time)>='" + startDate + "' AND CONCAT(rec.Date,' ',rec.time)<='" + toDate + "'  AND rec.CentreID IN (" + Centre + ") AND rec_pay.PaymentModeID in (" + PaymentModeID + ") GROUP BY rec_pay.ReceiptNo ");

        //for IPD advance

        sb1.Append("  UNION ALL");
        sb1.Append("  SELECT rec.TransactionID,''BillNo,rec.ReceiptNo,rec.Depositor MR_NO,CONCAT(pm.Title,' ',pm.PName)PName, ");
        sb1.Append("  CONCAT(DATE_FORMAT(rec.date,'%d %b %Y'),' ',DATE_FORMAT(rec.time,'%H:%i'))DATE,AmountPaid NetAmount,SUM(rec_pay.Amount)PaidAmount,rec.RoundOff, ");
        sb1.Append("   rec_pay.S_Amount Amount ,rec_pay.PaymentMode,rec_pay.BankName,rec_pay.refNo ,em.Name UserName,cm.CentreName,cm.CentreID,DATE_FORMAT(rec.date,'%d %b %Y')ReceiptDate,rec_pay.PaymentModeID FROM f_reciept rec");
        sb1.Append("  INNER JOIN patient_medical_history pmh ON pmh.TransNo=rec.TransactionID ");
        sb1.Append("  INNER JOIN patient_master pm ON pm.PatientID=rec.Depositor ");
        sb1.Append("  INNER JOIN employee_master em ON rec.Reciever=em.EmployeeID INNER JOIN Center_master cm ON cm.CentreID = rec.CentreID ");
        sb1.Append("  INNER JOIN f_receipt_paymentdetail rec_pay ON rec.ReceiptNo=rec_pay.ReceiptNo");
        sb1.Append("  WHERE rec.IsCancel=0 and CONCAT(rec.Date,' ',rec.time)>='" + startDate + "' AND CONCAT(rec.Date,' ',rec.time)<='" + toDate + "'  AND rec.CentreID IN (" + Centre + ") AND rec_pay.PaymentModeID in (" + PaymentModeID + ") ");
        sb1.Append("  GROUP BY rec_pay.ReceiptNo,rec_pay.PaymentModeID");

        sb1.Append("  ");
        DataTable dt = StockReports.GetDataTable(sb1.ToString());
        if (dt.Rows.Count > 0)
        {
            DataColumn dc = new DataColumn();
            dc.ColumnName = "Period";
            dc.DefaultValue = "From : " + Util.GetDateTime(txtFromDate.Text).ToString("dd-MMM-yyyy") + " , " + Util.GetDateTime(txtFromTime.Text).ToString("hh:mm tt") + " To : " + Util.GetDateTime(txtToDate.Text).ToString("dd-MMM-yyyy") + " , " + Util.GetDateTime(txtToTime.Text).ToString("hh:mm tt");
            dt.Columns.Add(dc);

            DataSet ds = new DataSet();

            ds.Tables.Add(dt.Copy());
          //  ds.WriteXmlSchema(@"E:\\CollectionReportPaymentWise.xml");
            Session["ds"] = ds;
            Session["ReportName"] = "CollectionReportPaymentWise";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/Commonreport.aspx');", true);
        }
        else
            lblMsg.Text = "Record Not Found";
    }
}