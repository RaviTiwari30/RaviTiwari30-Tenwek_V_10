using System;
using System.Data;
using MySql.Data.MySqlClient;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Text;

public partial class Design_FrontOffice_ScreenMaster : System.Web.UI.Page
{

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {          
            lblMsg.Text = "";
            BindScreen();
        }              
    }

    private void BindScreen()
    {
        string sqlScreen = "select id,Name from Screen_Master where isactive=1";
        DataTable dt = StockReports.GetDataTable(sqlScreen);
        if (dt.Rows.Count > 0)
        {

            ddlScreenName.DataSource = dt;
            ddlScreenName.DataTextField = "Name";
            ddlScreenName.DataValueField = "id";
            ddlScreenName.DataBind();
            ddlScreenName.Items.Insert(0, "Select");
        }

    }

    protected void btnDisplay_Click(object sender, EventArgs e)
    {
        if (ddlScreenName.SelectedIndex==0)
        {
            lblMsg.Text = "Please select Screen Name ..";            
            return;
        }
        Response.Redirect("DisplayScreen.aspx?ScreenID="+ddlScreenName.SelectedValue+"");     
    }        
}
