using System;
using System.Data;

public partial class Design_OPD_IntercomSearch : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindIntercom();
            txtInBetweenSearch.Focus();
        }
    }
    private void BindIntercom()
    {
        DataTable dt = StockReports.GetDataTable("select CONCAT(Number,'#',Name)Name,CONCAT(Name,'#',Number)Number from InterComList where isActive=1 AND CentreID=" + Session["CentreID"].ToString() + " order by Name");
        if (dt.Rows.Count > 0)
        {
            lstIntercom.DataSource = dt;
            lstIntercom.DataTextField = "Name";
            lstIntercom.DataValueField = "Number";
            lstIntercom.DataBind();
        }
    }
}