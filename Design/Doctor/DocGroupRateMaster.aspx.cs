using System;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Doctor_DocGroupRateMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            ViewState["ID"] = Session["ID"].ToString();
            LoadPanelOPD();
        }
    }

    private void LoadPanelOPD()
    {
        if (rdoOPDIPD.SelectedItem.Value == "OPD")
        {
            ddlPanel.DataSource = CreateStockMaster.LoadPanelCompanyRefOPDDoc();
            ddlPanel.DataTextField = "Company_Name";
            ddlPanel.DataValueField = "PanelID";
            ddlPanel.DataBind();
            ddlPanel.Items.Insert(0, new ListItem("Select", "0"));
        }
        if (rdoOPDIPD.SelectedItem.Value == "IPD")
        {
            ddlPanel.DataSource = CreateStockMaster.LoadPanelCompanyRefIPDDoc();
            ddlPanel.DataTextField = "Company_Name";
            ddlPanel.DataValueField = "PanelID";
            ddlPanel.DataBind();
            ddlPanel.Items.Insert(0, new ListItem("Select", "0"));
        }
    }

    protected void rdoOPDIPD_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (rdoOPDIPD.SelectedItem.Value == "IPD")
        {
            ddlPanel.DataSource = CreateStockMaster.LoadPanelCompanyRefIPDDoc();
            ddlPanel.DataTextField = "Company_Name";
            ddlPanel.DataValueField = "PanelID";
            ddlPanel.DataBind();
            ddlPanel.Items.Insert(0, new ListItem("Select", "0"));
        }
        if (rdoOPDIPD.SelectedItem.Value == "OPD")
        {
            ddlPanel.DataSource = CreateStockMaster.LoadPanelCompanyRefOPDDoc();
            ddlPanel.DataTextField = "Company_Name";
            ddlPanel.DataValueField = "PanelID";
            ddlPanel.DataBind();
            ddlPanel.Items.Insert(0, new ListItem("Select", "0"));
        }
    }
}