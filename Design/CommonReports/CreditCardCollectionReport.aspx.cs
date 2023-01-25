using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Text;

public partial class Design_CommonReports_CreditCardCollectionReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ucFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            ucToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
           
            ViewState["UserID"] = Session["ID"].ToString();
            All_LoadData.bindCentre(chkCentre, Session["ID"].ToString(), btnReport);
                    
        }
        ucFromDate.Attributes.Add("readOnly", "true");
        ucToDate.Attributes.Add("readOnly", "true");

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
        string startDate = string.Empty, toDate = string.Empty;
        if (Util.GetDateTime(ucFromDate.Text).ToString() != "")
                startDate = Util.GetDateTime(Util.GetDateTime(ucFromDate.Text)).ToString("yyyy-MM-dd");
        if (Util.GetDateTime(ucToDate.Text).ToString() != string.Empty)
                toDate = Util.GetDateTime(Util.GetDateTime(ucToDate.Text)).ToString("yyyy-MM-dd") + " 23:59:59";
       StringBuilder sb = new StringBuilder();

       sb.Append("SELECT cm.CentreName,DATE_FORMAT(lt.BillDate,'%d-%b-%Y')BillDate,lt.BillNo,pm.PatientID AS UHID,CONCAT(pm.Title,'',pm.PName)PatientName, ");
       sb.Append("rc.ReceiptNo,DATE_FORMAT(rc.Date,'%d-%b-%Y') AS ReceiptDate,SUM(rpay.Amount)AmountReceived,rpay.SwipeMachine,rpay.BankName AS CardName,rpay.RefNo AS CardNo,CONCAT(em.Title,'',em.Name) AS UserName FROM f_reciept rc  ");
       sb.Append("INNER JOIN f_receipt_paymentdetail rpay ON rc.ReceiptNo=rpay.ReceiptNo ");
       sb.Append("LEFT JOIN f_ledgertransaction lt ON lt.LedgertransactionNo=rc.AsainstLedgerTnxNo ");
       sb.Append("INNER JOIN Patient_master pm ON pm.PatientID=rc.Depositor ");
       sb.Append("INNER JOIN employee_master em ON em.Employee_ID=rc.Reciever ");
       sb.Append("INNER JOIN center_master cm ON cm.CentreID=rc.CentreID ");
       sb.Append("WHERE rc.IsCancel=0 AND CONCAT(rc.Date,' ',rc.Time)>='"+startDate+"' AND CONCAT(rc.Date,' ',rc.Time)<='"+toDate+"' ");
       sb.Append("AND rc.CentreID IN ("+Centre+") AND rpay.PaymentModeID IN (3) ");
       sb.Append("GROUP BY rc.ReceiptNo Order by rc.Date,rc.Time,rc.ReceiptNo");

       DataTable dt = StockReports.GetDataTable(sb.ToString());
       if (dt.Rows.Count > 0)
       {
           DataRow dr = dt.NewRow();
           dr[6] = "Total Collection ";
           dr["AmountReceived"] = dt.Compute("Sum(AmountReceived)","");
           dt.Rows.InsertAt(dr, dt.Rows.Count + 1);

           Session["ReportName"] = "Credit Card Collection Report";
           Session["dtExport2Excel"] = dt;
           Session["Period"] = "Period From : " + ucFromDate.Text.Trim() + " To : " + ucToDate.Text.Trim();
           ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/ExportToExcel.aspx');", true);
       }
       else
           lblMsg.Text = "No Record Found"; 
    }

  
  
  
  

  

  
    


}