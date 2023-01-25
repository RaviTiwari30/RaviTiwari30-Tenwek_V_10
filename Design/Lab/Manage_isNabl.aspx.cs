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
using System.Web.Services;
using System.Text;
using System.IO;

public partial class Design_Lab_Manage_isNabl : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            bindcentre();
            LoadSubCategory();
        }

    } 
    private void LoadSubCategory()
    {
        DataTable dt = AllLoadData_OPD.BindLabRadioDepartment(HttpContext.Current.Session["RoleID"].ToString());
        if (dt != null && dt.Rows.Count > 0)
        {
            ddlSubCategory.DataSource = dt;
            ddlSubCategory.DataTextField = "Name";
            ddlSubCategory.DataValueField = "ObservationType_ID";
            ddlSubCategory.DataBind();
            ddlSubCategory.SelectedIndex = 0;
            ddlSubCategory.Items.Insert(0, new ListItem("Select", "0"));
        }
        else
            ddlSubCategory.Items.Insert(0, new ListItem("---Select---", "0#"));
    }
    private void bindcentre()
    {
        string mystr = "SELECT CentreID,CentreName AS Centre FROM center_master  where isActive='1' order by centre";
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(mystr);
        ddlCentre.DataSource = dt;
        ddlCentre.DataTextField = "Centre";
        ddlCentre.DataValueField = "CentreID";
        ddlCentre.DataBind();
    } 
}
