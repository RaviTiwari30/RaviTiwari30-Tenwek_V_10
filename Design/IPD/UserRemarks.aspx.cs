using System;

public partial class Design_IPD_UserRemarks : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Request.QueryString["TransactionID"] != null && Request.QueryString["TransactionID"].ToString() != "")
            {
                lblTID.Text = Request.QueryString["TransactionID"].ToString();
            }
        }
    }
}