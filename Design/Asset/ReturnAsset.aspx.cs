using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Asset_ReturnAsset : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            AllLoadData_Store.bindTypeMaster(ddlRequestType);
            ddlRequestType.Items.Insert(0, new ListItem("Select", "0"));
            txtFromDate.Text = txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        }
    }
}