using System;

public partial class Design_EDP_FrameRight : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            All_LoadData.bindRole(ddlLoginType);
            All_LoadData.BindIFrame(ddlFrame);
        }
    }
}