using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Text;

public partial class Design_OPD_ExpenseReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ucFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            ucToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            BindGroups();
            ViewState["UserID"] = Session["ID"].ToString();
            All_LoadData.bindCentre(chkCentre, Session["ID"].ToString(), btnReport);
            ddlGroups_SelectedIndexChanged(sender, e);
            chkSubGroups_CheckedChanged(sender, e);            
        }
        ucFromDate.Attributes.Add("readOnly", "true");
        ucToDate.Attributes.Add("readOnly", "true");

    }
    protected void btnReport_Click(object sender, EventArgs e)
    {
        Search();

    }

    private void BindGroups()
    {
        string str = "SELECT id,expencehead FROM `f_expencehead` WHERE active=1 order by expencehead ";
        DataTable dt = StockReports.GetDataTable(str);
        if (dt.Rows.Count > 0)
        {
            ddlGroups.DataSource = dt;
            ddlGroups.DataTextField = "expencehead";
            ddlGroups.DataValueField = "id";
            ddlGroups.DataBind();
            ListItem li = new ListItem("ALL", "ALL");
            ddlGroups.Items.Add(li);
            ddlGroups.SelectedIndex = ddlGroups.Items.IndexOf(ddlGroups.Items.FindByText("ALL"));
            lblMsg.Text = "";
        }
        else
        {
            ddlGroups.Items.Clear();
            lblMsg.Text = "No Groups Found";
        }
    }
    protected void ddlGroups_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindSubGroups();
        chkSubGroups_CheckedChanged(sender, e);
    }
    private void BindSubGroups()
    {
        string str = "SELECT subhead_id,subhead_name FROM `f_expencesubhead` WHERE expns_type ";
        if (ddlGroups.SelectedItem.Text == "ALL")
            str = str + " in ('Direct Expenses','Overhead Expenses')";
        else
            str = str + "  ='" + ddlGroups.SelectedItem.Text.Trim() +"' ";
        str += " order by subhead_name ";
        DataTable dt = StockReports.GetDataTable(str);
        if (dt.Rows.Count > 0)
        {
            chlSubGroups.DataSource = dt;
            chlSubGroups.DataTextField = "subhead_name";
            chlSubGroups.DataValueField = "subhead_id";
            chlSubGroups.DataBind();
            lblMsg.Text = "";
        }
        else
        {
            chlSubGroups.Items.Clear();
            lblMsg.Text = "No Sub-Groups Found";
        }

    }
    protected void chkSubGroups_CheckedChanged(object sender, EventArgs e)
    {
        for (int i = 0; i < chlSubGroups.Items.Count; i++)
            chlSubGroups.Items[i].Selected = chkSubGroups.Checked;
    }

    protected void Search()
    {

        lblMsg.Text = "";


        string Centre = All_LoadData.SelectCentre(chkCentre);
        if (Centre == "")
        {
            lblMsg.Text = "Please Select Centre";
            return;
        }
        string SubGroups = StockReports.GetSelection(chlSubGroups);
        if (SubGroups == "")
        {
            lblMsg.Text = "Please Select SubGroups";
            return;
        }

        DataTable dtSearch = ExpenseReport(Util.GetDateTime(ucFromDate.Text), Util.GetDateTime(ucToDate.Text));

        if (dtSearch != null && dtSearch.Rows.Count > 0)
        {
            DataColumn dc = new DataColumn();
            dc.ColumnName = "ReportDate";
            dc.DefaultValue = "From : " + Util.GetDateTime(ucFromDate.Text).ToString("dd-MMM-yyyy") + " To : " + Util.GetDateTime(ucToDate.Text).ToString("dd-MMM-yyyy");
            dtSearch.Columns.Add(dc);
            dc = new DataColumn();
            dc.ColumnName = "EmpName";
            dc.DefaultValue = StockReports.GetUserName(Convert.ToString(Session["ID"])).Rows[0][0];
            dtSearch.Columns.Add(dc);
           

            DataTable dtImg = All_LoadData.CrystalReportLogo();

            DataSet ds = new DataSet();
            ds.Tables.Add(dtImg.Copy());
            ds.Tables[0].TableName = "Logo";
            ds.Tables.Add(dtSearch.Copy());
            ds.Tables[1].TableName = "table";
           // ds.WriteXmlSchema(@"D:\ExpenseReport.xml");
            if (rdoReportType.SelectedItem.Value == "0")
            {
                Session["ds"] = ds;
                Session["ReportName"] = "ExpenseDateWiseReport";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Design/common/Commonreport.aspx');", true);
            }
            else
            {
                dtSearch.Columns.Remove("TransactionID");
                dtSearch.Columns.Remove("BillNo");
                dtSearch.Columns.Remove("MRNo");
                dtSearch.Columns.Remove("Age");
                dtSearch.Columns.Remove("TypeOfTnx");
                dtSearch.Columns.Remove("NetAmount");
                dtSearch.Columns.Remove("RoundOff");
                dtSearch.Columns.Remove("EmpName");
                dtSearch.Columns.Remove("ReportDate");
                dtSearch.Columns.Remove("Payment");
                Session["dtExport2Excel"] = dtSearch;
                Session["ReportName"] = "ExpenseDateWiseReport";                
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/common/ExportToExcel.aspx');", true);
            }
        }
        else
        {
            lblMsg.Text = "Record Not Found";
        }
    }

    private DataTable ExpenseReport(DateTime FromDate, DateTime ToDate)
    {
        string FromDate1 = (FromDate).ToString("yyyy-MM-dd");
        string Todate1 = (ToDate).ToString("yyyy-MM-dd");
        string SubGroups = StockReports.GetSelection(chlSubGroups);

        StringBuilder sb1 = new StringBuilder();
        
        sb1.Append("  SELECT fre.ExpenceType AS ExpenceType,'' TransactionID,'' BillNo,fre.ReceiptNo,fre.ExpenceToId AS MRNo, fre.ExpenceTo Pname,'' Age,'Expence' AS  TypeOfTnx,fre.Date DATE, ");
        sb1.Append("  fre.AmountPaid*-1 NetAmount,fre.AmountPaid As PaidAmount,'' RoundOff,CONCAT('CASH:',fre.AmountPaid*-1)Payment ,Em.Name AS UserName,fre.Naration ");
        sb1.Append("  FROM f_reciept_expence fre INNER JOIN employee_master em  ON fre.Depositor=em.EmployeeID AND fre.isCancel=0   ");
       
        sb1.Append("  AND fre.Date >= '" + FromDate1 + "'  ");
        sb1.Append("  AND fre.Date <= '" + Todate1 + "'    ");
        sb1.Append("  where fre.ExpenceToId in (" + SubGroups + ") ");
        sb1.Append("  Order by ExpenceType,receiptno ");

        return StockReports.GetDataTable(sb1.ToString());
    }
    


}