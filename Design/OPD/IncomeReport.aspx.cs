using System;
using System.Linq;
using System.Web.UI;
using System.Text;
using System.Data;
using System.Web.UI.WebControls;

public partial class Design_OPD_IncomeReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            FillDateTime();
        }
        ucFromDate.Attributes.Add("readOnly", "true");
        ucToDate.Attributes.Add("readOnly", "true");
    }
    protected void btnPreview_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        if (Session["LoginType"] == null)
        {
            return;
        }
         LoginRestrict LR = new LoginRestrict();
         if (!LR.LoginDateRestrict(Util.GetString(Session["RoleID"]), Util.GetDateTime(Util.GetDateTime(ucFromDate.Text)), Util.GetString(Session["ID"])))
         {
             lblMsg.Text = LoginRestrict.LoginDateRestrictMSG();
             return;
         }

         StringBuilder sb1 = new StringBuilder();
         sb1.Append("SELECT TypeOfTnx,DisplayName FROM master_typeoftnx WHERE TYPE IN ('OPD','Pharmacy','Other')");
         DataTable cbl = StockReports.GetDataTable(sb1.ToString());
         string TypeOfTnx = string.Empty;

         for (int i = 0; i < cbl.Rows.Count;i++ )
         {
                 if (TypeOfTnx != string.Empty)
                     TypeOfTnx += ",'" + cbl.Rows[i]["TypeOfTnx"].ToString() + "'";
                 else
                     TypeOfTnx = "'" + cbl.Rows[i]["TypeOfTnx"] + "'";
             
         }
       
        string startDate = string.Empty, toDate = string.Empty;
        
        if (Util.GetDateTime(ucFromDate.Text).ToString() != "")
            
                startDate = Util.GetDateTime(Util.GetDateTime(ucFromDate.Text)).ToString("yyyy-MM-dd");

        if (Util.GetDateTime(ucToDate.Text).ToString()!= string.Empty)
            
                toDate = Util.GetDateTime(Util.GetDateTime(ucToDate.Text)).ToString("yyyy-MM-dd");

        
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT DATE,SUM(PaidAmount)Amount,PaymentMode FROM ( ");
            sb.Append(" SELECT DATE_FORMAT(lt.Date,'%d-%b-%Y')DATE,SUM(lt_pay.Amount)PaidAmount,lt_pay.PaymentMode FROM f_ledgertransaction lt  ");
            sb.Append("   INNER JOIN f_ledgertransaction_paymentdetail lt_pay ON lt_pay.LedgerTransactionNo=lt.LedgerTransactionNo");

            sb.Append("   WHERE TypeOfTnx IN (" + TypeOfTnx + ") AND lt.Date>='" + startDate + "' AND lt.Date<='" + toDate + "'   AND lt.`IsCancel`='0'");
            sb.Append(" GROUP BY DATE(lt.Date),lt_pay.PaymentModeID ");

            sb.Append("   UNION ALL");

            sb.Append(" SELECT DATE_FORMAT(rec.Date,'%d-%b-%Y')DATE,SUM(rec_pay.Amount)PaidAmount,rec_pay.PaymentMode FROM f_reciept Rec");
            sb.Append("   INNER JOIN f_receipt_paymentdetail rec_pay ON rec_pay.ReceiptNo=rec.ReceiptNo  ");
            sb.Append(" INNER JOIN employee_master em ON rec.Depositor=em.EmployeeID  ");
            sb.Append("  WHERE rec.Date>='" + startDate + "' AND rec.Date<='" + toDate + "' AND IFNULL(rec.AsainstLedgerTnxNo,'')=''");
            sb.Append(" GROUP BY DATE(rec.date),rec_pay.PaymentModeID)a  ");
            sb.Append(" GROUP BY DATE,PaymentMode ORDER BY DATE,PaymentMode ");

            DataTable dt1 = new DataTable();
            
            dt1 = StockReports.GetDataTable(sb.ToString());
            if (dt1.Rows.Count > 0)
            {
                lblMsg.Text = "";
                DataColumn dc = new DataColumn();
                dc.ColumnName = "Period";
                dc.DefaultValue = "From : " + Util.GetDateTime(ucFromDate.Text).ToString("dd-MMM-yyyy") + " To : " + Util.GetDateTime(ucToDate.Text).ToString("dd-MMM-yyyy");
                dt1.Columns.Add(dc);
                DataSet ds = new DataSet();
                ds.Tables.Add(dt1.Copy());


             //   ds.WriteXmlSchema(@"E:\\IncomeReportDatewise.xml");


                Session["ds"] = ds;
                Session["ReportName"] = "IncomeReportDatewise";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/Commonreport.aspx');", true);
            }
            else

            {
             //   lblMsg.Text = "Record Not Found";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
            }
    }
    private void FillDateTime()
    {
        ucFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        ucToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        

    }
}