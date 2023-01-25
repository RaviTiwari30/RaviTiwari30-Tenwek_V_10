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
using System.IO;
using System.Drawing;

public partial class Design_Recovery_TPAInvoiceSearch : System.Web.UI.Page
{
    DataTable dtTPAInvoice = new DataTable();
    protected void Page_Load(object sender, EventArgs e)    
    {
        if (!IsPostBack)
        {
            ViewState["RoleDept"] = Session["RoleID"].ToString();
            ViewState["EmpName"] = Session["LoginName"].ToString();
            ViewState["EmpID"] = Session["ID"].ToString();
            DataTable dtAuthority = StockReports.GetAuthorization(Util.GetInt(Session["RoleID"]), Util.GetString(Session["ID"]));
            ViewState["Authority"] = dtAuthority;
            FrmDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            ToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            cdTo.EndDate = System.DateTime.Now;
            
            BindPanel();
        }
    }

    private void BindPanel()
    {
        DataTable dtPanel = new DataTable();
        dtPanel = StockReports.GetDataTable("SELECT PanelID,Company_Name FROM f_panel_master where IsActive=1 ORDER BY Company_Name");
        ddlPanelCompany.DataSource = dtPanel;
        ddlPanelCompany.DataTextField = "Company_Name";
        ddlPanelCompany.DataValueField = "PanelID";
        ddlPanelCompany.DataBind();
        ddlPanelCompany.Items.Insert(0, new ListItem("ALL", "ALL"));
        ddlPanelCompany.SelectedIndex = 0;
    }


   
}
