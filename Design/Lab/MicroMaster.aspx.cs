using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Investigation_MicroMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            bindmaster();
        }
    }

    void bindmaster()
    {
      ddlmastertype.DataSource=  StockReports.GetDataTable("SELECT mastername,id FROM microtype_master");
      ddlmastertype.DataTextField = "mastername";
      ddlmastertype.DataValueField = "id";
      ddlmastertype.DataBind(); 

    }
}