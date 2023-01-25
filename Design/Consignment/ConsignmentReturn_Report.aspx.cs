using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Text;
using MySql.Data.MySqlClient;

public partial class Design_Consignment_Reports_ConsignmentReturn_Report : System.Web.UI.Page
{
    
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ViewState["RoleDept"] = Session["RoleID"].ToString();
            ViewState["EmpName"] = Session["LoginName"].ToString();
            ViewState["EmpID"] = Session["ID"].ToString();

            ViewState["ID"] = Session["ID"].ToString();
            ViewState["HOSPID"] = Session["HOSPID"].ToString();
            ViewState["DeptLedgerNo"] = Session["DeptLedgerNo"].ToString();
            txtSearch.Attributes.Add("onKeyPress", "doClick('" + btnWord.ClientID + "',event)");
            txtFromDate.Text = txtToDate.Text=DateTime.Now.ToString("dd-MMM-yyyy");
            BindItem();
            BindVendor();
            //GridViewHelper helper = new GridViewHelper(this.grdSearch, true);
            //helper.RegisterGroup("Date", true, false);
            //helper.RegisterSummary("RefundAmount", SummaryOperation.Sum, "Date");
            //helper.RegisterSummary("RetailAmount", SummaryOperation.Sum, "Date");
            //helper.RegisterSummary("NetAmount", SummaryOperation.Sum, "Date");
            //helper.RegisterSummary("RefundAmount", SummaryOperation.Sum);
            //helper.RegisterSummary("RetailAmount", SummaryOperation.Sum);
            //helper.RegisterSummary("NetAmount", SummaryOperation.Sum);
            //helper.GroupSummary += new GroupEvent(helper_Bug);
            //helper.GeneralSummary += new FooterEvent(helper_General);
        }

        //GridViewHelper helper = new GridViewHelper(this.grdSearch, true);
       
        //helper.RegisterGroup("ItemName", true, false);
        //helper.RegisterSummary("ReturnedQuantity", SummaryOperation.Sum, "ItemName");
        //helper.RegisterSummary("InititalCount", SummaryOperation.Count, "ItemName");

        //helper.RegisterGroup("ReturnDate", true, false);
        //helper.GroupSummary += new GroupEvent(helper_Bug);
       
     
    }


   
    private void helper_Bug(string groupName, object[] values, GridViewRow row)
    {
        if (groupName == null) return;

        //row.BackColor = Color.Bisque;

        row.Cells[0].HorizontalAlign = HorizontalAlign.Center;
        row.Cells[0].Text = "<b>[ Summary for " + groupName + " " + values[0] + " ]</b>";
    }
    public void SearchReturn()
    {

        DataTable dt = new DataTable();
        StringBuilder sb = new StringBuilder();
       
        sb.Append("  SELECT t2.ConsignmentNo, ");
        sb.Append(" t2.ReturnDate, ");
        sb.Append(" t2.ReturnNo, ");
        sb.Append(" Replace(t2.ITemID,'LSHHI','')ItemCode, ");
        sb.Append(" t2.itemname, ");
        sb.Append(" t2.BatchNumber, ");
        sb.Append("  t2.Rate, ");
        sb.Append(" t2.DiscountPer, ");
        sb.Append(" t2.Taxper, ");
        //sb.Append(" t2.InititalCount, ");
        //sb.Append(" t2.ReleasedCount, ");
        sb.Append(" t2.ReturnedQuantity, ");
        //sb.Append(" t2.BalanceQty, ");
        sb.Append(" t2.UnitPrice, ");
        sb.Append(" t2.MRP, ");
        sb.Append(" t2.VendorName, ");
        sb.Append(" t2.GateEntryNo, ");
        sb.Append(" t2.GatePassNo, ");
        sb.Append(" t2.ReturnReason, ");
        sb.Append(" t2.ReturnedBy ");
        sb.Append(" FROM ( ");
        sb.Append(" SELECT  ");
        sb.Append(" t1.*,  ");
        sb.Append(" (emp.name)    ReturnedBy,(lm.ledgerName)VendorName  ");
        sb.Append(" FROM (SELECT  ");
        sb.Append(" cond.GateEntryNo,  ");
        sb.Append(" cond.ID,  ");
        sb.Append(" cond.ConsignmentNo,  ");
        sb.Append(" DATE_FORMAT(cond.PostDate,'%d-%b-%y')    PostDate,  ");
        sb.Append(" cond.InititalCount,  ");
        sb.Append(" (IFNULL(cond.ReleasedCount,0)- IFNULL(conr.ReturnQuantity,0)) AS ReleasedCount,  ");
        sb.Append(" IFNULL(conr.ReturnQuantity,0)    ReturnedQuantity,  ");
        sb.Append(" IFNULL((cond.InititalCount-cond.ReleasedCount),0)    BalanceQty,  ");
        sb.Append(" cond.VendorLedgerNo,  ");
        sb.Append(" cond.ItemID,  ");
        sb.Append(" cond.itemname,  ");
        sb.Append(" cond.BatchNumber,  ");
        sb.Append("  cond.TaxPer, ");
        sb.Append(" cond.DiscountPer, ");
        sb.Append(" DATE_FORMAT(cond.MedExpiryDate,'%d-%b-%y')    MedExpiryDate,  ");
        sb.Append(" cond.UnitPrice,  ");
        sb.Append(" cond.Rate,  ");
        sb.Append(" cond.MRP,  ");

        sb.Append("  cond.DeptLedgerNo,  ");
        sb.Append(" cond.IsPost,  ");
        sb.Append(" cond.IsCancel,  ");
        sb.Append(" conr.ConsignmentReturnID,  ");
        sb.Append(" DATE_FORMAT(conr.ReturnDate,'%d-%b-%y')    ReturnDate,  ");
        sb.Append("   conr.ReturnNo, ");
        sb.Append(" conr.ReturnReason,  ");
        sb.Append(" conr.ConsignmentID,  ");
        sb.Append(" conr.ReturnByUserID,  ");
        sb.Append(" conr.GatePassNo  ");
        sb.Append(" FROM Consignmentdetail cond  ");
        sb.Append(" LEFT JOIN (SELECT  ");
        sb.Append(" ConsignmentID,  ");
        sb.Append(" IFNULL(ReturnQuantity,0)ReturnQuantity,  ");
        sb.Append(" GatePassNo,  ");
        sb.Append(" ItemID,  ");
        sb.Append(" VendorLedgerNo,  ");
        sb.Append(" ReturnByUserID,  ");
        sb.Append(" ReturnDate,  ");
        sb.Append(" ReturnReason,  ");
        sb.Append(" ReturnNo,  ");
        
        sb.Append(" ConsignmentReturnID  ");
        sb.Append(" FROM consignmentreturn  ");
        sb.Append(" WHERE  DATE(returnDate)>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + "'");
        sb.Append(" AND DATE(returnDate)<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "'");

        sb.Append(" ) conr  ");
        sb.Append(" ON conr.ConsignmentID = cond.ID) t1  ");
        sb.Append(" INNER JOIN employee_master emp  ");
        sb.Append(" ON t1.ReturnByuserID = emp.Employee_ID  ");
        sb.Append(" INNER JOIN f_ledgermaster lm ON lm.LedgerNumber=t1.VendorLedgerNo");
        sb.Append(" WHERE BalanceQty >= 0  ");

    if (ddlVendor.SelectedIndex>0)
        sb.Append(" AND VendorLedgerNo='" + ddlVendor.SelectedItem.Value.Split('#')[0] + "' ");
    if (ListBox1.SelectedIndex != -1)
        sb.Append(" AND ItemID='" + ListBox1 .SelectedItem.Value.ToString()+ "' ");
    if (txtConsignmentNo.Text.ToString()!=string.Empty)
        sb.Append(" AND ConsignmentNo='"+txtConsignmentNo.Text.ToString()+"' ");
    if (txtReturnNo.Text.ToString()!=string.Empty)
        sb.Append(" AND ReturnNo='" + txtReturnNo .Text.ToString()+ "' ");

        sb.Append(" AND IsPost = 1  ");
        sb.Append(" AND IsCancel = 0  ");
        sb.Append(" order by  returnDate desc ");
        sb.Append(" )t2 ");

        dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            Session["dtExport2Excel"] = dt;
            Session["ReportName"] = "Consignment Return Report";
            Session["Period"] = "From : " + txtFromDate.Text + " To : " + txtFromDate.Text;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/ExportToExcel.aspx');", true);
            //grdSearch.DataSource = dt;
            //grdSearch.DataBind();
            lblMsg.Text = "";
        }

        else
        {
            lblMsg.Text = "No records found";
          

        }

    }
    public void BindVendor()
    {

        string sql = "select concat(LedgerNumber,'#',LedgerUserID)ID,LedgerName from f_ledgermaster where groupID='VEN' and IsCurrent=1 order by LedgerName";
        DataTable dt = StockReports.GetDataTable(sql);

        if (dt.Rows.Count > 0)
        {
            ddlVendor.DataSource = dt;
            ddlVendor.DataTextField = "LedgerName";
            ddlVendor.DataValueField = "ID";
            ddlVendor.DataBind();

            ddlVendor.Items.Insert(0, "Select");
        }
        else
        {
            ddlVendor.Items.Clear();
            ddlVendor.DataSource = null;
            ddlVendor.DataBind();
        }

    }
    private void BindItem()
    {
        DataTable dtItem = new DataTable();

            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT (IM.Typename)ItemName,IM.ItemID ItemID");
            sb.Append(" from f_itemmaster IM inner join f_subcategorymaster SM on IM.SubCategoryID = SM.SubCategoryID");
            sb.Append(" INNER JOIN f_configrelation c ON c.CategoryID =SM.CategoryID WHERE c.ConfigID=11 AND IM.IsActive=1 and Typename<>'' AND IM.IsStent=1 ");
            if (txtSearch.Text.ToString() != string.Empty)
                sb.Append("AND IM.Typename like '%" + txtSearch.Text.Trim() + "%'");
            sb.Append("order by IM.Typename ");
            dtItem = StockReports.GetDataTable(sb.ToString());
        

        if (dtItem.Rows.Count > 0)
        {
            ListBox1.DataSource = dtItem;
            ListBox1.DataTextField = "ItemName";
            ListBox1.DataValueField = "ItemID";
            ListBox1.DataBind();
            txtSearch.Focus();
        }
        else
        {
            ListBox1.Items.Clear();
            ListBox1.Items.Add("No Item Found");

        }
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {

        SearchReturn();
    }

    protected void btnWord_Click(object sender, EventArgs e)
    {
        BindItem();
    }

    protected void btnReset_Click(object sender,EventArgs e)
    {
        txtSearch.Text = "";
        BindItem();
    }
    
}
