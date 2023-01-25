using System;
using System.Data;
using System.Web.UI;
using System.Text;

public partial class Design_OPD_RefundReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ucFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            ucToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            All_LoadData.bindCentre(chkCentre, Session["ID"].ToString(), btnSearch);
        }
        ucFromDate.Attributes.Add("readOnly", "true");
        ucToDate.Attributes.Add("readOnly", "true");
    }


    protected void btnSearch_Click(object sender, EventArgs e)
    {
        string Centre = All_LoadData.SelectCentre(chkCentre);
        if (Centre == "")
        {
            lblMsg.Text = "Please Select Centre";
            return;
        }
        DataTable dt = new DataTable();
        lblMsg.Text = "";
        StringBuilder sb = new StringBuilder();
        sb.Append("Select CONCAT(pm.Title,' ',pm.Pname)PatientName,t.Date,em.Name User, ReceiptNo,CaseType, ");
        sb.Append("REPLACE(Depositor,'LSHHI','')MRNo,t.CentreID,t.CentreName, IF(CaseType='IPD',REPLACE(t.TransactionID,'ISHHI',''),'') IPNO,Round(AmountPaid)AmountPaid,DoctorName,Naration,BillNo from ");
        sb.Append("(Select ReceiptNo,if( rec.AsainstLedgerTnxNo <>'','OPD','IPD')CaseType,rec.TransactionID,Reciever,cm.CentreName,cm.CentreID,Depositor,Date_Format( rec.Date,'%d-%b-%Y')Date, ");
        sb.Append("IFNULL((Select DiscountReason from f_ledgertransaction where ledgertransactionNo=rec.AsainstLedgerTnxNo),rec.Naration)Naration,");
        sb.Append("Replace(AmountPaid,'-','')AmountPaid, (select CONCAT(Title,' ',Name)DoctorName from doctor_master where DoctorID=pmh.DoctorID)DoctorName, ");
        sb.Append("if( rec.AsainstLedgerTnxNo <>'',");
        sb.Append("(Select BillNo from f_ledgertransaction where ledgertransactionNo=rec.AsainstLedgerTnxNo),");
        sb.Append("(Select BillNo from patient_medical_history where TransactionID=pmh.TransactionID))BillNo, ");
        sb.Append("IF(pmh.Type<>'IPD',IF((SELECT COUNT(*) FROM f_ledgertnxdetail ltd WHERE ltd.LedgerTransactionNo=lt.LedgertransactionNo AND ltd.IsVerified=1 AND ltd.TypeofTnx IN ('CR','DR'))>0,1,0),0) IsCRDR   ");
        sb.Append("FROM f_reciept rec LEFT JOIN f_ledgertransaction lt ON rec.`AsainstLedgerTnxNo`=lt.`LedgerTransactionNo` AND lt.`TypeOfTnx`NOT IN ('Pharmacy-Return','Patient-Return') INNER JOIN patient_medical_history pmh on rec.TransactionID=pmh.TransactionID  INNER JOIN Center_master cm ON cm.CentreID=pmh.CentreID  ");
        sb.Append("WHERE AmountPaid < 0  and pmh.CentreID IN (" + Centre + ") and  rec.IsCancel=0 and  rec.date >='" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + "' and  rec.date <='" + Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + "'  ) t inner join patient_master pm on ");
        sb.Append("pm.PatientID = t.Depositor inner join employee_master em on em.EmployeeID = t.Reciever WHERE IsCRDR=0  ");
        if (rbtnReportType.SelectedValue == "2")
        {
            sb.Append("  AND t.casetype='OPD'");
        }
        else if (rbtnReportType.SelectedValue == "3")
        {
            sb.Append("  AND t.casetype='IPD'");
        }
        sb.Append(" order by Date,t.CaseType,ReceiptNo ");

        dt = StockReports.GetDataTable(sb.ToString());

        if (dt.Rows.Count > 0)
        {
            if (rdbtype.SelectedValue == "P")
            {
                DataSet ds = new DataSet();
                ds.Tables.Add(dt.Copy());
                DataColumn dc = new DataColumn("Period");
                dc.DefaultValue = "From " + Util.GetDateTime(ucFromDate.Text).ToString("dd-MMM-yyyy") + " To " + Util.GetDateTime(ucToDate.Text).ToString("dd-MMM-yyyy");
                ds.Tables[0].Columns.Add(dc);
                DataTable dtImg = All_LoadData.CrystalReportLogo();
                ds.Tables.Add(dtImg.Copy());
                Session["ds"] = ds;
                Session["ReportName"] = "RefundReport";
                // ds.WriteXmlSchema("E:/Refund.xml");
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/Commonreport.aspx');", true);
            }
            else if (rdbtype.SelectedValue == "E")
            {
                dt.Columns.Remove("CentreID");
               // dt.Columns.Remove("ReceiptNo");

                dt.Columns["PatientName"].SetOrdinal(0);
                dt.Columns["MRNo"].SetOrdinal(1);
                dt.Columns["IPNO"].SetOrdinal(2);
                dt.Columns["Date"].SetOrdinal(3);
                dt.Columns["BillNo"].SetOrdinal(4);
                dt.Columns["ReceiptNo"].SetOrdinal(5);
                dt.Columns["AmountPaid"].SetOrdinal(6);
                dt.Columns["CaseType"].SetOrdinal(7);
                dt.Columns["DoctorName"].SetOrdinal(8);
                dt.Columns["Naration"].SetOrdinal(9);
                dt.Columns["User"].SetOrdinal(10);

                dt.Columns["AmountPaid"].ColumnName = "RefundedAmount";
                dt.Columns["MRNo"].ColumnName = "UHID";
                DataRow dr = dt.NewRow();
                dr[4] = "Total : ";
                dr["RefundedAmount"] = Util.GetFloat(dt.Compute("sum([RefundedAmount])", "")).ToString("f2");
                dt.Rows.InsertAt(dr, dt.Rows.Count + 1);

                Session["ReportName"] = "Refund Report";
                Session["dtExport2Excel"] = dt;
                Session["Period"] = "Period From : " + ucFromDate.Text.Trim() + " To : " + ucToDate.Text.Trim();
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/ExportToExcel.aspx');", true);
            }
        }
        else
        {

            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
        }
    }
}
