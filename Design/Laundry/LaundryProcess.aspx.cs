using System;
using System.Data;
using System.Text;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using AjaxControlToolkit;

public partial class Design_Laundry_LaundryProcess : System.Web.UI.Page
{
    

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            FrmDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            ToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtFromTime.Text = System.DateTime.Now.ToString("hh:mm tt");
            txtToTime.Text = System.DateTime.Now.ToString("hh:mm tt");
            ViewState["DeptLedgerNo"] = Session["DeptLedgerNo"].ToString();
            ViewState["LoginType"] = Session["LoginType"].ToString();
            bindDepartments();
            calFrmDate.StartDate = DateTime.Now;
            calToDate.StartDate = DateTime.Now;
        }
        FrmDate.Attributes.Add("readOnly", "true");
        ToDate.Attributes.Add("readOnly", "true");
    }
    private void bindDepartments()
    {
        string str = "SELECT LedgerName,LedgerNumber FROM f_ledgermaster WHERE GroupID='DPT' and LedgerNumber != '" + ViewState["DeptLedgerNo"].ToString() + "' ORDER BY LedgerName";
        DataTable dt = new DataTable();

        dt = StockReports.GetDataTable(str);

        if (dt.Rows.Count > 0)
        {
            ddlDept.DataSource = dt;
            ddlDept.DataTextField = "LedgerName";
            ddlDept.DataValueField = "LedgerNumber";
            ddlDept.DataBind();
            ddlDept.Items.Insert(0, new ListItem("All", "0"));
            ddlDept.SelectedIndex = ddlDept.Items.IndexOf(ddlDept.Items.FindByValue("0"));
            

        }
        else
        {
            ddlDept.Items.Clear();
        }

        int index = ddlDept.Items.IndexOf(ddlDept.Items.FindByText(ViewState["LoginType"].ToString()));
        if (index != -1)
        {
            ddlDept.Items[index].Selected = true;
            ddlDept.Items[index].Enabled = false;
        }
    }
}