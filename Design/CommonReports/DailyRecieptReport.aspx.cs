using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;


public partial class Design_OPD_DailyRecieptReport : System.Web.UI.Page
{
    
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            FillDateTime();
            BindUser();                     
        }
        ucFromDate.Attributes.Add("readOnly", "true");
        ucToDate.Attributes.Add("readOnly", "true");
        
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        string user = GetSelection(cblUser);
        StringBuilder sb = new StringBuilder();
        if (chkIgnoreDate.Checked == true && ((txtfromreceipt.Text == "" || txtToreceipt.Text == "")||(txtfromreceipt.Text == "" && txtToreceipt.Text == "")))
        //if (((ucFromDate.Text == "" || ucToDate.Text == "") || (ucFromDate.Text == "" && ucToDate.Text == "")) && ((txtfromreceipt.Text == "" || txtToreceipt.Text == "") || (txtfromreceipt.Text == "" && txtToreceipt.Text == "")))
        {
            lblMsg.Text = "Kindly select date or Enter receipt No.";
            return;
        }
        sb.Append(" SELECT rec.ReceiptNo,AmountPaid,date_format(rec.DATE,'%d-%b-%Y')DATE,rec.TIME,rec.Depositor,IF(rec.TransactionID LIKE 'ISHHI%',rec.TransactionID,'')Transaction_ID,if(pm.PatientID<>'CASH002',CONCAT(PM.title,' ',PM.PName),(SELECT NAME FROM patient_general_master   WHERE AgainstLedgerTnxNo=rec.AsainstLedgerTnxNo))PName,em.Name USER,rec.IsCancel,CAST(GROUP_CONCAT(rec_pay.S_Amount,' ',pmm.PaymentMode) AS CHAR) PaymentMode,rec.CancelReason ");
        sb.Append(" FROM f_reciept rec INNER JOIN `f_ledgertransaction` lt ON lt.`LedgertransactionNo`=rec.`AsainstLedgerTnxNo` AND lt.`TypeOfTnx` IN ('Pharmacy-Issue','Pharmacy-Return') INNER JOIN patient_master pm ON rec.Depositor=pm.PatientID");
        
        sb.Append(" INNER JOIN employee_master em ON em.EmployeeID=rec.Reciever");
        sb.Append(" INNER JOIN f_receipt_paymentdetail rec_Pay ON rec.ReceiptNo=rec_pay.ReceiptNo");
        sb.Append("  INNER JOIN paymentmode_master pmm ON pmm.PaymentModeId=rec_pay.PaymentModeID ");       
        if (txtfromreceipt.Text != "" && txtToreceipt.Text != "")
        sb.Append(" AND rec.receiptNo >= '" + txtfromreceipt.Text + "' AND rec.receiptNo <= '" + txtToreceipt.Text + "' ");
        //if ((txtfromreceipt.Text == "" && txtToreceipt.Text == "") || (txtfromreceipt.Text == "" || txtToreceipt.Text == ""))
        if(chkIgnoreDate.Checked==false)
            sb.Append(" AND rec.Date>='" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + "' AND rec.Date<='" + Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + "' AND rec.Time>='" + Util.GetDateTime(txtFromTime.Text).ToString("HH:mm:ss") + "' AND rec.Time<='" + Util.GetDateTime(txtToTime.Text).ToString("HH:mm:ss") + "' ");
        if(user!="")
            sb.Append(" AND rec.Reciever in ("+user+") ");
        sb.Append(" GROUP BY rec.ReceiptNo");

        DataTable dtReceipt = StockReports.GetDataTable(sb.ToString());
        if (dtReceipt.Rows.Count > 0)
        {
            lblMsg.Text = "";
            sb = new StringBuilder();
           // sb.Append(" SELECT SUM(S_Amount)Amount,CONCAT(rec_Pay.PaymentMode,' ',S_Notation)PaymentMode ");
            sb.Append("    SELECT SUM(S_Amount)Amount,CONCAT(rec_Pay.PaymentMode)PaymentMode ");
            sb.Append(" FROM f_reciept rec INNER JOIN `f_ledgertransaction` lt ON lt.`LedgertransactionNo`=rec.`AsainstLedgerTnxNo` AND lt.`TypeOfTnx` IN ('Pharmacy-Issue','Pharmacy-Return') INNER JOIN patient_master pm ON rec.Depositor=pm.PatientID  ");
            sb.Append(" INNER JOIN f_receipt_paymentdetail rec_Pay ON rec.ReceiptNo=rec_pay.ReceiptNo AND rec.IsCancel IN (0) ");
           // sb.Append(" WHERE DATE(rec.date)>='" + (Convert.ToDateTime(ucFromDate.Text)).ToString("yyyy-MM-dd") + "'  AND DATE(rec.date)<='" + Convert.ToDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + "'  AND IsCancel IN (0) ");
            if (txtfromreceipt.Text != "" && txtToreceipt.Text != "")
                sb.Append(" AND rec.receiptNo >= '" + txtfromreceipt.Text + "' AND rec.receiptNo <= '" + txtToreceipt.Text + "' ");
            if (chkIgnoreDate.Checked == false)
                sb.Append(" AND rec.Date>='" + Util.GetDateTime(ucFromDate.Text).ToString("yyyy-MM-dd") + "' AND rec.Date<='" + Util.GetDateTime(ucToDate.Text).ToString("yyyy-MM-dd") + "' AND rec.Time>='" + Util.GetDateTime(txtFromTime.Text).ToString("HH:mm:ss") + "' AND rec.Time<='" + Util.GetDateTime(txtToTime.Text).ToString("HH:mm:ss") + "' ");
            if (user != "")
                sb.Append(" AND rec.Reciever in (" + user + ") ");
            //sb.Append(" GROUP BY rec_Pay.PaymentMode,S_Notation ");
            sb.Append(" GROUP BY rec_Pay.PaymentMode ");

            DataTable dtSummary = StockReports.GetDataTable(sb.ToString());
            ucFromDate.Text = Util.GetDateTime(ucFromDate.Text).ToString("dd-MMM-yyyy");
            ucToDate.Text   = Util.GetDateTime(ucToDate.Text).ToString("dd-MMM-yyyy");
            if (dtSummary.Rows.Count > 0)
            {
                DataColumn dc = new DataColumn();

                dc.DefaultValue = ucFromDate.Text + " " + "TO " + " " + ucToDate.Text;
                DataColumn dc1;

                dtReceipt.Columns.Add(dc);
                dc1 = new DataColumn();
                dc1.ColumnName = "UserName";
                dc1.DefaultValue = StockReports.GetUserName(Convert.ToString(Session["ID"])).Rows[0][0];
                dtReceipt.Columns.Add(dc1);
                DataSet ds = new DataSet();
                DataTable dtImg = All_LoadData.CrystalReportLogo();
               
                ds.Tables.Add(dtReceipt.Copy());
                ds.Tables[0].TableName = "Reciept";
                ds.Tables.Add(dtSummary.Copy());
                ds.Tables[1].TableName = "Summary";
                ds.Tables.Add(dtImg.Copy());
                ds.Tables[2].TableName = "logo";
                //ds.WriteXmlSchema("E:\\recieptwise.xml");
                Session["ds"] = ds;
                Session["ReportName"] = "RecieptWiseCollectionReportNew";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/Commonreport.aspx');", true);
            }
          
        }
        else
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM04','" + lblMsg.ClientID + "');", true);
    }
   

    private void BindUser()
    {
        DataTable dt = new DataTable();
        string str = "Select concat(em.Title,' ',Name)As Name,em.EmployeeID from employee_master em " +
            " inner join f_login flg on flg.EmployeeID = em.EmployeeID where em.IsActive=1 and flg.Active=1 " +
            " and flg.RoleID in (161,204) group by em.EmployeeID order by em.name ";

        dt = StockReports.GetDataTable(str);
        //dt = LabOPD.GetEmployeeList();

        if (dt.Rows.Count > 0)
        {
            cblUser.DataSource = dt;
            cblUser.DataTextField = "Name";
            cblUser.DataValueField = "EmployeeID";
            cblUser.DataBind();
        }


        switch (Util.GetString(Session["LoginType"]).ToUpper())
        {
            case "OPD":
            case "BILLING":
            case "PHARMACY":
            case "MIS":
                // case "EDP":
                if (Session["ID"].ToString() != "EMP001")
                {
                    string a = Session["ID"].ToString();
                    for (int i = 0; i < cblUser.Items.Count; i++)
                    {
                        if (Session["ID"].ToString() != cblUser.Items[i].Value)
                        {
                            cblUser.Items[i].Attributes.Add("style", "display:none;");
                            cblUser.Items[i].Selected = false;
                            //cblUser.Items[i].Enabled = false;
                        }
                        else
                        {
                            cblUser.Items[i].Selected = true;
                            cblUser.Items[i].Enabled = false;
                        }
                    }
                }
                else
                {
                    for (int i = 0; i < cblUser.Items.Count; i++)
                    {
                        cblUser.Items[i].Selected = true;
                    }
                }
                break;
        }
    }

    private void FillDateTime()
    {
        ucFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        ucToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        txtFromTime.Text = "00:00:00";
        txtToTime.Text = "23:59:59";

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
    protected void chkAll_CheckedChanged(object sender, EventArgs e)
    {      
            for (int i = 0; i < cblUser.Items.Count; i++)
                cblUser.Items[i].Selected = chkAll.Checked;     
    }
}
