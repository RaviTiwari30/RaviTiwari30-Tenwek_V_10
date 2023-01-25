using System;
using System.Data;
using System.Web.UI;
using System.Text;

public partial class Design_OPD_CancelReceipt : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromDate.Text = DateTime.Now.Date.ToString("dd-MMM-yyyy");
            txtTodate.Text = DateTime.Now.Date.ToString("dd-MMM-yyyy");
            All_LoadData.bindCentre(chkCentre, Session["ID"].ToString(), btnPrint);
        }
        txtFromDate.Attributes.Add("readOnly", "true");
        txtTodate.Attributes.Add("readOnly", "true");



    }
    protected void btnPrint_Click(object sender, EventArgs e)
    {
        string Centre = All_LoadData.SelectCentre(chkCentre);
        if (Centre == "")
        {
            lblMsg.Text = "Please Select Centre";
            return;
        }

        DataTable dt = new DataTable();

        if (rdbReport.SelectedValue == "0")
            dt = LoadCancelledReceipt(txtFromDate.Text.Trim(), txtTodate.Text.Trim(),Centre).Copy();
        else if (rdbReport.SelectedValue == "1")
            dt = LoadCancelledBill(txtFromDate.Text.Trim(), txtTodate.Text.Trim()).Copy();        

        if (dt != null && dt.Rows.Count > 0)
        {
            DataSet ds = new DataSet();
            DataColumn dc = new DataColumn();
            DataTable dtImg = All_LoadData.CrystalReportLogo();
            dc.ColumnName = "Period";
            dc.DefaultValue = "From " + txtFromDate.Text.Trim() + " To " + txtTodate.Text.Trim();
            dt.Columns.Add(dc);

            if (rdbReport.SelectedValue == "0")
            {
                dc = new DataColumn();
                dc.ColumnName = "Report";
                dc.DefaultValue = "Receipt Cancelled Report";
                dt.Columns.Add(dc);
                dc = new DataColumn();
               
                dc.ColumnName = "UserName";
                dc.DefaultValue = StockReports.GetUserName(Convert.ToString(Session["ID"])).Rows[0][0];
                dt.Columns.Add(dc);
                
                Session["ReportName"] = "CancelledReceipt";
               
            }
            else if (rdbReport.SelectedValue == "1")
            {
                dc = new DataColumn();
                dc.ColumnName = "Report";
                dc.DefaultValue = "Bill Cancelled Report";
                dt.Columns.Add(dc);
                DataColumn dc2 = new DataColumn();
                dc2.ColumnName = "UserName";
                dc2.DefaultValue = StockReports.GetUserName(Convert.ToString(Session["ID"])).Rows[0][0];
                dt.Columns.Add(dc2);
                
                Session["ReportName"] = "CancelledBill";
                
            }
            ds.Tables.Add(dtImg.Copy());
            ds.Tables.Add(dt.Copy());
            Session["ds"] = ds;
           // ds.WriteXmlSchema("e:\\CancelledBill.xml");
            
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/Commonreport.aspx');", true);

       }
       else

            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
        
    }

    private DataTable LoadCancelledReceipt(string FromDate, string ToDate, string Centre)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("Select (Select concat(Title,' ',Pname) from patient_master where PatientID=rt.Depositor)PatientName,");
        sb.Append("(Select Name from employee_master where employeeid = rt.Reciever)EmpName,");
        sb.Append("ReceiptNo,CentreID,CentreName,AmountPaid,Date,TransactionID,CancelReason, Cancel_UserID,CancelDate,'0' as ReportType from ");
        sb.Append("(Select cm.`CentreID`,cm.`CentreName`,ReceiptNo,AmountPaid,Date,Reciever,Depositor,TransactionID,ifNull(CancelReason,Naration)CancelReason,(Select Name from employee_master where employeeid = Cancel_UserID)Cancel_UserID,CancelDate ");
        sb.Append("from f_reciept INNER JOIN center_master cm ON cm.`CentreID`=f_reciept.`CentreID` where date(date) >='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' and date(date) <='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "' and IsCancel=1 and f_reciept.`CentreID` in ("+Centre+") )rt ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return dt;
    }

    private DataTable LoadCancelledBill(string FromDate, string ToDate)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("Select (Select concat(Title,' ',Pname) from patient_master where PatientID=rt.PatientID)PatientName,");
        sb.Append("(Select Name from employee_master where employeeid = rt.BillGenerateUserID)EmpName,");
        sb.Append("BillNo,CancelDate,CancelUserID,CancelReason,BillDate,TransactionID,PatientID ");
        sb.Append("from ");
        sb.Append("    (Select BillNo,CancelDate,(Select Name from employee_master where employeeid = CancelUserID)CancelUserID,CancelReason,BillDate,BillGenerateUserID,TransactionID,PatientID from ");
        sb.Append("f_billcancellation where date(BillDate) >='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd")+ "' and date(BillDate) <='" +Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " ' )rt ");       

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return dt;
    }

    
}
