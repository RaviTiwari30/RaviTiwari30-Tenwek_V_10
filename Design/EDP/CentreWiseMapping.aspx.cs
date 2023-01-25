using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_EDP_CentreWiseMapping : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.QueryString.Count > 0)
        {
            string centerid = Util.GetString(Request.QueryString["CID"]);
            lblselectedcenterid.Text = centerid;
        }
    }
}