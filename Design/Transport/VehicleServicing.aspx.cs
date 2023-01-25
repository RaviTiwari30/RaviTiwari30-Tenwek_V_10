using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

public partial class Design_Transport_VehicleServicing : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            clCurrent.EndDate = DateTime.Now;
            clNext.StartDate = DateTime.Now;
            txtFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtCurServiceDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtNextServiceDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtMaintenanceDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtFuelDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            DriverBind();
            clMaintenance.EndDate = DateTime.Now;
            clFuelDate.EndDate = DateTime.Now;
        }

        txtCurServiceDate.Attributes.Add("readonly","readonly");
        txtNextServiceDate.Attributes.Add("readonly","readonly");
        txtMaintenanceDate.Attributes.Add("readonly", "readonly");
        txtFuelDate.Attributes.Add("readonly", "readOnly");
       
    }
    protected void DriverBind()
    {
        string str ="SELECT ID, NAME   FROM t_driver_master where CentreID="+Util.GetInt(Session["CentreID"])+" and IsActive=1" ;
        DataTable dt = StockReports.GetDataTable(str);
        ddlDriver.DataSource = dt;
        ddlDriver.DataTextField = "NAME";
        ddlDriver.DataValueField = "ID";
        ddlDriver.DataBind();
        ddlDriver.Items.Insert(0, new ListItem("Select", "0"));
        
    }

   
}