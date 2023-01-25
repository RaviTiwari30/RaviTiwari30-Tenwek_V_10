using System;
using System.Data;

public partial class Design_EDP_ThresholdMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
            LoadPanelData();
        AllLoadData_IPD.bindCaseType(ddlRoomType, "Select");
    }

    private void LoadPanelData()
    {
        string panelName = "SELECT RTRIM(LTRIM(Company_Name)) AS Company_Name,PanelID FROM f_panel_master WHERE PanelID IN (SELECT DISTINCT PanelID FROM (SELECT DISTINCT(ReferenceCodeOPD)PanelID FROM f_panel_master UNION ALL SELECT DISTINCT(ReferenceCode)PanelID FROM f_panel_master)t) ORDER BY Company_Name";
        DataTable dt = StockReports.GetDataTable(panelName);
        ddlPanel.DataSource = dt;
        ddlPanel.DataTextField = dt.Columns["Company_Name"].ToString();
        ddlPanel.DataValueField = dt.Columns["PanelID"].ToString();
        ddlPanel.DataBind();
        ddlPanel.SelectedIndex = 0;
    }
}