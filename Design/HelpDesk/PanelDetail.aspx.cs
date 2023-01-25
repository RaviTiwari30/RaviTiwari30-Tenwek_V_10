using System;
using System.Data;
using System.Web.UI.WebControls;

public partial class Design_HelpDesk_PanelDetail : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindPanelGroup();
            BindPanels();
        }
       
    }

    private void BindPanelGroup()
    {
        DataTable dt = StockReports.GetDataTable("Select * from f_panelgroup where active=1 order by PanelGroup");

        ddlPanelGroup.DataSource = dt;
        ddlPanelGroup.DataTextField = "PanelGroup";
        ddlPanelGroup.DataValueField = "PanelGroup";
        ddlPanelGroup.DataBind();
        ddlPanelGroup.Items.Insert(0, new ListItem("Select", "0"));
    }

    private void BindPanels()
    {
        DataTable dtPanel = StockReports.GetDataTable("SELECT PanelID,Company_Name FROM f_panel_master");
        ddlPanel.DataSource = dtPanel;
        ddlPanel.DataTextField = "Company_Name";
        ddlPanel.DataValueField = "PanelID";
        ddlPanel.DataBind();
        ddlPanel.Items.Insert(0, new ListItem("Select", "0"));
    }
}