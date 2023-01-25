using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using System.Data;

public partial class Design_Mortuary_Mortuary_Menu : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            lblCorpseID.Text = Request.QueryString["CorpseID"].ToString();
            lblTransactionID.Text = Request.QueryString["TransactionID"].ToString();
            lblRoleID.Text = Session["RoleID"].ToString();
        }
    }
}