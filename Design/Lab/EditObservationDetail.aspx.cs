using System;
using System.Data;

public partial class Design_Lab_EditObservationDetail : System.Web.UI.Page
{
    public string ObsId = "";
    public string InvId = "";
    

    protected void Page_Load(object sender, EventArgs e)
    {

        if (!IsPostBack)
        {
            ObsId = Request.QueryString["ObsId"].ToString();
            InvId = Request.QueryString["InvId"].ToString();
            BindMachine(ObsId);
            All_LoadData.bindCenterDropDownList(ddlCentre, Session["CentreID"].ToString(), "");
        }
    }
    private void BindMachine(string ObsId)
    {
        DataTable dt = StockReports.GetDataTable("SELECT MachineID TEXT,MachineID VALUE FROM labobservation_range  GROUP BY MachineID ");
        if (dt.Rows.Count > 0)
        {
            ddlMachine.DataSource = dt;
            ddlMachine.DataTextField = "TEXT";
            ddlMachine.DataValueField = "VALUE";
            ddlMachine.DataBind();
        }
    }
}
