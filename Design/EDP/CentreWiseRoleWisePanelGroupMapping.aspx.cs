using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_EDP_CentreWiseRoleWisePanelGroupMapping : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string centerid = Util.GetString(Session["CentreID"].ToString());
        lblselectedcenterid.Text = centerid;
    }
}