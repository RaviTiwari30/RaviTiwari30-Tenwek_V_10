using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_OPD_ExpenseRePrint : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtfromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");         
            bindExpenceType();
        }
        txtfromDate.Attributes.Add("readOnly", "true");
        txtToDate.Attributes.Add("readOnly", "true");
    }

    private void bindExpenceType()
    {
        ddlExpenceType.DataSource = StockReports.GetDataTable("SELECT id,ExpenceHead FROM f_expencehead WHERE active=1");
        ddlExpenceType.DataTextField = "ExpenceHead";
        ddlExpenceType.DataValueField = "id";
        ddlExpenceType.DataBind();
        ddlExpenceType.Items.Insert(0, new ListItem("Select"));
    }

    protected void ddlExpenceType_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlExpenceType.SelectedIndex == 0)
        {
           
            ddlExpenceTo.Visible = false;
            txtExpenceType.Visible = false;
        }
        else if (ddlExpenceType.SelectedIndex == ddlExpenceType.Items.Count - 1)
        {
          
            ddlExpenceTo.Visible = false;
            txtExpenceType.Visible = true;
        }
        else if (ddlExpenceType.SelectedIndex == 1)
        {
           // bindDoctors();
            bindOverhead();
            ddlExpenceTo.Visible = true;
           
            txtExpenceType.Visible = false;
        }
        else if (ddlExpenceType.SelectedIndex == 2)
        {
            // bindVendors();
            bindDepartmental();
            ddlExpenceTo.Visible = true;
        
            txtExpenceType.Visible = false;
        }
        else if (ddlExpenceType.SelectedIndex == 3)
        {
            bindEmployee();
            ddlExpenceTo.Visible = true;
   
            txtExpenceType.Visible = false;
        }
    }

    private void bindOverhead()
    {
        ddlExpenceTo.DataSource = StockReports.GetDataTable("SELECT subhead_ID,subhead_name FROM f_expencesubhead WHERE expns_type='overhead Expenses' and isActive=1 ORDER BY subhead_name asc");
        ddlExpenceTo.DataValueField = "subhead_ID";
        ddlExpenceTo.DataTextField = "subhead_name";
        ddlExpenceTo.DataBind();
        ddlExpenceTo.Items.Insert(0, new ListItem("Select", "0"));
    }

    //private void bindVendors()
    //{
    //    ddlExpenceTo.DataSource = StockReports.GetDataTable("SELECT Vendor_ID,VendorName FROM f_vendormaster order by VendorName asc ");
    //    ddlExpenceTo.DataValueField = "Vendor_ID";
    //    ddlExpenceTo.DataTextField = "VendorName";
    //    ddlExpenceTo.DataBind();
    //    ddlExpenceTo.Items.Insert(0, new ListItem("Select","0"));
    //}

    private void bindEmployee()
    {
        ddlExpenceTo.DataSource = StockReports.GetDataTable("SELECT Employee_ID,CONCAT(Title,' ',NAME)NAME FROM employee_master WHERE isactive=1 ORDER BY NAME asc");
        ddlExpenceTo.DataValueField = "Employee_ID";
        ddlExpenceTo.DataTextField = "NAME";
        ddlExpenceTo.DataBind();
        ddlExpenceTo.Items.Insert(0, new ListItem("Select", "0"));
    }

    //private void bindDoctors()
    //{
    //    ddlExpenceTo.DataSource = StockReports.GetDataTable("SELECT DoctorID,CONCAT('Dr. ',NAME) NAME FROM doctor_master WHERE isActive=1 ORDER BY NAME asc");
    //    ddlExpenceTo.DataValueField = "DoctorID";
    //    ddlExpenceTo.DataTextField = "name";
    //    ddlExpenceTo.DataBind();
    //    ddlExpenceTo.Items.Insert(0, new ListItem("Select", "0"));
    //}

    private void bindDepartmental()
    {
        ddlExpenceTo.DataSource = StockReports.GetDataTable("SELECT subhead_ID,subhead_name FROM f_expencesubhead WHERE expns_type='Direct Expenses' and isActive=1 ORDER BY subhead_name asc");
        ddlExpenceTo.DataValueField = "subhead_ID";
        ddlExpenceTo.DataTextField = "subhead_name";
        ddlExpenceTo.DataBind();
        ddlExpenceTo.Items.Insert(0, new ListItem("Select", "0"));
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        Search();
    }

    protected void Search()
    {
        lblMsg.Text = "";    
        DataTable dtSearch = SearchExpenseReceipt(Util.GetDateTime(txtfromDate.Text), Util.GetDateTime(txtToDate.Text));
        if (dtSearch != null && dtSearch.Rows.Count > 0)
        {
            lblMsg.Text = dtSearch.Rows.Count + " Record(s) Found.";
            grdExpense.DataSource = dtSearch;
            grdExpense.DataBind();
            pnlHide.Visible = true;
        }
        else
        {
            lblMsg.Text = "Record Not Found";
            grdExpense.DataSource = null;
            grdExpense.DataBind();
            pnlHide.Visible = false;
        }
    }


    public DataTable SearchExpenseReceipt(DateTime FromDate, DateTime ToDate)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT rec.ReceiptNo,DATE_FORMAT(rec.Date,'%d-%b-%Y')DATE,ExpenceType,ExpenceTo,IF(AmountPaid<0,(-1)*AmountPaid,AmountPaid)Amount,IF(AmountPaid<0,'Received','Paid')Type,CONCAT(emp.Title,' ',emp.Name)Depositor FROM f_reciept_expence rec ");
        sb.Append("INNER JOIN employee_master emp ON rec.Depositor=emp.Employee_ID ");
        sb.Append("WHERE rec.IsCancel=0 AND DATE(rec.Date)>='" + FromDate.ToString("yyyy-MM-dd") + "' AND DATE(rec.Date)<='" + ToDate.ToString("yyyy-MM-dd") + "'");

        if (ddlExpenceType.SelectedIndex>0 && ddlExpenceTo.SelectedIndex > 0)
        {
            sb.Append("AND rec.ExpenceTo='"+ddlExpenceTo.SelectedItem.Text+"'");
        }

        if(rdotype.SelectedIndex==0)
            sb.Append("AND rec.AmountPaid>=0");
        else if (rdotype.SelectedIndex == 1)
            sb.Append(" AND rec.AmountPaid<0");

        sb.Append(" order by rec.ReceiptNo");
        return StockReports.GetDataTable(sb.ToString());

    }
    protected void grdExpense_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Print")
        {
            string type = "",ReceiptNo="";
            ReceiptNo = Util.GetString(e.CommandArgument).Split('#')[0].ToString();
            type = Util.GetString(e.CommandArgument).Split('#')[1].ToString();

            if (type == "Received")
                type = "RECEIVED";
            else
                type = "PAID";

            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Design/Common/PrintExpense.aspx?id=" + ReceiptNo.ToString() + "&type=" + type + " ');", true);           
        }
    }
}